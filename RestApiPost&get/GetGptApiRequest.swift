//
//  GetGptApiRequest.swift
//  RestApiPost&get
//
//  Created by MD Faizan on 25/07/23.
//

import Foundation

// Response structure for both GET and POST
struct ApiResponse: Codable {
    let id: Int
    let name: String
    let email: String
}

func fetchDataGET(from urlString: String, completion: @escaping (Result<[ApiResponse], Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            print("No data received")
            return
        }

        // Decode the JSON response into ApiResponse array
        do {
            let decodedData = try JSONDecoder().decode([ApiResponse].self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}


fetchDataGET(from: "https://api.example.com/users") { result in
    switch result {
    case .success(let users):
        print("Fetched Users: \(users)")
    case .failure(let error):
        print("Error fetching users: \(error)")
    }
}



//==================================================================

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

//====================================

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

// Async function to fetch a single post with proper error handling
func fetchSinglePost() async throws -> Post {
    let urlString = "https://jsonplaceholder.typicode.com/posts/1"
    
    // Check if the URL is valid, otherwise throw an error
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }

    do {
        // Fetch data from the network using async/await
        let (data, _) = try await URLSession.shared.data(from: url)

        // Check if data is nil or empty and throw the noData error
        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        // Decode the JSON data into the Post model
        let decodedPost = try JSONDecoder().decode(Post.self, from: data)
        return decodedPost
    } catch let decodingError as DecodingError {
        // Handle JSON decoding errors specifically
        print("Decoding error: \(decodingError)")
        throw NetworkError.decodingFailed
    } catch {
        // For all other errors, rethrow them
        throw error
    }
}


class ViewController: UIViewController {

    var post: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Call the async function and handle errors
        Task {
            do {
                self.post = try await fetchSinglePost()
                if let fetchedPost = self.post {
                    print("Fetched Post: \(fetchedPost.title)")
                }
            } catch NetworkError.invalidURL {
                print("Invalid URL error.")
            } catch NetworkError.noData {
                print("No data received.")
            } catch NetworkError.decodingFailed {
                print("Failed to decode the data.")
            } catch {
                print("An unexpected error occurred: \(error)")
            }
        }
    }
}
