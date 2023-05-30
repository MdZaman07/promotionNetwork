//
//  ViewController.swift
//  ios-ass3-promotion-network
//
//  Created by Malena Diaz Rio on 2/5/23.
//

import UIKit

class SearchPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var categoryPopupButton: UIButton!
    
    var posts: [Post] = []
    var categoryText = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add event listener to the category popup button
        let popUpButtonClosure = { (action: UIAction) in
            self.categoryText = action.title
            self.search()
        }
            
        // Assign all categories available to search to the popup button
        categoryPopupButton.menu = UIMenu(children: [
            UIAction(title: "All", handler: popUpButtonClosure),
            UIAction(title: Category.foodDrinks.rawValue, handler: popUpButtonClosure),
            UIAction(title: Category.homewear.rawValue, handler: popUpButtonClosure),
            UIAction(title: Category.fashion.rawValue, handler: popUpButtonClosure),
            UIAction(title: Category.personalCare.rawValue, handler: popUpButtonClosure),
            UIAction(title: Category.other.rawValue, handler: popUpButtonClosure),
        ])
        
        categoryPopupButton.showsMenuAsPrimaryAction = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Assign event listener to the search button
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    @objc func searchButtonClicked(_ sender: UIButton) {
        search()
    }

    func search(){
        let query = queryTextField.text?.lowercased() ?? ""
        
        guard let realm = RealmManager.shared.realm else { return }
        var searchPosts = Array(realm.objects(Post.self))
        
        searchPosts = searchPosts.filter { post in
            // Search for posts with a specific category or all
            if !categoryText.elementsEqual("All") && !post.category.rawValue.elementsEqual(categoryText) {
                return false
            }
            
            // Check for posts with the description containing the search query
            if !query.elementsEqual("") && !post.description.lowercased().contains(query) {
                return false
            }
            
            return true
        }
        
        // Order by date to ensure newest posts are rendered at the top of the table
        searchPosts.sort {
            $0.date > $1.date
        }
        
        // Reload table data with new posts retrieved from the search query
        posts = searchPosts
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Populate each cell with its corresponding post data
        let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TableViewCellPost
        postCell.populate(post: posts[indexPath.row])
        return postCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Generate a new instance of the view post controller and navigate to it
        let viewPostViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewPostViewController") as! ViewPostViewController
        viewPostViewController.post = posts[indexPath.row]
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewPostViewController, animated: true)
        }
    }
}

