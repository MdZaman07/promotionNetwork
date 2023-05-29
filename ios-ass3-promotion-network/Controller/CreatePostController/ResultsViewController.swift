//
//  ResultsViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 22/5/23.
//
// This code was inspired by https://www.youtube.com/watch?v=Cd-B5_vkOFs 
import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: PlaceNameCoord)
}

// helper view controller that manages the display of address recommendations in the map searach view
class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: ResultsViewControllerDelegate?
    private var places: [Place] = []
    private var tableView = UITableView() //the addresses are displayed as a table view

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView) //add the table view programatically
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() { //display the table
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    public func update(with places: [Place]) { //update the table with new list of places
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    //each cell contains the name of a place
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    //control when row of the table view is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        tableView.isHidden = true

        let place = places[indexPath.row] //tapped place

        //returns the location of the place
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success (let placeCoord):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: placeCoord) //send info of tapped place
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}
