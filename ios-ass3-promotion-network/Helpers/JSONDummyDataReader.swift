//
//  JSONReader.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation


// Class for reading the dummy data and processing it similar to a database
class JSONDummyDataReader {
    var file: Data?
    var users: [User] = []
    var posts: [Post] = []
    var userFileURL: URL!
    var postsFileURL: URL!
    
    init() {
        // Get the URL for the Documents directory
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return
        }
        
        // Initialise DummyData path
        self.userFileURL = documentsDirectoryURL.appendingPathComponent("UserData.json")
        self.postsFileURL = documentsDirectoryURL.appendingPathComponent("PostData.json")
        
        initFile(fileURL: self.userFileURL, type: [User].self)
        initFile(fileURL: self.postsFileURL, type: [Post].self)
        print(self.users)
    }
    
    func initFile<T: Codable>(fileURL: URL, type: T.Type) {
        // Check if the file exists, if it does, put user data into users array variable
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(type, from: jsonData)
                
                if type is [User].Type {
                    self.users = decodedData as! [User]
                } else if type is [Post].Type {
                    self.posts = decodedData as! [Post]
                }
            } catch {
                print("Error accessing JSON file: \(error)")
            }
        } else {
            // If file doesn't exist, create one with an empty array
            let emptyArray: [User] = []
            do {
                let jsonData = try JSONEncoder().encode(emptyArray)
                try jsonData.write(to: fileURL)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func printJSON(jsonData: Data) {
        // Convert JSON data into a Swift object
        if let jsonString = String(data: jsonData, encoding: .utf8) {
             print(jsonString)
         }
    }
    
    func createUser(newUser: User) -> Bool {
        guard let fileURL = self.userFileURL else {return false}
        
        if(users.contains { $0.id == newUser.id }) {
            print("Username already exists!")
            return false
        }

        do {
            // Modify the data structure
            users.append(newUser)
            
            // Step 4: Encode the updated data structure back into JSON data
            let jsonData = try JSONEncoder().encode(users)
                        
            // Write the JSON data to the file
            try jsonData.write(to: fileURL)
            
        } catch {
            print("Error: \(error)")
        }
        
        return true
    }
    
    func createPost(newPost: Post) -> Bool {
        guard let fileURL = self.postsFileURL else {return false}
    
        do {
            // Modify the data structure
            posts.append(newPost)
            
            // Step 4: Encode the updated data structure back into JSON data
            let jsonData = try JSONEncoder().encode(posts)
                        
            // Write the JSON data to the file
            try jsonData.write(to: fileURL)
            
        } catch {
            print("Error: \(error)")
        }
        
        return true
    }
    
    func deleteDummyData(fileName: String) {
        // Get the URL for the Documents directory
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return
        }
        
        // Initialise DummyData path
        let deleteFileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: deleteFileURL)
            print("\(fileName) file deleted")
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}
