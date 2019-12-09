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
    
    // Singleton
    static let shared = BakeryModelController()
    private init () {}
    
    // Establish a connection to Firebase database
    var ref = Database.database().reference()
    
    // Holds the search result returned
    var bakery: Bakery?
    
    // Holds the user's location
    var userLocation: CLLocationCoordinate2D!
    
    // Holds locations needed for Bakery computed property
    var locationOfBakery: CLLocation?
    var locationOfUser: CLLocation?
    
    // Holds current bakery in focus
    var currentBakeryName: String?
    var currentBakeryAddress: String?
    
    // Array to hold saved bakeries
    var bakeries: [Bakery] = []
    var firebaseBakeries: [FirebaseBakery] = []
    var bakeryObjects: [BakeryObject] = []

    // Array to hold saved photo references
    var photoReferences: [PhotoReferences] = []
    
    // Base URLs for network calls
    let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
    let firebaseBaseURL = URL(string: "https://realbreadmaps.firebaseio.com/")!

    let apiKey = GMSPlacesClientApiKey
    
    typealias CompletionHandler = (Error?) -> Void
    
    // Fetches all bakeries from Firebase and saves them in an array of FirebaseBakeries
    func fetchAllBakeries(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = firebaseBaseURL.appendingPathExtension("json")
        
        print(requestURL)
        
        URLSession.shared.dataTask(with: requestURL) { ( data, _, error ) in
            
            if let error = error {
                NSLog("Error fetching placeIDs from Firebase: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch for placeIDs.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                let responseDictionary = try jsonDecoder.decode([String: FirebaseBakery].self, from: data)
                
                var decodedResponse = responseDictionary.map( {$0.value} )
                    
                //print(decodedResponse)
                
                self.firebaseBakeries = decodedResponse
                
                // Sort bakeries by distance from user if current location is enabled
                //if self.bakery?.distanceFromUser != nil {
                self.firebaseBakeries.sort { (b1, b2) -> Bool in
                    
                    if b1.distanceFromUser != nil {
                        return Double(b1.distanceFromUser!) < Double(b2.distanceFromUser!)
                        
                    } else {
                        return b1.name ?? "" < b2.name ?? ""
//                        if let first = b1.name, let second = b2.name {
//                            return first < second
//                        }
                            
                    }
                        
                }
                // Otherwise sort bakeries alphabetically
//                } else {
//                    self.bakeries.sort { (b1, b2) -> Bool in
//                        return b1.name < b2.name
//                    }
//                }

            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    // Fetches additional info from Google using the placeID of each fetched FirebaseBakery
    // Saves the info as a Bakery object in the Bakeries array
    //func getBakeryInfo(with placeID: String, completion: @escaping (Error?) -> Void) {
    func getBakeryInfo(with placeID: String, completion: @escaping CompletionHandler = { _ in }) {
        
        /*
         Adding FIELDS parameter limits the API call billings
         https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJsyPVS2jwwIcRgxML7BXE7eQ
         &fields=name,geometry,formatted_address,international_phone_number,website,opening_hours,photos
         &key=APIKEYGOESHERE
         */
        
        var bakeryURL = baseURL.appendingPathComponent("details")
        
        bakeryURL = bakeryURL.appendingPathComponent("json")
        
        var components = URLComponents(url: bakeryURL, resolvingAgainstBaseURL: true)
        
        let searchQueryItem = URLQueryItem(name: "placeid", value: placeID)
        let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
        let fieldsQueryItem = URLQueryItem(name: "fields", value: "name,geometry,place_id,formatted_address,international_phone_number,website,opening_hours,photos")
        
        components?.queryItems = [searchQueryItem, fieldsQueryItem, apiKeyQueryItem]
        
        guard let requestURL = components?.url else {
            NSLog("Couldn't make requestURL from \(components)")
            completion(NSError())
            return
        }
        
        //print(requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
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
                
                // // // // // // // // // // // // // // // // // // // //
                
                // Set the decoded result to the bakery object
                self.bakery = decodedBakery.result
                
                // If photos is not nil, put the photo references returned into the photoReferences array
                if self.bakery?.photos != nil {
                    self.photoReferences = (self.bakery?.photos)!
                    //print(self.photoReferences)
                }

                // Add the bakery object to the bakeries array
                self.bakeries.append(self.bakery!)
                
                // Sort bakeries by distance from user if current location is enabled
//                if self.bakery?.distanceFromUser != nil {
//                    self.bakeries.sort { (b1, b2) -> Bool in
//                        return Double(b1.distanceFromUser!) < Double(b2.distanceFromUser!)
//                    }
//                // Otherwise sort bakeries alphabetically
//                } else {
//                    self.bakeries.sort { (b1, b2) -> Bool in
//                        return b1.name < b2.name
//                    }
//                }
                

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
    
    //  https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRaAAAAdlELUNn90Ic77d0GYqUo7v0d0_acu6zM1swdy607ebNlRA8dsGzJ8Fpz0EMoEPjUejrFZxqqxrFYjkD9ebgniXxaWR5qQfpJCWXo-sWSv2HEqhDRDc5YxVsZQgU8U0rwEhCE2Oj-LFjkXcHNbSpyVIIcGhRaB1rK41n4OOcttBLKyyl8wJJ7Rg&key=APIKEYGOESHERE
    
    func fetchPhotos(with photoReference: String, completion: @escaping (Error?) -> Void) {
        
        guard let bakery = bakery else {
            print("There is no bakery object available")
            return
            
        }
        
        if bakery.photos != nil {
            for eachReference in bakery.photos! {
                
                //print(eachReference.photoReference)
                
                let photosURL = baseURL.appendingPathComponent("photo")
                
                var components = URLComponents(url: photosURL, resolvingAgainstBaseURL: true)
                
                let widthQueryItem = URLQueryItem(name: "maxwidth", value: "400")
                let searchQueryItem = URLQueryItem(name: "photoreference", value: eachReference.photoReference)
                let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
                
                components?.queryItems = [widthQueryItem, searchQueryItem, apiKeyQueryItem]
                
                guard let requestURL = components?.url else {
                    NSLog("Couldn't make requestURL from \(components)")
                    completion(NSError())
                    return
                }
                
                //print(requestURL)
                
            }
        }

        completion(nil)
        
    }

}




// NETWORKING ATTEMPTS
// TO COMBINE FIREBASEBAKERY & BAKERY OBJECTS AS ONE

//                for eachFirebaseBakery in self.firebaseBakeries {
//                    for eachBakery in self.bakeries {
//                        var temp = eachFirebaseBakery
//                        temp.bakeryInfo = eachBakery
//                        self.tempFirebaseBakeries.append(temp)
//                        print("FIREBASE BAKERIES WITH ADDITIONAL INFO: \(self.tempFirebaseBakeries)")
//                    }
//                }
                
                //self.tempFirebaseBakeries.append(self.bakery!)
                
//                // Loop through the array of firebaseBakeries (these objects were added in the initial fetchAllBakeries func
//                for eachFirebaseBakery in self.firebaseBakeries {
//
//                    if eachFirebaseBakery.placeID == self.bakery?.placeId {
//
//                        // Will need to change the constant, so give it a temporary variable
//                        var temp = eachFirebaseBakery
//
//                        // bakeryInfo is of the type `bakery` - assign the bakery object that is being decoded
//                        // to the firebaseBakery object's bakeryInfo variable
//                        temp.bakeryInfo = self.bakery
//
//                        // Append the object that now includes the additional bakeryInfo from GooglePlaces API to the temp array
//                        self.tempFirebaseBakeries.append(temp)
//
//                        // Replace the array of bakeries that previously had nil bakeryInfo with an array of objects that
//                        // contain all the information needed
//                        self.firebaseBakeries = self.tempFirebaseBakeries
//                    }
//
//                }
