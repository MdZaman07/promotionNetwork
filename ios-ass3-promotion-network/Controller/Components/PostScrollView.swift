//
//  PostSlideView.swift
//  ios-ass3-promotion-network
//
//  Created by Rain Holloway on 22/5/2023.
//

import Foundation
import UIKit

class PostScrollView: UIView {
    
    var posts: [Post] = []
    var isScrollView = false
    var scrollView: UIScrollView?
    var stackView = UIStackView()
    
    init(posts: [Post], isScrollView: Bool){
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.posts = posts
        self.isScrollView = isScrollView
        if isScrollView {
            scrollView = UIScrollView()
            guard let scrollView = scrollView else { return }
            scrollView.addSubview(stackView)
            addSubview(scrollView)
            addSuperviewConstraints(element: scrollView)
        } else {
            addSubview(stackView)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        renderPosts()
    }
    
    func setPosts(posts: [Post]){
        self.posts = posts
        renderPosts()
    }
    
    func renderPosts(){
        removeAllSubviews()
        
        // Add all PostComponents
        for post in posts {
            let newPost = PostComponent(post: post)
            stackView.addArrangedSubview(newPost)
        }
    }
    
    func removeAllSubviews(){
        for view in stackView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func configureConstraints(){
        addSuperviewConstraints(element: self)
    }
    
    func addSuperviewConstraints(element: UIView){
        guard let superview = element.superview else { return }
        
        element.translatesAutoresizingMaskIntoConstraints = false
        
        element.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        element.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        element.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        element.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
