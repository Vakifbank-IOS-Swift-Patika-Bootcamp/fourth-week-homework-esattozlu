//
//  NetworkManager.swift
//  BreakingBadApp
//
//  Created by Hasan Esat Tozlu on 22.11.2022.
//

import UIKit

class NetworkManager {
    
    enum Endpoints {
        static let base = "https://www.breakingbadapi.com/api/"
        
        case characters
        
        var urlString: String {
            switch self {
            case .characters:
                return Endpoints.base + "characters"
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    
    // generic getrequest
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    // to get character info from service
    class func getCharacters(completion: @escaping ([CharacterModel]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.characters.url, responseType: [CharacterModel].self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // to get images from URL
    class func getImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else {
                completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
            let data = data,
            let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completed(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completed(image)
            }
        }
        
        task.resume()
    }
}



