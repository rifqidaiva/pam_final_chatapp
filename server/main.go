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
	mux.HandleFunc("/preferences", preferencesEndpoint)   // Get preferences of the current user (GET), Update preferences of the current user (PUT)
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

	CREATE TABLE IF NOT EXISTS preferences (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		user_id INTEGER,
		mode TEXT,
		theme TEXT,
		time_zone TEXT,
		currency TEXT,
		is_premium BOOLEAN,
		FOREIGN KEY (user_id) REFERENCES users(id)
	);

	CREATE TABLE IF NOT EXISTS messages (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		sender_id INTEGER,
		receiver_id INTEGER,
		content TEXT,
		timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
		FOREIGN KEY (sender_id) REFERENCES users(id),
		FOREIGN KEY (receiver_id) REFERENCES users(id)
	);

	INSERT INTO users (email, password, name) VALUES ("admin@gmail.com", "$2a$10$Sffp4bQMpMVx9vTnvw6ONOBEbYwEfZTq7Z.gphfBi8kiXuBOGS7Uy", "Admin");
	INSERT INTO users (email, password, name) VALUES ("aiken@gmail.com", "$2a$10$Q0FrZosG.ekVpyGz41C4g.nf6ks5G6hDWItTmLhMyRhLwq/1l2rI6", "Aiken");
	INSERT INTO users (email, password, name) VALUES ("wahyu@gmail.com", "$2a$10$mLykOmNSkp02xP8t4zQfzeQh65.6.BHLhp2VaB3KfyfAVpVO9W.hG", "Wahyu");

	INSERT INTO preferences (user_id, mode, theme, time_zone, currency, is_premium) VALUES (1, "light", "blue", "wib", "idr", 1);
	INSERT INTO preferences (user_id, mode, theme, time_zone, currency, is_premium) VALUES (2, "light", "blue", "wib", "idr", 0);
	INSERT INTO preferences (user_id, mode, theme, time_zone, currency, is_premium) VALUES (3, "light", "blue", "wib", "idr", 0);

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
