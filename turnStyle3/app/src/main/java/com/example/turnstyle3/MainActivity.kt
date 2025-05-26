package com.example.turnstyle3

import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_main)
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }
        auth = FirebaseAuth.getInstance()
        var btnLogin = findViewById<TextView>(R.id.button)
        btnLogin.setOnClickListener{
            var email = findViewById<TextView>(R.id.email).text
            var password = findViewById<TextView>(R.id.password).text
            auth.signInWithEmailAndPassword(email.toString(), password.toString())
                .addOnCompleteListener{ result ->
                    if(result.isSuccessful){
                        Toast.makeText(this, "Usuario autenticado, bienvenido", Toast.LENGTH_LONG)
                            .show()
                        startActivity(
                            Intent(this, QrView::class.java)
                        )
                    } else {
                        Toast.makeText(
                            this,
                            "Error: " + (result.exception?.message ?: "Error"),
                            Toast.LENGTH_LONG
                        ).show()
                    }
                }
        }
    }
    public override fun onStart(){
        super.onStart()
        val currentUser = auth.currentUser

        if(currentUser == null){
            Toast.makeText(this, "No hay usuarios autenticados", Toast.LENGTH_LONG).show()
        } else {
            Toast.makeText(this, "Bienvenido " + currentUser.email.toString(), Toast.LENGTH_LONG).show()
            Intent(this, QrView::class.java)
        }
    }
}

