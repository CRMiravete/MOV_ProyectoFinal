//
//  CreateAccount.swift
//  Practica2y3
//
//  Created by Alumno on 31/03/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccount: UIViewController {
    let ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var program: UITextField!
    @IBOutlet weak var semester: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccount(_ sender: Any) {
        Auth.auth().createUser(
            withEmail: email.text ?? "",
            password: password.text ?? "") { (result, error) in
                
                var alertController: UIAlertController!
                
                if error != nil {
                    alertController = UIAlertController(
                        title: "Error",
                        message: error?.localizedDescription,
                        preferredStyle: .alert)
                    
                    let alertAction: UIAlertAction!
                    alertAction = UIAlertAction(
                        title: "Ok",
                        style: .default)
                    
                    alertController.addAction(alertAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.ref.child("user").child(result!.user.uid).setValue(
                        ["name": self.name.text ?? "", "lastName": self.lastName.text ?? "", "program": self.program.text ?? "", "semester": self.semester.text ?? ""]) { error, DatabaseReference in
                            
                            if error == nil {
                                alertController = UIAlertController(
                                    title: "Account created",
                                    message: "Account created successfully",
                                    preferredStyle: .alert
                                )
                                
                                let alertAction: UIAlertAction!
                                alertAction = UIAlertAction(
                                    title: "Ok",
                                    style: .default)
                                
                                alertController.addAction(alertAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                alertController = UIAlertController(
                                    title: "Error",
                                    message: error?.localizedDescription,
                                    preferredStyle: .alert)
                                
                                let alertAction: UIAlertAction!
                                alertAction = UIAlertAction(
                                    title: "Ok",
                                    style: .default)
                                
                                alertController.addAction(alertAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
        }
    }
