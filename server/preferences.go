package main

import (
	"database/sql"
	"encoding/json"
	"net/http"
)

type Preferences struct {
	Mode      string `json:"mode"`
	Theme     string `json:"theme"`
	TimeZone  string `json:"time_zone"`
	IsPremium bool   `json:"is_premium"`
}

// MARK: /preferences
// preferencesEndpoint is a handler function to get the preferences of the current user
func preferencesEndpoint(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, PUT")

	user, err := getHttpUser(r)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		w.Write([]byte(`{"message": "` + err.Error() + `"}`))
		return
	}

	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message": "` + err.Error() + `"}`))
		return
	}

	defer db.Close()

	if r.Method == "GET" {
		var prefs Preferences
		err = db.QueryRow("SELECT mode, theme, time_zone, is_premium FROM preferences WHERE user_id = ?", user.Id).
			Scan(&prefs.Mode, &prefs.Theme, &prefs.TimeZone, &prefs.IsPremium)
		if err != nil {
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message": "preferences not found"}`))
			return
		}

		w.WriteHeader(http.StatusOK)
		json.NewEncoder(w).Encode(prefs)
	} else if r.Method == "PUT" {
		var prefs Preferences

		err := json.NewDecoder(r.Body).Decode(&prefs)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte(`{"message": "invalid request body"}`))
			return
		}

		_, err = db.Exec("UPDATE preferences SET mode = ?, theme = ?, time_zone = ?, is_premium = ? WHERE user_id = ?",
			prefs.Mode, prefs.Theme, prefs.TimeZone, prefs.IsPremium, user.Id)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(`{"message": "` + err.Error() + `"}`))
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"message": "preferences updated successfully"}`))
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
		w.Write([]byte(`{"message": "only GET and PUT methods allowed"}`))
	}
}
