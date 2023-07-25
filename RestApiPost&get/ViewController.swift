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
                        
                        if let response = urlResponse as? HTTPURLResponse {
                            print(response.statusCode)
                            guard (200...299) ~= response.statusCode else {
                                print("status code:- \(response.statusCode)")
                                print(response)
                                return
                            }
                            
                        }

                        
                        let response = String(data: data, encoding: .utf8)
                        print(response!)
                        
                    }
                }
            }.resume()
            
        }
    }
    
    //MARK: 201 --post mai and 200 get mai milta hai status code
    //MARK: check data value in terminal (po response.statusCode)
    
    func getUserData() {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts/100"){
        
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "get"
            
            
            URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
                
                
                if let data = data {
                    if error == nil {
                        
                        if let response = urlResponse as? HTTPURLResponse {
                            print(response.statusCode)
                            guard (200...299) ~= response.statusCode else {
                                print("status code:- \(response.statusCode)")
                                print(response)
                                return
                            }
                            
                        }
                        
                        
                        let response = String(data: data, encoding: .utf8)
                        print(response!)
                        
                    }
                }
                
            }.resume()
        
    }
}
}

