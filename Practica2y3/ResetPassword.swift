//
//  ResetPassword.swift
//  Practica2y3
//
//  Created by Jorge Fong on 26/05/25.
//

import UIKit
import FirebaseAuth

class ResetPassword: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func resetPasswordTapped(_ sender: Any) {
        guard let email = emailField.text,
              let oldPassword = oldPasswordField.text,
              let newPassword = newPasswordField.text,
              !email.isEmpty, !oldPassword.isEmpty, !newPassword.isEmpty else {
            showAlert(title: "Error", message: "Todos los campos son obligatorios.")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)

        Auth.auth().signIn(withEmail: email, password: oldPassword) { (authResult, error) in
            if let error = error {
                self.showAlert(title: "Error de autenticación", message: error.localizedDescription)
                return
            }

            authResult?.user.reauthenticate(with: credential) { (_, error) in
                if let error = error {
                    self.showAlert(title: "Reautenticación fallida", message: error.localizedDescription)
                    return
                }

                // Cambiar la contraseña
                Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                    if let error = error {
                        self.showAlert(title: "Error al cambiar la contraseña", message: error.localizedDescription)
                    } else {
                        self.showAlert(title: "Éxito", message: "Contraseña actualizada correctamente.")
                    }
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

