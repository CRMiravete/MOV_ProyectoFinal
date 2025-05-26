//
//  Main.swift
//  Practica2y3
//
//  Created by Alumno on 31/03/25.
//

import UIKit
import FirebaseDatabase
import CoreImage.CIFilterBuiltins

class Main: UIViewController {
    
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var qrImageView: UIImageView! // Asegúrate de conectarlo en el Storyboard

    var greetingText: String = ""
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greeting.text = greeting.text! + greetingText

        generateQRCodeFromDatabase()
    }

    func generateQRCodeFromDatabase() {
        let ref = Database.database().reference()
        ref.child("claves").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let estatus = value["estatus"] as? String,
                   estatus == "QR sin generar",
                   let clave = value["clave"] as? String {
                    
                    // Generar QR
                    if let qr = self.generateQRCode(from: clave) {
                        DispatchQueue.main.async {
                            self.qrImageView.image = qr
                        }
                    }

                    // Actualizar estatus
                    ref.child("claves").child(snap.key).child("estatus").setValue("QR generado") { error, _ in
                        if let error = error {
                            print("Error actualizando clave: \(error.localizedDescription)")
                        } else {
                            print("Clave \(clave) actualizada a 'QR generado'")
                        }
                    }

                    break // Solo procesamos una clave
                }
            }
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return nil
    }
}

