//: Playground - noun: a place where people can play

import UIKit

let domainUrl = "https://wealthfit-staging.cdn.prismic.io/api/v2/documents/search?ref=WzGGiywAAOZIYd1a&q=%5B%5Bat(document.type%2C+%22article%22)%5D%5D#format=json"

struct Detail {
    var name: Any?
    var nameString: String? {
        return name as? String
    }
    var nameIntArray: [Int]? {
        return name as? [Int]
    }
    enum CodingKeys: CodingKey {
        case name
    }
}

extension Detail: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let string = name as? String {
            try container.encode(string, forKey: .name)
        }
        if let array = name as? [Int] {
            try container.encode(array, forKey: .name)
        }
    }
}


extension Detail: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let string = try? values.decode(String.self, forKey: .name) {
            name = string
        } else if let array = try? values.decode(Array<Int>.self, forKey: .name) {
            name = array
        }
    }
}

struct Record: Codable {
    var name: String
    var details: [Detail]
}

static func fetch() {
    
    let urlString = domainUrl
    if let url = URL.init(string: urlString) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //print(String.init(data: data!, encoding: .ascii) ?? "No data!")
            
            if let newArticle = try? JSONDecoder().decode(Article.self, from: data!) {
                print(newArticle.page ?? "no page" + " <-------------")
            }
            
            if let newResult = try? JSONDecoder().decode(Result.self, from: data!) {
                print(newResult.id ?? "no id" + " <-------------")
                print(newResult.uid ?? "no uid" + " <-------------")
                print(newResult.type ?? "no type" + " <-------------")
            }
        })
        task.resume()
    }
}

Article.fetch()

let jsonDecoder = JSONDecoder()
let record = try! jsonDecoder.decode(Record.self, from: json.data(using: .utf8)!)
print("\(record.details.first!.name!) is of type: \(type(of:record.details.first!.name!))")
print("\(record.details.last!.name!) is of type: \(type(of:record.details.last!.name!))")
