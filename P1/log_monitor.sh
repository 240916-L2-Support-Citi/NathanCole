#!/bin/bash

LOG_FILE="/var/log/app.log"
DB_NAME="p1"
DB_USER="nate"

get_latest_timestamp() {
    latest_timestamp=$(psql -U "$DB_USER" -d "$DB_NAME" -t -c \
    "SELECT MAX(timestamp) FROM log_entries;")
    echo "$latest_timestamp"
}

insert_log_entry() {
    local timestamp="$1"
    local error_level="$2"
    local message="$3"

    # Escape all single quotes in the message for SQL syntax
    message=$(echo "$message" | sed "s/'/''/g")

    psql -U "$DB_USER" -d "$DB_NAME" -c \
    "INSERT INTO log_entries (timestamp, error_level, message) VALUES ('$timestamp', '$error_level', '$message');"
}

latest_timestamp=$(get_latest_timestamp)

while read -r line; do
    if echo "$line" | grep -E "ERROR|FATAL" > /dev/null; then
        timestamp=$(echo "$line" | cut -d' ' -f1-2)
        
        if [[ "$timestamp" > "$latest_timestamp" ]]; then
            error_level=$(echo "$line" | grep -oE "ERROR|FATAL")
            message=$(echo "$line" | cut -d' ' -f4-)

            insert_log_entry "$timestamp" "$error_level" "$message"
        fi
    fi
done < "$LOG_FILE"
