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
    var fileURL: URL?
    
    init() {
        // Get the URL for the Documents directory
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found")
            return
        }
        
        // Initialise DummyData path
        self.fileURL = documentsDirectoryURL.appendingPathComponent("DummyData.json")

        guard let fileURL = self.fileURL else {return}
        
        // Check if the file exists, if it does, put user data into users array variable
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                self.file = jsonData
                let decoder = JSONDecoder()
                self.users = try decoder.decode([User].self, from: jsonData)
                printJSON(jsonData: jsonData)
            } catch {
                print("Error accessing JSON file: \(error)")
            }
        } else {
            // If file doesn't exist, create one with an empty array
            do {
                let jsonData = try JSONEncoder().encode(users)
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
        guard let fileURL = self.fileURL else {return false}
        
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
    
    func deleteDummyData() {
        guard let fileURL = self.fileURL else {return}
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL)
            print("DummyData.json file deleted")
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}
