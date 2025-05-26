//
//  EditAccount.swift
//  e-Ticket
//
//  Created by Jorge Fong on 26/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditAccount: UIViewController {
    let ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var program: UITextField!
    @IBOutlet weak var semester: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func updateAccount(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "No user is currently logged in.")
            return
        }

        var updates = [String: Any]()

        if let nameText = name.text, !nameText.isEmpty {
            updates["name"] = nameText
        }

        if let lastNameText = lastName.text, !lastNameText.isEmpty {
            updates["lastName"] = lastNameText
        }

        if let programText = program.text, !programText.isEmpty {
            updates["program"] = programText
        }

        if let semesterText = semester.text, !semesterText.isEmpty {
            updates["semester"] = semesterText
        }

        if updates.isEmpty {
            showAlert(title: "No Changes", message: "Please fill in at least one field to update.")
            return
        }

        ref.child("user").child(userID).updateChildValues(updates) { error, _ in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Information updated successfully.")
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
}
