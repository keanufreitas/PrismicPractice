//
//  FullArticle.swift
//  PrismicPractice
//
//  Created by Keanu Freitas on 6/29/18.
//  Copyright © 2018 Keanu Freitas. All rights reserved.
//

import Foundation
import UIKit

class FullArticle {
    
    var title: String?
    var miniDesc: String?
    var author: String?
    var image: UIImage?
    var topic: String?
    
    init(title: String, miniDesc: String, author: String, image: UIImage, topic: String) {
        self.title = title
        self.miniDesc = miniDesc
        self.author = author
        self.image = image
        self.topic = topic
    }
}
