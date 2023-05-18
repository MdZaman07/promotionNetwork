import UIKit

class CreateProfileViewController: UIViewController {

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
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createProfile(_ sender: Any) {
        // Unwrap optionals
        guard let username = usernameField.text else {return}
        guard let firstName = firstNameField.text else {return}
        guard let lastName = lastNameField.text else {return}
        guard let password = passwordField.text else {return}
        guard let city = cityField.text else {return}
        guard let description = descriptionField.text else {return}
        guard let email = emailField.text else {return}

        // Create new user instance
        let newUser = AppUser(userName: username, firstName: firstName, lastName: lastName, email: email, password: password, city: city, bio: description)
        
        // Add user to realm db, if result is false, don't push to login screen
        if(!newUser.createUser()) {
            print("Error creating user")
            return
        }
        
        // Push Login Screen
        let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

