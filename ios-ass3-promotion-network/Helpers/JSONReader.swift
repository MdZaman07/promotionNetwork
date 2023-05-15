//
//  JSONReader.swift
//  ios-ass3-promotion-network
//
//  Created by Toan Nguyen on 15/5/2023.
//

import Foundation

class JSONReader {
    var file: Data?
    var location: String
    
    init(location: String) {
        self.location = location
        if let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                self.file = jsonData
                // Process the JSON data
            } catch {
                print("Error accessing JSON file: \(error)")
            }
        }
    }
    
    func writeToFile() {
        do {
            var jsonObject = try JSONSerialization.jsonObject(with: file!, options: [])
            if var jsonDictionary = jsonObject as? [String: Any] {
                // Modify the JSON data as needed
                jsonDictionary["key"] = "new value"
                jsonObject = jsonDictionary

                // Convert the updated JSON object back to Data
                let updatedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

                // Write the updated data to the file
                try updatedData.write(to: URL(fileURLWithPath: location))
            }
        } catch {
            print("Error writing to JSON file: \(error)")
        }
    }
}
