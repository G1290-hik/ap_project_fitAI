@file:Suppress("DEPRECATION")

package com.example.fitai

import android.os.Bundle
import android.util.Patterns
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.foundation.shape.RoundedCornerShape
import com.example.fitai.ui.theme.FitAITheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            FitAITheme {
                var isLoggedIn by remember { mutableStateOf(false) }
                var isInSignup by remember { mutableStateOf(false) }
                var selectedItem by remember { mutableIntStateOf(0) }
                val items = listOf("Home", "Suggest", "Profile")

                if (!isLoggedIn) {
                    if (isInSignup) {
                        SignupScreen(
                            onSignupSuccess = { isLoggedIn = true },
                            onNavigateToLogin = { isInSignup = false }
                        )
                    } else {
                        LoginScreen(
                            onLoginSuccess = { isLoggedIn = true },
                            onNavigateToSignup = { isInSignup = true }
                        )
                    }
                } else {
                    Scaffold(
                        modifier = Modifier.fillMaxSize(),
                        bottomBar = {
                            BottomNavigationBar(
                                items = items,
                                selectedItem = selectedItem,
                                onItemSelected = { selectedItem = it }
                            )
                        }
                    ) { innerPadding ->
                        when (selectedItem) {
                            0 -> HomeScreen(modifier = Modifier.padding(innerPadding))
                            1 -> SuggestScreen(modifier = Modifier.padding(innerPadding))
                            2 -> ProfileScreen(modifier = Modifier.padding(innerPadding))
                        }
                    }
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BottomNavigationBar(
    items: List<String>,
    selectedItem: Int,
    onItemSelected: (Int) -> Unit
) {
    NavigationBar {
        items.forEachIndexed { index, item ->
            val icon = when (item) {
                "Home" -> Icons.Filled.Home
                "Suggest" -> Icons.Filled.ThumbUp
                "Profile" -> Icons.Filled.Person
                else -> Icons.Filled.Home
            }

            NavigationBarItem(
                icon = { Icon(icon, contentDescription = item) },
                label = { Text(item) },
                selected = selectedItem == index,
                onClick = { onItemSelected(index) }
            )
        }
    }
}

@Composable
fun LoginScreen(onLoginSuccess: () -> Unit, onNavigateToSignup: () -> Unit) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var emailError by remember { mutableStateOf<String?>(null) }
    var passwordError by remember { mutableStateOf<String?>(null) }

    fun validateEmail(email: String): Boolean {
        return Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }

    fun validatePassword(password: String): Boolean {
        return password.length >= 6
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
        modifier = Modifier
            .fillMaxSize()
            .padding(12.dp)
    ) {
        Text(text = "Login", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = email,
            onValueChange = {
                email = it
                emailError = if (validateEmail(it)) null else "Invalid email format"
            },
            label = { Text("Email") },
            isError = emailError != null,
            modifier = Modifier.fillMaxWidth()
        )
        if (emailError != null) {
            Text(emailError!!, color = MaterialTheme.colorScheme.error)
        }

        Spacer(modifier = Modifier.height(4.dp))

        OutlinedTextField(
            value = password,
            onValueChange = {
                password = it
                passwordError = if (validatePassword(it)) null else "Password must be at least 6 characters"
            },
            label = { Text("Password") },
            visualTransformation = PasswordVisualTransformation(),
            isError = passwordError != null,
            modifier = Modifier.fillMaxWidth()
        )
        if (passwordError != null) {
            Text(passwordError!!, color = MaterialTheme.colorScheme.error)
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = { if (validateEmail(email) && validatePassword(password)) onLoginSuccess() },
            modifier = Modifier.fillMaxWidth(),
            enabled = emailError == null && passwordError == null
        ) {
            Text("Login")
        }

        Spacer(modifier = Modifier.height(8.dp))

        TextButton(onClick = onNavigateToSignup) {
            Text("Don't have an account? Sign up")
        }
    }
}

@Composable
fun SignupScreen(onSignupSuccess: () -> Unit, onNavigateToLogin: () -> Unit) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var emailError by remember { mutableStateOf<String?>(null) }
    var passwordError by remember { mutableStateOf<String?>(null) }

    fun validateEmail(email: String): Boolean {
        return Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }

    fun validatePassword(password: String): Boolean {
        return password.length >= 6
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(text = "Sign Up", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = email,
            onValueChange = {
                email = it
                emailError = if (validateEmail(it)) null else "Invalid email format"
            },
            label = { Text("Email") },
            isError = emailError != null,
            modifier = Modifier.fillMaxWidth()
        )
        if (emailError != null) {
            Text(emailError!!, color = MaterialTheme.colorScheme.error)
        }

        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = password,
            onValueChange = {
                password = it
                passwordError = if (validatePassword(it)) null else "Password must be at least 6 characters"
            },
            label = { Text("Password") },
            visualTransformation = PasswordVisualTransformation(),
            isError = passwordError != null,
            modifier = Modifier.fillMaxWidth()
        )
        if (passwordError != null) {
            Text(passwordError!!, color = MaterialTheme.colorScheme.error)
        }

        Spacer(modifier = Modifier.height(16.dp))

        Button(
            onClick = { if (validateEmail(email) && validatePassword(password)) onSignupSuccess() },
            modifier = Modifier.fillMaxWidth(),
            enabled = emailError == null && passwordError == null
        ) {
            Text("Sign Up")
        }

        Spacer(modifier = Modifier.height(8.dp))

        TextButton(onClick = onNavigateToLogin) {
            Text("Already have an account? Log in")
        }
    }
}

