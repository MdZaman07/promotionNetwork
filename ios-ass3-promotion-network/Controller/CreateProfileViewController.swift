import UIKit

class CreateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
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
        guard let username = usernameField.text, !username.isEmpty else { textFieldErrorAction(field: usernameField, msg: "Can't be empty"); return }
        guard let firstName = firstNameField.text, !firstName.isEmpty else { textFieldErrorAction(field: firstNameField, msg: "Can't be empty"); return }
        guard let lastName = lastNameField.text, !lastName.isEmpty else { textFieldErrorAction(field: lastNameField, msg: "Can't be empty"); return }
        guard let email = emailField.text, !email.isEmpty else { textFieldErrorAction(field: emailField, msg: "Can't be empty"); return }
        guard let city = cityField.text, !city.isEmpty else { textFieldErrorAction(field: cityField, msg: "Can't be empty"); return }
        guard let password = passwordField.text, !password.isEmpty else { textFieldErrorAction(field: passwordField, msg: "Can't be empty"); return }
        guard let description = descriptionField.text, !description.isEmpty else { textFieldErrorAction(field: descriptionField, msg: "Can't be empty"); return }

        
        // Validate text fields after checking mandatory fields
        if(!validateTextFields()) {
            return
        }
        
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
    
    func textFieldErrorAction(field: UITextField, msg: String) {
        print(msg)
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.red.cgColor
        
    }
    
    func validateTextFields() -> Bool {
        // Check if names have numbers
        guard let firstName = firstNameField.text, regularExpressionValidator(regex: "^[a-zA-Z]+$", compareString: firstName) else {
            textFieldErrorAction(field: firstNameField, msg: "Name can only consist of letters")
            return false
        }
        
        guard let lastName = lastNameField.text, regularExpressionValidator(regex: "^[a-zA-Z]+$", compareString: lastName) else {
            textFieldErrorAction(field: lastNameField, msg: "Name can only consist of letters")
            return false
        }
        
        // Check if email is valid
        guard let email = emailField.text, regularExpressionValidator(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", compareString: email) else {
            textFieldErrorAction(field: emailField, msg: "Invalid email format")
            return false
        }
        
        // Check if city has numbers
        guard let city = cityField.text, regularExpressionValidator(regex: "^[a-zA-Z]+$", compareString: city) else {
            textFieldErrorAction(field: cityField, msg: "City can only consist of letters")
            return false
        }
        
        // Check if confirm password matches
        guard let confirmPassword = confirmPasswordField.text, let password = passwordField.text, confirmPassword == password else { textFieldErrorAction(field: confirmPasswordField, msg: "Passwords don't match"); return false}

        
        return true
    }
    
    func regularExpressionValidator(regex: String, compareString: String) -> Bool {
        let comparisonPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return comparisonPredicate.evaluate(with: compareString)
    }
    
}

