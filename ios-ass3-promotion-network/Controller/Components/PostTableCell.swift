//
//  PostSnippet.swift
//  ios-ass3-promotion-network
//
//  Created by Rain Holloway on 17/5/2023.
//

import Foundation
import UIKit

class PostTableCell: UITableViewCell {
    
    static let identifier = "post-table-cell"
    
    // Add customisable elements
    let profileImage = UIImageView()
    let nameLabel = UILabel()
    let categoryLabel = UILabel()
    let moneySavedLabel = UILabel()
    let descriptionLabel = UILabel()
    let cellVStack = UIStackView()
    let profileHStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialize and change properties of elements
        cellVStack.axis = .vertical
        cellVStack.backgroundColor = .yellow
        
        profileHStack.axis = .horizontal
        profileHStack.backgroundColor = .red

        profileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        profileImage.backgroundColor = .green
        
        // Turn off autoresizing mask translation
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileHStack.translatesAutoresizingMaskIntoConstraints = false
        cellVStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add elements to view
        profileHStack.addSubview(profileImage)
        profileHStack.addSubview(nameLabel)
        cellVStack.addSubview(profileHStack)
        contentView.addSubview(cellVStack)
    
        // Add constraints
        cellVStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
}
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
}

