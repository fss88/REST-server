//
//  ViewController.swift
//  Assignment #1
//
//  Created by Fahad Alswailem on 10/25/20.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        settingPostRequest()
        settingGetRequest()
    }
    
    //This function implements the POST request with four parameters and the response back in json format
    fileprivate func settingPostRequest () {
        let url = URL(string: "")!  //put the sqllite3 url here
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let uuid = UUID().uuidString
        let parameters: [String: Any] = [
            "id": uuid,
            "title": "Jack",
            "date": "2020 07-12",
            "isSolved": "false"
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {  // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }
    
    //This Method Implements the get request and get all the json format data for the given url
    fileprivate func settingGetRequest() {
           let url = URL(string: "")!  //sqllite3 database url
           
           let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
               guard let data = data else { return }
               print(String(data: data, encoding: .utf8)!)
           }
           
           task.resume()
       }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
