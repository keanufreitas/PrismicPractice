//
//  Article.swift
//  PrismicPractice
//
//  Created by Keanu Freitas on 7/13/18.
//  Copyright © 2018 Keanu Freitas. All rights reserved.
//

import Foundation

class Article: Codable {
    
    var page: Int?
    var results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
    }
    
    static func fetch(completionHandler: @escaping ([Result]) -> Void) {
        
        let urlString = globalDomainUrl
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if let newArticle = try? JSONDecoder().decode(Article.self, from: data!) {
                    print(newArticle.page ?? "no page" + " <-------------")
                    completionHandler(newArticle.results!)
                }
            })
            task.resume()
        }
    }
}
