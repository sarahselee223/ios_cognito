//
//  ViewController.swift
//  iOS_Cognito
//
//  Created by Sarah Lee on 12/2/19.
//  Copyright © 2019 Sarah Lee. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField?
    @IBOutlet weak var passwordInput: UITextField?
    @IBOutlet weak var loginButton: UIButton?
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.passwordInput?.addTarget(self, action: #selector(inputDidChange(_:)), for: .editingChanged)
        self.emailInput?.addTarget(self, action: #selector(inputDidChange(_:)), for: .editingChanged)
    }
    
    @objc func inputDidChange(_ sender:AnyObject){
        if (self.emailInput?.text != nil && self.passwordInput?.text != nil) {
            self.loginButton?.isEnabled = true
        } else {
            self.loginButton?.isEnabled = false
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if(self.emailInput?.text == nil || self.passwordInput?.text == nil) {
            return
        }
        let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.emailInput!.text!, password: self.passwordInput!.text!)
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
}

extension LoginViewController: AWSCognitoIdentityPasswordAuthentication {
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
        DispatchQueue.main.async {
            if (self.emailInput?.text == nil){
                self.emailInput?.text = authenticationInput.lastKnownUsername
            }
        }
    }
    func didCompleteStepWithError(_ error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                let alertController = UIAlertController(title: "Cannot Login", message: (error! as NSError).userInfo["message"] as? String, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: {
                    self.emailInput?.text = nil
                    self.passwordInput?.text = nil
                })
            }
        }
    }
    
}

