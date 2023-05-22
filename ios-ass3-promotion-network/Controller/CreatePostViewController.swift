import UIKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var moneySavedField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    var category: String!
    
    private var realmManager = RealmManager.shared
    
    override func viewDidLoad() {
        // Only allow numbers in money saved field
        moneySavedField.delegate = self
        
        super.viewDidLoad()
        setupPopUpButton()
    }

    
    // Add options to the pop up button menu and a handler to handle selection
    func setupPopUpButton() {
        let popUpButtonClosure = { (action: UIAction) in
            self.category = action.title
        }
                
        popUpButton.menu = UIMenu(children: Category.allCases.map{
            UIAction(title: $0.rawValue, handler: popUpButtonClosure)})
        
        popUpButton.showsMenuAsPrimaryAction = true
    }
    
    
    // When button is pressed, show image picker
    @IBAction func imagePicker(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // Set post image from image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        postImage.image = image
        dismiss(animated: true)
    }
    
    // Create post and save it into database (using dummy data for now)
    @IBAction func createButton(_ sender: Any) {
        guard let chosenCategory = category else {return}
        guard let text = descriptionField.text else {return}
        guard let image = postImage.image else {return}
        guard let address = addressField.text else {return}
        guard let moneySaved = moneySavedField.text else {return}
        guard let appUser = getLoginSession()?.appUser.first else {return}
        guard let imageData = image.pngData() else {return}
        
        // For now fake the latitude and longitude until we implement maps
        let latitude = "0"
        let longitude = "0"
        

        let newPost = Post(text: text, image: imageData, address: address, latitude: latitude, longitude: longitude, moneySaved: Double(moneySaved) ?? 0, category: Category(rawValue:chosenCategory)!)
        
        appUser.posts.append(newPost)
        
        if(newPost.createPost()) {
            self.performSegue(withIdentifier: "postCreateSegue", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chosenCategory = category else {return}
        guard let text = descriptionField.text else {return}
        guard let image = postImage.image else {return}
        guard let address = addressField.text else {return}
        guard let moneySaved = moneySavedField.text else {return}
        guard let user = getLoginSession()?.appUser.first else {return}
        
        
        if (segue.identifier == "postCreateSegue") {
            let viewPost = segue.destination as! ViewPostViewController
            viewPost.name = user.firstName
            viewPost.category = chosenCategory
            viewPost.desc = text
            viewPost.image = image
            viewPost.address = address
            viewPost.price = moneySaved
        }
    }
    
    // Only allow numbers in money saved field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

