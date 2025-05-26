package com.example.turnstyle3

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ktx.database
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.ktx.Firebase

import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions

class QrView : AppCompatActivity() {

    private var read = ""
    private lateinit var auth: FirebaseAuth
    private var email =""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_qr_view)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        auth = FirebaseAuth.getInstance()

        val user = auth.currentUser
        if(user!=null){
            email = user.email.toString()
        } else {
            Toast.makeText(this, "Gracias por su preferencia", Toast.LENGTH_SHORT)
            auth.signOut()
            Intent(this, MainActivity::class.java)
        }
    }

    private val barcodeLauncher = registerForActivityResult<ScanOptions, ScanIntentResult>(
        ScanContract()
    ) { result: ScanIntentResult ->
        if (result.contents == null) {
            Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show()
        } else {
            val clave = result.contents.toString()
            Toast.makeText(this, "Código escaneado: $clave", Toast.LENGTH_LONG).show()
            processQr(clave)
        }
    }

    fun scanQr(view: View?) {
        val options = ScanOptions()
        options.setDesiredBarcodeFormats(ScanOptions.QR_CODE)
        options.setPrompt("Scan a barcode")
        options.setCameraId(0)
        options.setBeepEnabled(true)
        options.setBarcodeImageEnabled(true)

        barcodeLauncher.launch(options)
    }

    fun processQr(clave: String) {
        val database = Firebase.database
        val dbRef = database.getReference("claves").child(clave)

        dbRef.get().addOnSuccessListener { snapshot ->
            if (snapshot.exists()) {
                val estatus = snapshot.child("status").value?.toString()

                when (estatus) {
                    "ocupado" -> {
                        showMessage("¡Buen viaje!")
                        val uid = snapshot.child("usuario").value?.toString()

                        if (!uid.isNullOrEmpty()) {
                            val usuarioRef = FirebaseDatabase.getInstance()
                                .getReference("claves/usuario/$uid")

                            usuarioRef.get().addOnSuccessListener { usuarioSnap ->
                                val nombre = usuarioSnap.child("nombre").value?.toString()
                                val apellido = usuarioSnap.child("apellido").value?.toString()
                                showMessage("¡Buen viaje, $nombre $apellido!")
                            }
                        }
                    }

                    "libre" -> {
                        showMessage("QR utilizado. Genere un nuevo QR para ingresar.")
                    }

                    else -> {
                        showMessage("Estatus desconocido.")
                    }
                }
            } else {
                showMessage("Clave no encontrada.")
            }
        }.addOnFailureListener {
            showMessage("Error al acceder a la base de datos.")
        }
    }

    fun showMessage(newMessage: String){
        val message = findViewById<TextView>(R.id.message)
        message.text = "Mensaje: $newMessage"
    }

    fun logout(view: View?){
        auth.signOut()
        Toast.makeText(this, "Gracias por su preferencia", Toast.LENGTH_SHORT)
        startActivity(Intent(this, MainActivity::class.java))
    }
}