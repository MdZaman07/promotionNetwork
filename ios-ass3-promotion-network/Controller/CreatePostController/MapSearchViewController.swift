//
//  MapSearchViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 22/5/23.
//
// This code was inspired by https://www.youtube.com/watch?v=Cd-B5_vkOFs

import UIKit
import GoogleMaps

class MapSearchViewController: UIViewController, UINavigationControllerDelegate, UISearchResultsUpdating {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var selectAddressButton: UIButton!

    var vc: CreatePostViewController? = nil //saves the data already inputted in the view
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var address: String = ""

    var searchVC = UISearchController(searchResultsController: ResultsViewController())

    //set the inital map view some coordinates
    override func viewDidLoad() {
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 15.0)
        mapView.camera = camera
        view.addSubview(mapView)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
        selectAddressButton.isHidden = true
    }

    // show navigation bar when page entered
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.backButtonTitle = "Back"
    }

    //high navigation bar when page exited
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    //update the results table view when search controller input is edited
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
            let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }

        resultsVC.delegate = self

        GooglePlacesManager.shared.findPlaces(query: query) { result in //find the places given that string
            switch result {
            case .success (let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places) //update the information on the table view
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    //when the button select address is selected go back to the create post controller
    @IBAction func addressSelected(_ sender: Any) {
        guard let vc = vc else {
            print("Error passing the data back to create post view.")
            return
        }
        vc.latitude = String(latitude)
        vc.longitude = String(longitude)
        vc.address = String(address)
        navigationController?.popViewController(animated: true)
    }

}

extension MapSearchViewController: ResultsViewControllerDelegate {
    //add marker in the map when place is selected from the table view
    func didTapPlace(with placeCoord: PlaceNameCoord) {
        let coordinates = placeCoord.coordinates
        let marker = GMSMarker()

        latitude = coordinates.latitude //set the marker's coordinates
        longitude = coordinates.longitude
        address = placeCoord.name

        //set the map display
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        marker.position = coordinates
        marker.title = "Selected location"
        marker.map = mapView
        searchVC.isActive = false
        selectAddressButton.isHidden = false //allow the user to select that address
    }
}

