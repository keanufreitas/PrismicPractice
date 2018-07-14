//
//  Refs.swift
//  PrismicPractice
//
//  Created by Keanu Freitas on 7/13/18.
//  Copyright © 2018 Keanu Freitas. All rights reserved.
//

import Foundation

struct Ref: Codable {
    var id:  String?
    var ref: String?
}

class Refs: Codable {
    
    var ref: [Ref]?
    
    enum CodingKeys: String, CodingKey {
        case ref = "refs"
    }
    
    static func fetchRef(completionHandler: @escaping ([Ref]) -> Void) {
        
        let urlString = baseURL
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                print(String.init(data: data!, encoding: .ascii) ?? "No data from Ref")
                
                if let newRef = try? JSONDecoder().decode(Refs.self, from: data!) {
                    completionHandler(newRef.ref!)
                }
            })
            task.resume()
        }
    }
}
