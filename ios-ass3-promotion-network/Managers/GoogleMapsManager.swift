//
//  GoogleMapsManager.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 22/5/23.
//
// This code was inspired by https://www.youtube.com/watch?v=Cd-B5_vkOFs

import Foundation
import GooglePlaces
import GoogleMaps
import CoreLocation

struct Place {
    let name: String
    let identifier: String
}

struct PlaceNameCoord {
    let coordinates: CLLocationCoordinate2D
    let name: String
}

final class GooglePlacesManager {
    static let shared = GooglePlacesManager()

    private let client = GMSPlacesClient.shared()

    private init () { }

    enum PlacesError: Error {
        case failedToFind
        case failtedToGetCoordinates
    }
    public func setUp() {
        GMSServices.provideAPIKey("AIzaSyBqZ2uQbGP4hyVgV9bHudzdhqzqpFC-rZY")
    }

    //given a string finds a sest of possible places the user might be referring to
    public func findPlaces(
        query: String,
        completion: @escaping (Result <[Place], Error >) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(//autcompletes the string
            fromQuery: query,
            filter: filter,
            sessionToken: nil)
        { results, error in
            guard let results = results, error == nil else { //if no place was found
                completion(.failure(PlacesError.failedToFind))
                return
            }
            //if places were found return the name and the identifier of the place
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })

            completion(.success(places))
        }

    }

    //given an identifier and a place return the place name and its coordinates
    public func resolveLocation(for place: Place, completion: @escaping (Result<PlaceNameCoord, Error>) -> Void)
    {
        client.fetchPlace(
            fromPlaceID: place.identifier
            , placeFields: .coordinate
            , sessionToken: nil
            , callback: { googlePlace, error in
                guard let googlePlace = googlePlace, error == nil else { //if place id not recognized return error
                    completion(.failure(PlacesError.failtedToGetCoordinates))
                    return
                }
                //if place is found return coordinates and place name
                let coordinate = CLLocationCoordinate2D(
                    latitude: googlePlace.coordinate.latitude,
                    longitude: googlePlace.coordinate.longitude)
                let res = PlaceNameCoord(coordinates: coordinate, name: place.name)
                completion(.success(res))
            })
    }
}
