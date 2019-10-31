//
//  GoogleDistanceController.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 10/25/19.
//  Copyright © 2019 Audrey Welch. All rights reserved.
//

//import Foundation
//
//class GoogleDistanceController {
//    
//    var googleDistanceResponse: [Row]!
//    var serviceAddresses: [String]!
//    var serviceDistance: String!
//    var serviceTravelDuration: String!
//    
//    var originLatitude: Double = 0.0
//    var originLongitude: Double = 0.0
//    var destinationLatitude: Double = 0.0
//    var destinationLongitude: Double = 0.0
//    
//    var nearestBakeryString: String!
//    var bakeryAddressesArray: [String] = []
//    var allBakeryObjects: [Bakery] = []
//    
//    typealias CompletionHandler = (Error?) -> Void
//    static var baseURL: URL! {
//        return URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial")
//    }
//    
//    // MARK: - Google Distance Matrix Details
//    
//    func fetchServiceDistance(_ originLatitude: Double,
//                              _ originLongitude: Double,
//                              _ destinationLatitude: Double,
//                              _ destinationLongitude: Double,
//                              completion: @escaping CompletionHandler = { _ in }) {
//        
//        let originString = String(originLatitude) + "," + String(originLongitude)
//        let destinationString = String(destinationLatitude) + "," + String(destinationLongitude)
//        
//        guard var components = URLComponents(url: GoogleDistanceController.baseURL, resolvingAgainstBaseURL: true) else {
//            fatalError("Unable to resolve baseURL components")
//        }
//        
//        let queryItemImperial = URLQueryItem(name: "units", value: "imperial")
//        let queryItemOrigin = URLQueryItem(name: "origins", value: originString)
//        let queryItemDestination = URLQueryItem(name: "destinations", value: destinationString)
//        let queryItemTravelMode = URLQueryItem(name: "mode", value: "driving")
//        let queryItemKey = URLQueryItem(name: "key", value: GMSServicesApiKey)
//        
//        components.queryItems = [queryItemImperial, queryItemOrigin, queryItemDestination, queryItemTravelMode, queryItemKey]
//        let requestURL = components.url
//        
//        URLSession.shared.dataTask(with: requestURL!) { ( data, _, error) in
//            
//            if let error = error {
//                NSLog("Error fetching tasks: \(error)")
//                completion(error)
//                return
//            }
//            
//            guard let data = data else {
//                NSLog("No data returned from data task.")
//                completion(NSError())
//                return
//            }
//            
//            let jsonDecoder = JSONDecoder()
//            
//            do {
//                
//                let decodedResponse = try jsonDecoder.decode(GoogleDistance.self, from: data)
//                let googleDistanceResponse = decodedResponse.rows
//                self.serviceDistance = googleDistanceResponse[0].elements[0].distance.text
//                self.serviceTravelDuration = googleDistanceResponse[0].elements[0].duration.text
//                
//                self.serviceAddresses = decodedResponse.destinationAddresses
//                
//                completion(nil)
//                
//            } catch {
//                completion(error)
//            }
//        }.resume()
//        
//    }
//    
//    func createAddressString() -> String {
//        
//        bakeryAddressesArray = BakeryModelController.shared.bakeries.map( {$0.formattedAddress
//            .trimmingCharacters(in: .whitespaces)
//            .split(separator: ",")
//            .joined()
//        })
//        
//        var combinedAddressArray: [String] = []
//        combinedAddressArray.append(contentsOf: bakeryAddressesArray)
//        
//        let formattedBakeryArray = combinedAddressArray.map( { $0.replacingOccurrences(of: " ", with: "+") } )
//        nearestBakeryString = formattedBakeryArray.map( { $0 + "|" }).joined()
//        
//        return nearestBakeryString
//    }
//    
//    // MARK: - Google Distance Matrix
//}
