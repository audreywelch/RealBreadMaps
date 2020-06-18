//
//  UIImageLoader.swift
//  RealBreadMaps
//
//  Created by Audrey Welch on 3/20/20.
//  Copyright © 2020 Audrey Welch. All rights reserved.
//

import UIKit

// Singleton object that manages loading for all UIImageView instances
// in the app, resulting in using a single cache for the entire app.

class UIImageLoader {
    
    static let loader = UIImageLoader()
    
    // Loads images and caches them
    private let imageLoader = ImageLoader()
    
    // Dictionary keeps track of currently active image loading tasks
    // Map these based on UIImageView in order to connect individual task identifiers to UIIMageView instances
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ urlString: String, for imageView: UIImageView) {
        
        // Initate image load using the URLString that was passed in
        let token = imageLoader.loadImage(urlString) { result in
            
            // When load is completed, clean up the uuidMap by removing the UIImageView
            // for which we are loading the image from the dictionary
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            do {
                // Extract image from result and set on the image view itself
                let image = try result.get()
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                print(error)
            }
        }
        
        // If we received a token from the image loader, keep it in the dictionary to reference later if load has to be canceled
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

class ImageLoader {
    
    // Create an image cache using NSCache
    private let imageCache = NSCache<NSString, UIImage>()
    
    // Dictionary in the image loader keeps track of running downloads in order to cancel them later
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    // Accepts URLString and completion handler
    // Returns a UUID used to uniquely identify each data task
    func loadImage(_ urlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        // If the cache already contains the URLString as a key, immediately call completion handler
        // Since there is no active task & nothing to cancel later, return nil instead of UUID instance
        if let cacheImage = imageCache.object(forKey: urlString as NSString) {
            completion(.success(cacheImage))
            return nil
        }
        
        // Create a url out of the urlString
        guard let url = URL(string: urlString) else { return nil}
        
        // Create UUID instance used to identify the data task about to be created
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // When the data task completes, remove it from the running requests dictionary
            // Defer statement removes the running task before leaving the scope of the data task's completion handler
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            // When data task completes and an image is extracted from the result of the data task,
            // cache it and call completion handler with loaded image
            if let data = data, let image = UIImage(data: data) {
                // Put the url and image into the cache
                self.imageCache.setObject(image, forKey: urlString as NSString)
                completion(.success(image))
                return
            }
            
            // If we receive an error, we check whether the error is due to the task being canceled
            
            // If there is no image or an error
            guard let error = error else {
                print("No image AND no error returned from data task")
                return
            }
            
            // If the error is anything other than canceling the task, we forward it to the caller of completion
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
            
            // The request was cancelled, no need to call the completion
        }
        task.resume()
        
        // Store data task in running requests dictionary using UUID, then return the UUID
        runningRequests[uuid] = task
        return uuid
    }
    
    // Allows for cancellation of in-progress image downloads
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
