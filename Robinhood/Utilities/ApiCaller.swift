//
//  ApiCaller.swift
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

enum NetworkRequestType : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum APIResult<T> {
    case success(T)
    case failure(Error?)
}

public typealias APITaskCompletionHandler<T> = (APIResult<T>) -> Void

class ApiCaller<ResponseType:Decodable> {
    
    private class DefaultEncodable: Encodable {
        
    }
    
    func callApi(url: URL,
                 requestType: NetworkRequestType = .GET,
                 completion: @escaping APITaskCompletionHandler<ResponseType>) -> URLSessionDataTask {

        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            do {
                if let data = data, error == nil {
                    let returnObj = try JSONDecoder().decode(ResponseType.self, from: data)
                    completion(APIResult.success(returnObj))
                }
                completion(APIResult.failure(error))
                
            } catch _ {
                completion(APIResult.failure(error))
            }
        }
        
        task.resume()
        
        return task
    }
}

class ImageDownloader {
    static func downloadImage(url: URL,
                              completion: @escaping (UIImage?)->()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }
    }
}
