//
//  ViewController.swift
//  Practica2y3
//
//  Created by Alumno on 31/03/25.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func login(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text ?? "",
                           password: password.text ?? "") {
            AuthDataResult, Error in
            
            if Error == nil {
                self.performSegue(withIdentifier: "ToMain", sender: self)
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: Error?.localizedDescription,
                                                        preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMain" {
            let main = segue.destination as! Main
        }
    }

}

