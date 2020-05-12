//
//  ImageService.swift
//  321
//
//  Created by Student on 3/30/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

struct Image: Codable{
    let id: String
    let width: Int
    let height: Int
    let color: String
    let urls: ImageUrl
}
struct ImageUrl: Codable{
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
class ImageService{
    private let BASE_URL = "https://api.unsplash.com"
    private let ACCESS_TOKEN = "SkA2BoPqrvc-Am1oILqn0StJtoeUQVipJuKdKa4DhhQ"
    static let shared = ImageService()
    
    func getRandomImage(){
        if let url = URL(string: "\(BASE_URL)/photos/random"){
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Client-ID \(ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
            
            //after you get back result from http
            URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                if let data = data{
                    do{
                        let image =
                    try JSONDecoder().decode(Image.self, from: data)
                        print("image is \(image.urls.full)")
                    } catch{
                        print(error)
                    }
                }
                }).resume() // you need to exeute the task by using resume() function
        }
    }
}
