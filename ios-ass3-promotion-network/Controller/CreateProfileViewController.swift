import UIKit

class CreateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var profilePictureField: UIImageView!

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    var isEdit: Bool = false
    var newPictureSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tap gesture on profile picture field to open up image picker
        let uiTapGR = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
        profilePictureField.addGestureRecognizer(uiTapGR)
        profilePictureField.isUserInteractionEnabled = true
        
        // Make profile picture field a circle
        profilePictureField.layer.cornerRadius = profilePictureField.frame.size.width / 2
        profilePictureField.clipsToBounds = true
        
        // Mas password fields
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
        
        // Do any additional setup after loading the view.
        applyBorderStylingToTextFields(fields: [confirmPasswordField,
                                          passwordField, cityField, emailField, usernameField, lastNameField, firstNameField])
        applyBorderStylingToTextViews(fields: [descriptionTextView])
        descriptionTextView.delegate = self

        if(isEdit) {
            populateEditFields()
            passwordField.placeholder = "New password (leave empty if not changing)"
            createButton.setTitle("Update", for: .normal)
        }
    }
    
    //function for the text view
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    //function to display placeholder if nothing is in the text view
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.placeholderText
        }
    }
    
    func populateEditFields() {
        guard let currentUser = getCurrentUser() else {return}
        usernameField.text = currentUser.userName
        firstNameField.text = currentUser.firstName
        lastNameField.text = currentUser.lastName
        emailField.text = currentUser.email
        cityField.text = currentUser.city
        descriptionTextView.text = currentUser.bio
        if let description = descriptionTextView.text, !description.isEmpty {
            descriptionTextView.textColor = UIColor.black
        }
        // Get image from S3 and populate image field
        if !currentUser.profileImageKey.elementsEqual("") {
            AWSManager.shared.getOneImage(key: currentUser.profileImageKey){ [weak self] result in
                switch result{
                case .success (let image):
                    DispatchQueue.main.async {
                        self?.profilePictureField.contentMode = .scaleAspectFit
                        self?.profilePictureField.image = image
                    }
                case .failure(let error):
                    self?.profilePictureField.image = UIImage(systemName: "person.fill")
                    print(error)
                }
            }
        } else {
            profilePictureField.image = UIImage(systemName: "person.fill")
        }
        
        //passwordField.text = currentUser.password
    }
    
    func validateEmptyFields() -> Bool {
        // Unwrap optionals
        guard let username = usernameField.text, !username.isEmpty else { textFieldErrorAction(field: usernameField, msg: "Username can't be empty"); return false }
        guard let firstName = firstNameField.text, !firstName.isEmpty else { textFieldErrorAction(field: firstNameField, msg: "Name can't be empty"); return false }
        guard let lastName = lastNameField.text, !lastName.isEmpty else { textFieldErrorAction(field: lastNameField, msg: "Name can't be empty"); return false }
        guard let email = emailField.text, !email.isEmpty else { textFieldErrorAction(field: emailField, msg: "Email can't be empty"); return false }
        guard let city = cityField.text, !city.isEmpty else { textFieldErrorAction(field: cityField, msg: "City can't be empty"); return false }
        guard descriptionTextView.textColor != UIColor.placeholderText, let description = descriptionTextView.text, !description.isEmpty else { textViewErrorAction(field: descriptionTextView, msg: "Description can't be empty"); return false }
        if(!isEdit) {
            guard let password = passwordField.text, !password.isEmpty else { textFieldErrorAction(field: passwordField, msg: "Password an't be empty"); return false }
        }
        
        return true
    }
    
    
    @IBAction func createProfile(_ sender: Any) {
        if(!validateEmptyFields()) {
            return
        }

        
        // Validate text fields after checking mandatory fields
        if(!validateTextFields()) {
            return
        }
        
        if(!isEdit) {
            var uploadProfilePicture: UIImage?
            
            // Check if profile picture is placeholder symbol image, if not, upload to S3
            if(profilePictureField.image!.isSymbolImage) {
                uploadProfilePicture = nil
            } else {
                uploadProfilePicture = profilePictureField.image
            }

            // Create new user instance
            let newUser = AppUser(userName: usernameField.text!, firstName: firstNameField.text!, lastName: lastNameField.text!, email: emailField.text!, password: passwordField.text!, city: cityField.text!, bio: descriptionTextView.text!)
            
            // Add user to realm db, if result is false, don't push to login screen
            if(!newUser.createUser(profilePicture: uploadProfilePicture)) {
                print("Error creating user")
                return
            }
        } else {
            let currentUser = getCurrentUser()!
            
            var uploadProfilePicture: UIImage? = nil
            
            // Check if new profile picture has been selected, upload to S3 if that's the case
            if(newPictureSelected) {
                uploadProfilePicture = profilePictureField.image
            }
            
            let fieldValues = [
                "firstName": firstNameField.text!,
                "lastName": lastNameField.text!,
                "userName": usernameField.text!,
                "email": emailField.text!,
                "password": passwordField.text!,
                "city": cityField.text!,
                "bio": descriptionTextView.text!
            ]
            
            if(!currentUser.updateAccount(profilePicture: uploadProfilePicture, fieldValues: fieldValues)) {
                return
            }
        }
        
        
        // Push to login screen if creating a new account. Push to profile screen if editing
        if(!isEdit) {
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            // Push to profile view
            let vc = storyboard?.instantiateViewController(identifier: "UITabBarController") as! UITabBarController
            // Access tab bar index view
            vc.selectedIndex = 4
            self.navigationController?.pushViewController(vc, animated: true)
        }

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
        newPictureSelected = true
        
        // Fit image in container
        profilePictureField.contentMode = .scaleAspectFit
        profilePictureField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func validateTextFields() -> Bool {
        // Check if username is alphanumeric
        guard let username = usernameField.text, regularExpressionValidator(regex: "^[a-zA-Z0-9]+$", compareString: username) else {
            textFieldErrorAction(field: usernameField, msg: "Username can only be alphanumeric")
            return false
        }
        
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
        guard let city = cityField.text, regularExpressionValidator(regex: "^[a-zA-Z\\s]+$", compareString: city) else {
            textFieldErrorAction(field: cityField, msg: "City can only consist of letters")
            return false
        }
        
        // Check if confirm password matches
        guard let confirmPassword = confirmPasswordField.text, let password = passwordField.text, confirmPassword == password else { textFieldErrorAction(field: confirmPasswordField, msg: "Passwords don't match"); return false}

        
        return true
    }
    
    // Test regular expression with supplied string
    func regularExpressionValidator(regex: String, compareString: String) -> Bool {
        let comparisonPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return comparisonPredicate.evaluate(with: compareString)
    }
    
    // Set up nav bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController {
            let controllers = navigationController.viewControllers
            
            navigationController.topViewController?.navigationItem.title = isEdit ? "Edit Account" : "Create Account"
            navigationController.viewControllers = controllers
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.topViewController?.navigationItem.title = "Back"
        navigationController?.topViewController?.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

