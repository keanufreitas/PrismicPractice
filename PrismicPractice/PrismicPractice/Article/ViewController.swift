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

let baseURL = "https://wealthfit-staging.cdn.prismic.io/api/v2"
var globalDomainUrl = String()
let MyAPI = Service(baseURL: baseURL)

class ViewController: UIViewController {
    
    var masterRef = String()
    let articleQuery = "%5B%5Bat(document.type%2C+%22article%22)%5D%5D"
    let at = "MC5XenU3N3lNQUFNNWNzNTRI.77-9WyHvv73vv73vv70feGUe77-9eT_vv73vv73vv70YJmdN77-977-9Ou-_ve-_vV_vv73vv70277-977-9Eg"
    
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
        
        print(globalDomainUrl)
        if articles.isEmpty {
            activityIndicator.startAnimating()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Refs.fetchRef { (refs) in
            
            for ref in refs {
                
                print(ref.id ?? "no id")
                print(ref.ref ?? "no ref")
                self.masterRef = ref.ref!
            }
            self.test()
        }
    }
    
    func test() {
        
        globalDomainUrl = "https://wealthfit-staging.cdn.prismic.io/api/v2/documents/search?ref=\(masterRef)&access_token=\(at)&q=\(articleQuery)#format=json"
        
        // Decoder and JSONSerializable.
        Article.fetch { (items) in
            
            for item in items {

                // From Article and then Data.
                self.metaTitle = (item.data?.meta_title)!
                self.metaDesc = (item.data?.meta_description)!
                
                // From Data into Image.
                let url = item.data?.article_featured_image?.url
                do {
                    let data = try Data(contentsOf: url!)
                    self.image = UIImage(data: data)!
                } catch let err {
                    print("Error : \(err.localizedDescription)")
                }
                
                // From Data into Author.
                self.author = (item.data?.author?.uid)!
                
                // From Data into Topic.
                self.topic = (item.data?.topic?.uid)!
                
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

