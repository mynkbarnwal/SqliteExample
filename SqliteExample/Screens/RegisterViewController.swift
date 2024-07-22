//
//  RegisterViewController.swift
//  CoreDataExample
//
//  Created by Mayank Barnwal on 17/07/24.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    private let dbManager = DBManager.shared
    
    var user:UserModal!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user{
            fNameTextField.placeholder = user.fName
            lNameTextField.placeholder = user.lName
            emailTextField.text = user.email
            passwordTextField.placeholder = user.password
            registerBtn.setTitle("Update", for: .normal)
            emailTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func onRegisterBtn(_ sender: Any) {
        
        if let user{
            guard let firstName = fNameTextField.text else {
                openAlert(message: "First name can't be blank")
                return
            }
            guard let lastName = lNameTextField.text else {
                openAlert(message: "Last name can't be blank")
                return
            }
            guard let email = emailTextField.text else {
                openAlert(message: "Email id can't be blank")
                return
            }
            
            guard let password = passwordTextField.text else {
                openAlert(message: "Password can't be blank")
                return
            }
            
            let userData = UserModal.init(fName: (firstName == "" ? user.fName : firstName),
                                          lName: (lastName == "" ? user.lName : lastName),
                                          email: (email == "" ? user.email : email),
                                          password: (password == "" ? user.password : password))
            
            if dbManager.updateData(user: userData){
                navigationController?.popViewController(animated: true)
            }
            else{
                openAlert(message: "Something went wrong!!!")
            }
        }else{
            
            guard let firstName = fNameTextField.text, !firstName.isEmpty else {
                openAlert(message: "First name can't be blank")
                return
            }
            guard let lastName = lNameTextField.text, !lastName.isEmpty else {
                openAlert(message: "Last name can't be blank")
                return
            }
            guard let email = emailTextField.text, !email.isEmpty else {
                openAlert(message: "Email id can't be blank")
                return
            }
            
            guard let password = passwordTextField.text, !password.isEmpty else {
                openAlert(message: "Password can't be blank")
                return
            }
            
            let userData = UserModal.init(fName: firstName, lName: lastName, email: email, password: password)
            
            if dbManager.saveData(user: userData){
                navigationController?.popViewController(animated: true)
            }
            else{
                openAlert(message: "Something went wrong!!!")
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: nil, message: "User added", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
    
    func openAlert(message: String){
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okay)
        present(alertController, animated: true)
    }
}


