//
//  PostGptApiRequest.swift
//  RestApiPost&get
//
//  Created by MD Faizan on 25/07/23.
//

import Foundation
// POST request body structure
struct PostRequest: Codable {
    let name: String
    let email: String
}


func fetchDataPOST(from urlString: String, body: PostRequest, completion: @escaping (Result<ApiResponse, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Encode the request body into JSON
    do {
        request.httpBody = try JSONEncoder().encode(body)
    } catch {
        completion(.failure(error))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        // Decode the JSON response into ApiResponse
        do {
            let decodedData = try JSONDecoder().decode(ApiResponse.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}

let newUser = PostRequest(name: "John Doe", email: "john.doe@example.com")

fetchDataPOST(from: "https://api.example.com/users", body: newUser) { result in
    switch result {
    case .success(let createdUser):
        print("Created User: \(createdUser)")
    case .failure(let error):
        print("Error creating user: \(error)")
    }
}

//==============================================================

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

//==========================================================================

// Define the Post model to match the JSON structure
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// Define a custom error type to handle network issues
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
}

// Define the Post model for sending data
struct Post: Codable {
    let userId: Int
    let title: String
    let body: String
}

// Define custom error types for handling network issues
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case badResponse
}

// Async function to create a post (send a POST request)
func createPost(post: Post) async throws -> Post {
    let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    // Check if the URL is valid, otherwise throw an error
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }

    // Encode the Post object to JSON
    let jsonData: Data
    do {
        jsonData = try JSONEncoder().encode(post)
    } catch {
        throw NetworkError.decodingFailed  // Encoding error
    }

    // Create the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    do {
        // Send the POST request and wait for the response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw NetworkError.badResponse
        }
        
        // Decode the response data into a Post model
        let decodedPost = try JSONDecoder().decode(Post.self, from: data)
        return decodedPost
    } catch {
        // Catch all errors and rethrow
        throw error
    }
}

class viewController:UIViewcontroller{
// Create a new Post object to send
       let newPost = Post(userId: 1, title: "My New Post", body: "This is the body of my new post")
func viewDidLoad() {
       // Call the async function to create a post
       Task {
           do {
               let createdPost = try await createPost(post: newPost)
               print("Successfully created post: \(createdPost)")
           } catch NetworkError.invalidURL {
               print("Invalid URL.")
           } catch NetworkError.noData {
               print("No data received.")
           } catch NetworkError.decodingFailed {
               print("Failed to encode or decode the data.")
           } catch NetworkError.badResponse {
               print("Bad response from the server.")
           } catch {
               print("An unexpected error occurred: \(error)")
           }
       }
   }
}
}
}


