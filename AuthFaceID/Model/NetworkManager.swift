//
//  NetworkManager.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

import Foundation

class NetworkManager {

    /// Executes a request using a URLSession
    func performRequest(url: String, success: @escaping (Data)->(), failure: @escaping (Error?)->()) {
        
        guard let url = URL(string: url) else { failure(nil); return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error { failure(error); return }
            
            if let data = data {
                success(data)
            } else {
                failure(nil)
            }
        }
        task.resume()
    }
}
