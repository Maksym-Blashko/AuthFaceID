//
//  ApiManager.swift
//  AuthFaceID
//
//  Created by Blashko Maksim on 12.08.2021.
//

import UIKit

class ApiManager {
    
    static let shared = ApiManager()
    private let networkManager = NetworkManager.shared
    private init() { }
    
    private let endpoint = "https://api.themoviedb.org/3/authentication/token/new/"
    
    func tryToLogIn(user: User, completion: @escaping (Bool)->(Void)) {

        completion(true) // for testing !!!

        let url = endpoint + "?" + "api_key=<<api_key>>"
        
        networkManager.performRequest(url: url) { (data) in

//            do {
//                let decodeData = try JSONDecoder().decode(yourDecodeDataIfNeeded.self, from: data)
//                completion(decodeData.results)
//            } catch {
//                print(error.localizedDescription)
//            }
            
        } failure: { (error) in
            print(error?.localizedDescription as Any)
        }        
    }
    
}
