//
//  SignUpViewController.swift
//  MyTravels
//
//  Created by Frank Martin Jr on 6/14/18.
//  Copyright © 2018 Frank Martin Jr. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Constants & Variables
    var logIn: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var skipButtonTapped: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        signUpButton.formatBlue()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var frame = self.tableView.frame
        frame.size = self.tableView.contentSize
        self.tableView.frame = frame
    }
    
    // MARK: - Actions
    @IBAction func skipButtonTapped(_ sender: Any) {
        presentTripListVC()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "userSkippedSignUp")
        if logIn == true {
            signIn()
            return
        }
        createNewAccount()
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        logIn = !logIn
        updateButtonTitles()
        tableView.reloadData()
    }
}

extension SignUpViewController {
    
    func createNewAccount() {
        
        let firstNameCellIndexPath = IndexPath(row: 0, section: 0)
        let firstNameCell = (tableView.cellForRow(at: firstNameCellIndexPath)) as! TextFieldTableViewCell
        guard let firstName = firstNameCell.entryTextField.text, !firstName.isEmpty else { return }
        
        // Last name is optional
        let lastNameCellIndexPath = IndexPath(row: 1, section: 0)
        let lastNameCell = (tableView.cellForRow(at: lastNameCellIndexPath)) as! TextFieldTableViewCell
        let lastName = lastNameCell.entryTextField.text
        
        let usernameCellIndexPath = IndexPath(row: 2, section: 0)
        let usernameCell = (tableView.cellForRow(at: usernameCellIndexPath)) as! TextFieldTableViewCell
        guard let username = usernameCell.entryTextField.text else { return }
        
        let emailCellIndexPath = IndexPath(row: 3, section: 0)
        let emailCell = (tableView.cellForRow(at: emailCellIndexPath)) as! TextFieldTableViewCell
        guard let email = emailCell.entryTextField.text, !email.isEmpty else { return }
        
        let passwordCellIndexPath = IndexPath(row: 4, section: 0)
        let passwordCell = (tableView.cellForRow(at: passwordCellIndexPath) as! TextFieldTableViewCell)
        guard let password = passwordCell.entryTextField.text else { return }
        
        let passwordConfCellIndexPath = IndexPath(row: 5, section: 0)
        let passwordConfCell = (tableView.cellForRow(at: passwordConfCellIndexPath) as! TextFieldTableViewCell)
        guard let passwordConf = passwordConfCell.entryTextField.text else { return }
        
        if password == passwordConf {
            InternalUserController.shared.createNewUserWith(firstName: firstName, lastName: lastName, username: username, email: email, password: password) { (success) in
                if success {
                    self.presentTripListVC()
                } else {
                    let alertController = UIAlertController(title: "Something went wrong.", message: "Please try again.", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "Oops!", message: "Your passwords do not match -- please re-enter your passwords", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                passwordCell.entryTextField.text = ""
                passwordConfCell.entryTextField.text = ""
            })
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func signIn() {
        
        let emailCellIndexPath = IndexPath(row: 0, section: 0)
        let emailCell = (tableView.cellForRow(at: emailCellIndexPath)) as! TextFieldTableViewCell
        guard let email = emailCell.entryTextField.text, !email.isEmpty else { return }
        
        let passwordCellIndexPath = IndexPath(row: 1, section: 0)
        let passwordCell = (tableView.cellForRow(at: passwordCellIndexPath) as! TextFieldTableViewCell)
        guard let password = passwordCell.entryTextField.text else { return }
        
        InternalUserController.shared.login(withEmail: email, password: password) { (error) in
            if let error = error {
                // FIXME: Need error handling
                print("There was an error logging in the user: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
                let tripListVC = ((tabBarController?.customizableViewControllers?.first! as! UINavigationController).viewControllers.first!) as! TripsListViewController
                tripListVC.fromSignUpVC = true
                self.present(tabBarController!, animated: true, completion: nil)
            }
        }
    }
    
    func updateButtonTitles() {
        if logIn == true {
            signUpButton.setTitle("Log in", for: .normal)
            loginButton.setTitle("Sign Up", for: .normal)
        } else {
            signUpButton.setTitle("Sign Up", for: .normal)
            loginButton.setTitle("Log in", for: .normal)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if logIn == true {
            return 2
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as? TextFieldTableViewCell else { return UITableViewCell() }
        
        cell.entryTextField.returnKeyType = .next
        cell.entryTextField.addKeyboardDone(targetVC: self, selector: #selector(dismissKeyboard))
        cell.entryTextField.tag = indexPath.row
        cell.entryTextField.delegate = self
        
        if logIn == true {
            switch indexPath.row {
            case 0:
                cell.entryTextField.placeholder = "Email"
                cell.entryTextField.textContentType = UITextContentType.emailAddress
                cell.entryTextField.keyboardType = .emailAddress
            case 1:
                cell.entryTextField.placeholder = "Password"
                cell.entryTextField.textContentType = UITextContentType.password
                cell.entryTextField.isSecureTextEntry = true
                cell.entryTextField.returnKeyType = .done
            default:
                print("Something went wrong")
            }
        } else {
            
            switch indexPath.row {
            case 0:
                cell.entryTextField.placeholder = "First name"
                cell.entryTextField.textContentType = UITextContentType.givenName
            case 1:
                cell.entryTextField.placeholder = "Last name (optional)"
                cell.entryTextField.textContentType = UITextContentType.familyName
            case 2:
                cell.entryTextField.placeholder = "Username"
            case 3:
                cell.entryTextField.placeholder = "Email"
                cell.entryTextField.textContentType = UITextContentType.emailAddress
                cell.entryTextField.keyboardType = .emailAddress
            case 4:
                cell.entryTextField.placeholder = "Password"
                cell.entryTextField.textContentType = UITextContentType.password
                cell.entryTextField.isSecureTextEntry = true
            case 5:
                cell.entryTextField.placeholder = "Confirm Password"
                cell.entryTextField.textContentType = UITextContentType.password
                cell.entryTextField.isSecureTextEntry = true
                cell.entryTextField.returnKeyType = .done
            default:
                break
            }
        }
        
        return cell
        
    }
}

extension SignUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if logIn == true {
            if textField.tag == 1 {
                signIn()
                return true
            }
        }
        if textField.tag == 5 {
            createNewAccount()
            return true
        }
        
        let nextResponderIndexPath = IndexPath(row: textField.tag + 1, section: 0)
        (tableView.cellForRow(at: nextResponderIndexPath) as! TextFieldTableViewCell).entryTextField.becomeFirstResponder()
        
        return true
    }
}
