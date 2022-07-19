//
//  CarDetailsMockable.swift
//  VenueLocator
//
//  Created by Banerjee, Supratik on 23/06/22.
//

import Foundation

/// VenueDetailsMockable for fetching data from resource json
protocol VenueDetailsMockable: AnyObject {

    /// App Bundle
    var bundle: Bundle { get }

    /// Function to load json from file
    /// - Parameters:
    ///   - filename: file name to load
    ///   - type: type of file
    /// - Returns: Return generic type of value which is decodable
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T
}

/// Protocol extension of VenueDetailsMockable
extension VenueDetailsMockable {
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }

        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)

            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}
