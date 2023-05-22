import UIKit
import GoogleMaps

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var popUpButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var moneySavedField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var createButton: UIBarButtonItem!
    var category: String!
    
    private var realmManager = RealmManager.shared
    
    var latitude: String = ""
    var longitude: String = ""
    var address: String = ""
    var createdPost: Post?

    override func viewDidLoad() {
        // Only allow numbers in money saved field
        moneySavedField.delegate = self
        super.viewDidLoad()
        setupPopUpButton()
        addressField.isEnabled=false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressField.text = address
    }

    
    // Add options to the pop up button menu and a handler to handle selection
    func setupPopUpButton() {
        let popUpButtonClosure = { (action: UIAction) in
            self.category = action.title
        }
                
        popUpButton.menu = UIMenu(children: Category.allCases.map{
            UIAction(title: $0.rawValue, handler: popUpButtonClosure)})
        popUpButton.showsMenuAsPrimaryAction = true
        applyBorderStylingToButton(buttons:[popUpButton])

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
    

    @IBAction func selectAddressPressed(_ sender: Any) {
        pushToMapSearchViewController()
    }
    
    func pushToMapSearchViewController(){
        let vc = storyboard?.instantiateViewController(identifier: "MapSearchViewController") as! MapSearchViewController
        vc.vc = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Create post and save it into database (using dummy data for now)
    @IBAction func createButton(_ sender: Any) {
        guard let chosenCategory = category else {textFieldErrorAction(field: descriptionField, msg: "Category can't be empty"); return}
        guard let text = descriptionField.text else {textFieldErrorAction(field: descriptionField, msg: "Description can't be empty"); return}
        guard let address = descriptionField.text else {textFieldErrorAction(field: descriptionField, msg: "Address can't be empty"); return}
        guard let moneySaved = moneySavedField.text else {textFieldErrorAction(field: descriptionField, msg: "Money saved can't be empty"); return}

        let image = postImage.image?.pngData() ?? nil
        
        let newPost = Post(text: text, image: image, address: address, latitude: latitude, longitude: longitude, moneySaved: Double(moneySaved) ?? 0, category: Category(rawValue:chosenCategory)!) //create new post
        
        
        if(newPost.createPost()) {
            createdPost = newPost
            self.performSegue(withIdentifier: "postCreateSegue", sender: self)
        }
        else{
            textFieldErrorAction(field: descriptionField, msg: "Error creating the post")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let image = postImage.image //image is not mandatory
        
        if (segue.identifier == "postCreateSegue") {
            let viewPost = segue.destination as! ViewPostViewController
            viewPost.post = createdPost ?? nil
        }
    }
    
    // Only allow numbers in money saved field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