@Composable
fun HomeScreen(modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(text = "Welcome back, John Doe!", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))
        DailyStats()
        Spacer(modifier = Modifier.height(24.dp))
        GoalsSection()
    }
}

@Composable
fun DailyStats() {
    Row(
        horizontalArrangement = Arrangement.SpaceEvenly,
        modifier = Modifier.fillMaxWidth()
    ) {
        StatCard(label = "Steps", value = "7,500")
        StatCard(label = "Calories", value = "350 kcal")
        StatCard(label = "Heart Rate", value = "76 bpm")
    }
}

@Composable
fun StatCard(label: String, value: String) {
    Card(
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier
            .padding(8.dp)
            .size(100.dp),
    ) {
        Column(
            modifier = Modifier.padding(8.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text(text = value, fontWeight = FontWeight.Bold, fontSize = 16.sp)
            Text(text = label, fontSize = 12.sp, color = Color.Gray)
        }
    }
}

@Composable
fun GoalsSection() {
    Column {
        Text(
            text = "Your Goals",
            fontWeight = FontWeight.Bold,
            fontSize = 18.sp,
            modifier = Modifier.padding(vertical = 8.dp)
        )
        Row(
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            GoalCard(title = "Walk 10,000 steps", progress = 0.75f)
            GoalCard(title = "Burn 500 kcal", progress = 0.55f)
        }
    }
}

@Composable
fun GoalCard(title: String, progress: Float) {
    Card(
        shape = RoundedCornerShape(8.dp),
        modifier = Modifier
            .padding(8.dp)
    ) {
        Column(
            modifier = Modifier.padding(8.dp)
        ) {
            Text(title, fontSize = 14.sp)
            LinearProgressIndicator(progress = progress, modifier = Modifier.fillMaxWidth())
        }
    }
}

@Composable
fun ProfileScreen(modifier: Modifier = Modifier) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = "Your Profile", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))

        OutlinedTextField(
            value = "John Doe",
            onValueChange = {},
            label = { Text("Name") },
            readOnly = true,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(8.dp))

        OutlinedTextField(
            value = "john_doe@example.com",
            onValueChange = {},
            label = { Text("Email") },
            readOnly = true,
            modifier = Modifier.fillMaxWidth()
        )
        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = { /* Edit Profile Logic */ }, modifier = Modifier.fillMaxWidth()) {
            Text("Edit Profile")
        }
    }
}

@Composable
fun SuggestScreen(modifier: Modifier = Modifier) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.Center
    ) {
        Text(text = "Get personalized suggestions here!", style = MaterialTheme.typography.titleLarge)
        Spacer(modifier = Modifier.height(16.dp))

        Button(onClick = { /* Button Action Logic */ }) {
            Text("Get Suggestions")
        }
    }
}
