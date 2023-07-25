//
//  GetGptApiRequest.swift
//  RestApiPost&get
//
//  Created by MD Faizan on 25/07/23.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}

class GetGptApiRequest {
    
    
    func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
        let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let session = URLSession.shared
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let httpError = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                completion(nil, httpError)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            
            // Parse the data (assuming it's JSON data)
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(posts, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func getData() {
        
        
        // Call the function to fetch posts
        fetchPosts { (posts, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let posts = posts {
                for post in posts {
                    print("Post ID: \(post.id)")
                    print("Title: \(post.title)")
                    print("Body: \(post.body)")
                    print("User ID: \(post.userId)")
                    print("======================")
                }
            } else {
                print("Posts data not available.")
            }
        }
        
        
        
    }
    
   
    
    
    
}
