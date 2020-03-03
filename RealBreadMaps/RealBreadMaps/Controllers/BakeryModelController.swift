//
//  PlaceDetailsFetch.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//
// https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJsyPVS2jwwIcRgxML7BXE7eQ&key=APIKEYGOESHERE


import UIKit
import CoreLocation
import Firebase

class BakeryModelController {
    
    // MARK: - Properties
    
    // Singleton
    static let shared = BakeryModelController()
    private init () {}
    
    // Establish a connection to Firebase database
    var ref = Database.database().reference()
    
    // Holds the search result returned
    //var bakery: Bakery?
    
    // Holds the user's location retrieved from CLLocationManager
    var userLocation: CLLocationCoordinate2D!
    
    // Holds locations needed for Bakery computed property
    var locationOfBakery: CLLocation?
    var locationOfUser: CLLocation?
    
    // Holds current bakery in focus
    var currentBakeryName: String?
    var currentBakeryAddress: String?
    
    // Array to hold saved bakeries
    //var bakeries: [Bakery] = []
    var firebaseBakeries: [FirebaseBakery] = []
    var bakeryObjects: [BakeryObject] = []

    // Array to hold saved photo references
    var photoReferences: [PhotoReferences] = []
    
    // Base URLs for network calls
    let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
    let firebaseBaseURL = URL(string: "https://realbreadmaps.firebaseio.com/")!

    // API Key
    let apiKey = GMSPlacesClientApiKey
    
    // Completion Handler to be used with closures
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Firebase Networking
    
    // Fetches all bakeries from Firebase and saves them in an array of FirebaseBakeries
    func fetchAllBakeries(completion: @escaping CompletionHandler = { _ in }) {
        
        // Create a request URL
        let requestURL = firebaseBaseURL.appendingPathExtension("json")
        
        // Decode the data
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error ) in
            
            // Unwrap the error if there is one
            if let error = error {
                NSLog("Error fetching placeIDs from Firebase: \(error)")
                completion(error)
                return
            }
            
            // Unwrap data
            guard let data = data else {
                NSLog("No data returned from fetch for placeIDs.")
                completion(NSError())
                return
            }
            
            // Create an instance of JSON decoder
            let jsonDecoder = JSONDecoder()
            
            // Convert the data to our object
            do {
                
                let responseDictionary = try jsonDecoder.decode([String: FirebaseBakery].self, from: data)
                
                // Pull out the values from the returned response, which is a dictionary (due to Firebase format)
                let decodedResponse = responseDictionary.map( {$0.value} )
                
                // Assign the response of bakeries to the local array
                self.firebaseBakeries = decodedResponse

            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    // MARK: - Google API Networking to be called in order to update Firebase once per month
    
    // Fetches additional info from Google using the placeID of each fetched FirebaseBakery
    // Saves the info as a Bakery object in the Bakeries array
    func getBakeryInfo(with placeID: String, completion: @escaping CompletionHandler = { _ in }) {
        
        /*
         Adding FIELDS parameter limits the API call billings
         https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJsyPVS2jwwIcRgxML7BXE7eQ
         &fields=name,geometry,formatted_address,international_phone_number,website,opening_hours,photos
         &key=APIKEYGOESHERE
         */
        
        // Create request URL
        
        // Build up the endpoint
        var bakeryURL = baseURL.appendingPathComponent("details")
        
        bakeryURL = bakeryURL.appendingPathComponent("json")
        
        // Decompose into components needed
        var components = URLComponents(url: bakeryURL, resolvingAgainstBaseURL: true)
        
        // Add queries
        let searchQueryItem = URLQueryItem(name: "placeid", value: placeID)
        let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
        let fieldsQueryItem = URLQueryItem(name: "fields", value: "name,geometry,place_id,formatted_address,international_phone_number,website,opening_hours,photos")
        
        components?.queryItems = [searchQueryItem, fieldsQueryItem, apiKeyQueryItem]
        
        // Make a URL out of the components, recomposing al individual components back to a full URL
        guard let requestURL = components?.url else {
            NSLog("Couldn't make requestURL from \(components)")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        // Decode the data
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            // Unwrap error
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            // Unwrap data
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            // Create instance of JSON decoder
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Convert the data to our object
            do {
                let decodedBakery = try jsonDecoder.decode(BakeryResult.self, from: data)
                
                // Make sure that the photos in the decoded object are not nil
                guard let photos = decodedBakery.result.photos else { return }
                var photoReferenceStrings: [String] = []
                
                // Append each photo reference string to an array
                for eachPhotoReference in photos {
                    photoReferenceStrings.append(eachPhotoReference.photoReference)
                }
                
                // Create an instance of a BakeryObject using the retrieved data from the Google Places API
                let newBakeryObject = BakeryObject(name: decodedBakery.result.name,
                                                   placeId: decodedBakery.result.placeId,
                                                   lat: decodedBakery.result.geometry.location.lat,
                                                   lng: decodedBakery.result.geometry.location.lng,
                                                   formattedAddress: decodedBakery.result.formattedAddress,
                                                   internationalPhoneNumber: decodedBakery.result.internationalPhoneNumber ?? "Phone number unavailable",
                                                   website: decodedBakery.result.website,
                                                   weekdayText: decodedBakery.result.openingHours?.weekdayText ?? [""],
                                                   photos: photoReferenceStrings,
                                                   milledInHouse: nil,
                                                   organic: nil,
                                                   sellsLoaves: nil,
                                                   servesFood: nil,
                                                   info: nil)
                
                // MARK: - Call the following function after each addition to Firebase & 1x per week to update the Firebase with Google info
                // Also uncomment the call to getBakeryInfo() in MapViewController
                // Update firebase with the google information retrieved for each bakery
                self.updateFirebase(bakery: newBakeryObject)
                
                // Add the new bakery object to an array
                self.bakeryObjects.append(newBakeryObject)
            
                completion(nil)
                return
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    // Update firebase with information from Google Places API
    func updateFirebase(bakery: BakeryObject) {
        
        //ref.child("\(bakery.placeId)").updateChildValues(["name": bakery.name])
        
        ref.child("\(bakery.placeId)").child("name").setValue(bakery.name)
        ref.child("\(bakery.placeId)").child("lat").setValue(bakery.lat)
        ref.child("\(bakery.placeId)").child("lng").setValue(bakery.lng)
        ref.child("\(bakery.placeId)").child("formattedAddress").setValue(bakery.formattedAddress)
        ref.child("\(bakery.placeId)").child("internationalPhoneNumber").setValue(bakery.internationalPhoneNumber)
        ref.child("\(bakery.placeId)").child("website").setValue(bakery.website)
        ref.child("\(bakery.placeId)").child("weekdayText").setValue(bakery.weekdayText)
        ref.child("\(bakery.placeId)").child("photos").setValue(bakery.photos)

    }
    
}

