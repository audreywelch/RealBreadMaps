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
    
    // Array to hold saved bakeries
    var bakeries: [Bakery] = []
    
    let baseURL = URL(string: "https://maps.googleapis.com/maps/api/place/details/")!
    
    let apiKey = "AIzaSyBRMVPW8u3LagIW0t_geAdChN9BAKwb2yQ"
    
    func searchForBakery(with placeID: String, completion: @escaping (Error?) -> Void) {
    
        let bakeryURL = baseURL.appendingPathComponent("json")
        
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
                print(self.bakery)
                self.bakeries.append(self.bakery!)
                print(self.bakeries)
                completion(nil)
                return
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }.resume()
        
    }
    
    
    
    
}
