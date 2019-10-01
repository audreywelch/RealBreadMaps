//
//  PlaceDetailsFetch.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//
// https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJsyPVS2jwwIcRgxML7BXE7eQ&key=AIzaSyBRMVPW8u3LagIW0t_geAdChN9BAKwb2yQ

// result {}

import UIKit

class BakeryModelController {
    
    // Singleton
    static let shared = BakeryModelController()
    private init () {}
    
    // Holds the search result returned
    var bakery: Bakery?
    
    // Holds current bakery in focus
    var currentBakeryName: String?
    var currentBakeryAddress: String?
    
    // Array to hold saved bakeries
    var bakeries: [Bakery] = []
    var firebaseBakeries: [FirebaseBakery] = []
    
    // Array to hold saved photo references
    var photoReferences: [PhotoReferences] = []
    
    let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/")!
    let firebaseBaseURL = URL(string: "https://realbreadmaps.firebaseio.com/")!

    let apiKey = GMSPlacesClientApiKey
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchAllBakeries(completion: @escaping CompletionHandler = { _ in }) {
        
        let requestURL = firebaseBaseURL.appendingPathExtension("json")
        
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
                
                let decodedResponse = try jsonDecoder.decode(FirebaseBakery.self, from: data)
                
                self.firebaseBakeries.append(decodedResponse)
                
            } catch {
                NSLog("Error decoding FirebaseObject: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func searchForBakery(with placeID: String, completion: @escaping (Error?) -> Void) {
        
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
        
        print(requestURL)
        
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
                
                
                self.bakeries.append(self.bakery!)
                //print(self.bakeries)
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
                
                print(eachReference.photoReference)
                
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
                
                print(requestURL)
                
            }
        }

        completion(nil)
        
    }
}
