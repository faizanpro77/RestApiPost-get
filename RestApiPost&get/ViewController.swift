//
//  ViewController.swift
//  RestApiPost&get
//
//  Created by MD Faizan on 20/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserData()
    }
    
    
    
    func apiManager() {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts"){
            
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "post"
            let dataDictionary:[String:Any] = [
                "title": "paytm user Data",
                "body": "it is a paytm mobile user Data",
                "userId":  1
            ]
            
            do {
                let requestBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
                urlRequest.httpBody = requestBody
                urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
                
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            
            
      
            
            URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
                
                if let data = data {
                    if error == nil {
                        let response = String(data: data, encoding: .utf8)
                        print(response!)
                        
                    }
                }
            }.resume()
            
        }
    }
    
    
    func getUserData() {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts/100"){
        
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "get"
            
            
            URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
                
                
                if let data = data {
                    if error == nil {
                        
                        let response = String(data: data, encoding: .utf8)
                        print(response!)
                        
                    }
                }
                
            }.resume()
        
    }
}
}

