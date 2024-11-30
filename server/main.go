package main

import (
	"database/sql"
	"fmt"
	"net/http"
	"os"
)

func main() {
	mux := http.DefaultServeMux
	mux.HandleFunc("/login", loginEndpoint)               // Login endpoint (POST)
	mux.HandleFunc("/register", registerEndpoint)         // Register endpoint (POST)
	mux.HandleFunc("/users", usersEndpoint)               // Get all users except the current user (GET)
	mux.HandleFunc("/user", userEndpoint)                 // Get the user by id if provided in the query or the current user (GET)
	mux.HandleFunc("/conversation", conversationEndpoint) // Get conversation between current user and another user (GET)
	mux.HandleFunc("/allmessages", allMessagesEndpoint)   // Get all messages of a user (GET)
	mux.HandleFunc("/ws", wsEndpoint)                     // Websocket endpoint

	// Serve static HTML files at /prototype
	mux.Handle("/prototype/", http.StripPrefix("/prototype/", http.FileServer(http.Dir("./prototype"))))

	server := http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	fmt.Println("Listening and serving on port :8080")
	server.ListenAndServe()
}

func init() {
	os.Remove("./database.db")
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		panic(err)
	}

	defer db.Close()

	sqlStmt := `
	CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		email TEXT,
		password TEXT,
		name TEXT
	);

	INSERT INTO users (email, password, name) VALUES ("admin@gmail.com", "$2a$10$4xlitCzDl444z16xQVBaEupzQY0/wv6sqEeN6mkYqfdnS5DBnqbaq", "admin");
	INSERT INTO users (email, password, name) VALUES ("kaptenwahyu@gmail.com", "$2a$10$KWFFkJd9XiFXFfYBPhr8D.dUTRcgVRQX/JjSub2lA1itmz5hBv0EO", "wahyu");
	INSERT INTO users (email, password, name) VALUES ("aiken@gmail.com", "$2a$10$3LnGFUOy6i4ehr9NuDI9r.GdVf3pM7gcRbfqI/K9aZjc7GrHq7KSi", "aiken");

	CREATE TABLE IF NOT EXISTS messages (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		sender_id INTEGER,
		receiver_id INTEGER,
		content TEXT,
		timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (sender_id) REFERENCES users(id),
		FOREIGN KEY (receiver_id) REFERENCES users(id)
	);

	INSERT INTO messages (sender_id, receiver_id, content) VALUES (2, 3, "Hi Aiken, Wahyu here. How's it going?");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (3, 2, "Hey Wahyu, Aiken here. All good, you?");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (2, 3, "Aiken, Wahyu here. Can you send me the report?");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (3, 2, "Sure Wahyu, sending it now.");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (2, 3, "Wahyu here. Did you receive the report?");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (3, 2, "Yes Wahyu, I received it. Thanks!");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (2, 3, "Great Aiken. Let's discuss it tomorrow.");
	INSERT INTO messages (sender_id, receiver_id, content) VALUES (3, 2, "Sure Wahyu, see you tomorrow.");
	`

	_, err = db.Exec(sqlStmt)
	if err != nil {
		panic(err)
	}
}
