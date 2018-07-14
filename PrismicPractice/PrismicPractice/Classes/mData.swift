//
//  mData.swift
//  PrismicPractice
//
//  Created by Keanu Freitas on 7/13/18.
//  Copyright © 2018 Keanu Freitas. All rights reserved.
//

import Foundation

struct mData: Codable {
    var meta_title: String?
    var meta_description: String?
    var article_featured_image: Image?
    var author: Author?
    var topic: Topic?
}
