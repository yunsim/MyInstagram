/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOrLog(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            createAlert(title: "Error in form", message: "Please enter an email and password")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: {(success, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil {
                        var displayError = "Please try again"
                        if let errorMessage = error?.localizedDescription {
                            displayError = errorMessage
                        }
                        self.createAlert(title: "Sign Up Error", message: displayError)
                    } else {
                        print("user signed up")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            } else {
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil {
                        var displayError = "Please try again"
                        if let errorMessage = error?.localizedDescription {
                            displayError = errorMessage
                        }
                        self.createAlert(title: "Log In Error", message: displayError)
                    } else {
                        print("logged in")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }

                })
            }
        }
    }
    
    @IBOutlet var signOrLog: UIButton!
    
    @IBAction func changeSignupMode(_ sender: Any) {
        if signupMode {
            // change to log in mode
            signOrLog.setTitle("Log In", for: [])
            changeSignupMode.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            signupMode = false
        } else {
            // change to sign up mode
            signOrLog.setTitle("Sign Up", for: [])
            changeSignupMode.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account?"
            signupMode = true
        }
    }
    
    @IBOutlet var changeSignupMode: UIButton!
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
}
