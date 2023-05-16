import UIKit

class CreatePostViewController: UIViewController {
    @IBOutlet weak var popUpButton: UIButton!
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpButton()
    }

    
    // Add options to the pop up button menu and a handler to handle selection
    func setupPopUpButton() {
        let popUpButtonClosure = { (action: UIAction) in
            self.category = action.title
        }
                
        popUpButton.menu = UIMenu(children: [
            UIAction(title: "Food", handler: popUpButtonClosure),
            UIAction(title: "Drink", handler: popUpButtonClosure)
        ])
        
        popUpButton.showsMenuAsPrimaryAction = true
    }
}

