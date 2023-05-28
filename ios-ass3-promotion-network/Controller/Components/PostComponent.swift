//
//  PostComponent.swift
//  ios-ass3-promotion-network
//
//  Created by Rain Holloway on 22/5/2023.
//

import Foundation
import UIKit

class PostComponent: UIView {
    
    var post: Post?
    
    init(post: Post){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = .orange
        self.post = post
        translatesAutoresizingMaskIntoConstraints = false
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.segueToViewPost(_:))))
        
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.fill")
        
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.text = post.appUser[0].firstName + " " + post.appUser[0].lastName
        nameLabel.font = nameLabel.font.withSize(18)
        
        let profileView = UIView()
        profileView.addSubview(profileImageView)
        profileView.addSubview(nameLabel)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        let profileHStack = UIStackView()
        profileHStack.axis = .horizontal
        profileHStack.alignment = .center
        profileHStack.distribution = .equalSpacing
        profileHStack.spacing = 20
        profileHStack.translatesAutoresizingMaskIntoConstraints = false
        
        let categoryLabel = UILabel()
        categoryLabel.font = categoryLabel.font.withSize(15)
        categoryLabel.textColor = .gray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        let savingsHStack = UIStackView()
//        savingsHStack.axis = .horizontal
//        savingsHStack.alignment = .center
//        savingsHStack.spacing = 10
//        savingsHStack.translatesAutoresizingMaskIntoConstraints = false
//
//        let savingsImage = UIImageView()
//        savingsImage.image = UIImage(systemName: "creditcard")
//        savingsImage.translatesAutoresizingMaskIntoConstraints = false
//
//        let savingsLabel = UILabel()
//        categoryLabel.textColor = .black
//        categoryLabel.font = categoryLabel.font.withSize(15)
//        categoryLabel.textColor = .gray
//        savingsLabel.text = String(post.moneySaved)
//        savingsLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        savingsHStack.addSubview(savingsImage)
//        savingsHStack.addSubview(savingsLabel)
//
//        let metaDataHStack = UIStackView()
//        metaDataHStack.axis = .horizontal
//        metaDataHStack.alignment = .center
//        metaDataHStack.distribution = .equalSpacing
//        metaDataHStack.translatesAutoresizingMaskIntoConstraints = false
//
//        metaDataHStack.addSubview(categoryLabel)
//        metaDataHStack.addSubview(savingsHStack)

        profileHStack.addArrangedSubview(profileImageView)
        profileHStack.addArrangedSubview(nameLabel)
        
        let cellVStack = UIStackView()
        cellVStack.axis = .vertical
        cellVStack.spacing = 10
        cellVStack.distribution = .fillProportionally
        cellVStack.alignment = .center
        cellVStack.translatesAutoresizingMaskIntoConstraints = false
        
        cellVStack.addArrangedSubview(profileHStack)
        cellVStack.addArrangedSubview(categoryLabel)
//        cellVStack.addArrangedSubview(metaDataHStack)
        
        addSubview(cellVStack)
    }
    
    @objc func segueToViewPost(_ sender: UITapGestureRecognizer){
        // Work on this once view post page is ready
        guard let post = post else { return }
        print(post.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
