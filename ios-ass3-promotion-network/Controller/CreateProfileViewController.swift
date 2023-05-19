import UIKit

class CreateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePictureField: UIImageView!

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    
    override func viewDidLoad() {
        // Register tap gesture on profile picture field to open up image picker
        let uiTapGR = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
        profilePictureField.addGestureRecognizer(uiTapGR)
        profilePictureField.isUserInteractionEnabled = true
                
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createProfile(_ sender: Any) {
        // Unwrap optionals
        guard let username = usernameField.text, !username.isEmpty else {return}
        guard let firstName = firstNameField.text, !firstName.isEmpty else {return}
        guard let lastName = lastNameField.text, !lastName.isEmpty else {return}
        guard let password = passwordField.text, !password.isEmpty else {return}
        guard let city = cityField.text, !city.isEmpty else {return}
        guard let description = descriptionField.text, !description.isEmpty else {return}
        guard let email = emailField.text, !email.isEmpty else {return}
        
        var uploadProfilePicture: UIImage?
        
        // Check if profile picture is placeholder symbol image, if not, upload to S3
        if(profilePictureField.image!.isSymbolImage) {
            uploadProfilePicture = nil
        } else {
            uploadProfilePicture = profilePictureField.image
        }

        // Create new user instance
        let newUser = AppUser(userName: username, firstName: firstName, lastName: lastName, email: email, password: password, city: city, bio: description)
        
        // Add user to realm db, if result is false, don't push to login screen
        if(!newUser.createUser(profilePicture: uploadProfilePicture)) {
            print("Error creating user")
            return
        }
        
        // Push Login Screen
        let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // When picture is pressed, show image picker
    @objc func showImagePicker(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    // Set post image from image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        profilePictureField.image = image
        dismiss(animated: true)
    }
}

