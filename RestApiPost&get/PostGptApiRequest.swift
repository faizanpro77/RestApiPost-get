//
//  PostGptApiRequest.swift
//  RestApiPost&get
//
//  Created by MD Faizan on 25/07/23.
//

import Foundation



class PostGptApiRequest {

    struct Post: Codable {
        let id: Int
        let title: String
        let body: String
        let userId: Int
    }

func createPost() {
    let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let newPost = Post(id: 101, title: "foo", body: "bar", userId: 1)
    
    do {
        let jsonData = try JSONEncoder().encode(newPost)
        request.httpBody = jsonData
    } catch {
        print("Error encoding the data: \(error)")
        return
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP status code: \(httpResponse.statusCode)")
            return
        }
        
        if let data = data {
            do {
                let createdPost = try JSONDecoder().decode(Post.self, from: data)
                print("New Post ID: \(createdPost.id)")
                print("New Post Title: \(createdPost.title)")
                print("New Post Body: \(createdPost.body)")
                print("New Post User ID: \(createdPost.userId)")
            } catch {
                print("Error parsing JSON response: \(error)")
            }
        } else {
            print("No data received")
        }
    }
    
    task.resume()
}

 
   
    
}

