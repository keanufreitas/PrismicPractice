//
//  ViewController.swift
//  PrismicPractice
//
//  Created by Keanu Freitas on 6/18/18.
//  Copyright © 2018 Keanu Freitas. All rights reserved.
//

import UIKit
import Foundation
import Siesta

let baseURL = "https://wealthfit-staging.prismic.io/api/v2"
//let domainUrl = "\(baseURL)documents/search?ref=\(ref)&access_token=\(at)&q=\(articleQuery)#format=json"
let MyAPI = Service(baseURL: baseURL)

let domainUrl = "https://wealthfit-staging.cdn.prismic.io/api/v2/documents/search?ref=\(ref)&access_token=\(at)&q=\(articleQuery)#format=json"

let ref = "W0O_dB4AAA5Aj2Yn"
//"WzwwVCMAAJ5xtaG1"
let articleQuery = "%5B%5Bat(document.type%2C+%22article%22)%5D%5D"
let at = "MC5XenU3N3lNQUFNNWNzNTRI.77-9WyHvv73vv73vv70feGUe77-9eT_vv73vv73vv70YJmdN77-977-9Ou-_ve-_vV_vv73vv70277-977-9Eg"

struct Result: Codable {
    var id: String?
    var uid: String?
    var type: String?
    var data: mData?
}

struct mData: Codable {
    var meta_title: String?
    var meta_description: String?
    var article_featured_image: Image?
    var author: Author?
    var topic: Topic?
}

struct Image: Codable {
    var url: URL?
}

struct Author: Codable {
    var uid: String?
}

struct Topic: Codable {
    var uid: String?
}

public func track(_ message: String, file: String = #file, function: String = #function, line: Int = #line ) {
    print("\(message) called from \(function) \(file):\(line)")
}

func stringify(json: Any, prettyPrinted: Bool = false) -> String {
    var options: JSONSerialization.WritingOptions = []
    if prettyPrinted {
        options = JSONSerialization.WritingOptions.prettyPrinted
    }
    
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch {
        print(error)
    }
    
    return ""
}

class Article: Codable {
    
    var page: Int?
    var results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
    }
    
    static func fetch(completionHandler: @escaping ([Result]) -> Void) {

        let urlString = domainUrl
        if let url = URL.init(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                //print(String.init(data: data!, encoding: .ascii) ?? "No data!")

                if let newArticle = try? JSONDecoder().decode(Article.self, from: data!) {
                    print(newArticle.page ?? "no page" + " <-------------")
                    completionHandler(newArticle.results!)
                }
            })
            task.resume()
        }
    }
}

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLbl: UILabel!
    
    
    var articles = [FullArticle]()
    
    var image = UIImage()
    
    var metaTitle = String()
    var metaDesc = String()
    var author = String()
    var topic = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(domainUrl)
        
//        print(stringify(json: apiRef.resource("").withParam("q", "[at(document.type, `article`)]").jsonArray, prettyPrinted: true))
        
        
        for anItem in MyAPI.resource("").withParam("q", "[at(document.type, `article`)]").jsonArray as! [Dictionary<String, Any>] {
            print(anItem["refs"]!)
             // MyAPI.resource("").addObserver(self)
        }

        if articles.isEmpty {
            activityIndicator.startAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Decoder and JSONSerializable.
        Article.fetch{ (items) in
            
            for item in items {
                // Straight from Article.
//                print(item.id ?? "no id")
//                print(item.uid ?? "no uid")
//                print(item.type ?? "no type")
                
                // From Article and then Data.
//                print(item.data?.meta_title ?? "no title")
//                print(item.data?.meta_description ?? "no desc")
                
                self.metaTitle = (item.data?.meta_title)!
                self.metaDesc = (item.data?.meta_description)!
                
                // From Data into Image.
//                print(item.data?.article_featured_image?.url?.absoluteString ?? "no image url")
                
                let url = item.data?.article_featured_image?.url
                do {
                    let data = try Data(contentsOf: url!)
                    self.image = UIImage(data: data)!
                } catch let err {
                    print("Error : \(err.localizedDescription)")
                }
                
                // From Data into Author.
//                print(item.data?.author?.uid ?? "no author")
                
                self.author = (item.data?.author?.uid)!
                
                // From Data into Topic.
//                print(item.data?.topic?.uid ?? "no topic")
                
                self.topic = (item.data?.topic?.uid)!
                
                // From Data into
                
                
                self.articles.append(FullArticle(title: self.metaTitle, miniDesc: self.metaDesc, author: self.author, image: self.image, topic: self.topic))
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Flow Layout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = 1
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 10
        let cellSpacing: CGFloat = 5
        //let height = image.size.height
        
        return CGSize(width: (width / numberOfColumns) - (xInsets + cellSpacing), height: (width / numberOfColumns) - (xInsets + cellSpacing))
    }
}

// MARK: DataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        
        if articles.isEmpty {
            count = articles.count
        } else {
            count = articles.count
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            loadingLbl.isHidden = true
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.imageView.image = articles[indexPath.item].image
        cell.titleLbl.text = articles[indexPath.item].title
        cell.descLbl.text = articles[indexPath.item].miniDesc
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

