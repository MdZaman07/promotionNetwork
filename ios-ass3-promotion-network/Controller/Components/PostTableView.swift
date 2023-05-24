//
//  PostTableView.swift
//  ios-ass3-promotion-network
//
//  Created by Rain Holloway on 17/5/2023.
//

import Foundation
import UIKit

class PostTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Post] = []
    
    init(posts: [Post]){
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), style: .plain)
        self.posts = posts
        dataSource = self
        delegate = self
        separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
    }
    
    func addSuperviewConstraints(){
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    // Amount of rows to render
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Rendering each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Style the posts
        let postCell = dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell
        guard let postCell = postCell else { return UITableViewCell() }
        let post = posts[indexPath.row] 
        
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform a segue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
