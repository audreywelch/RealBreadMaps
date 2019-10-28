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

class BakeryModelController {
    
    // Singleton
    static let shared = BakeryModelController()
    private init () {}
    
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
        
        var bakeryURL = baseURL.appendingPathComponent("details")
        
        bakeryURL = bakeryURL.appendingPathComponent("json")
        
        var components = URLComponents(url: bakeryURL, resolvingAgainstBaseURL: true)
        
        let searchQueryItem = URLQueryItem(name: "placeid", value: placeID)
        let apiKeyQueryItem = URLQueryItem(name: "key", value: apiKey)
        
        components?.queryItems = [searchQueryItem, apiKeyQueryItem]
        
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
                self.bakery = decodedBakery.result
                
                // If photos is not nil, put the photo references returned into the photoReferences array
                if self.bakery?.photos != nil {
                    self.photoReferences = (self.bakery?.photos)!
                    //print(self.photoReferences)
                }

                // Add the bakery object to the bakeries array
                self.bakeries.append(self.bakery!)
                
                completion(nil)
                return
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }.resume()
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
