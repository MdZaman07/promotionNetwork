//
//  ResultsViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 22/5/23.
//

import UIKit
import CoreLocation
protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: PlaceNameCoord)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: ResultsViewControllerDelegate?
    
    private var places:[Place] = []

    private var tableView =  UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    public func update(with places: [Place]){
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place){ [weak self] result in
            switch result{
            case .success (let placeCoord):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: placeCoord)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
