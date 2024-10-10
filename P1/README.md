# Log Monitoring and Alert System P1 - Due 10/21 (Tentatively)

## Description

In this project, you will build a log monitoring and alert system using Bash, PostgreSQL, and Python. The system will monitor logs, store them in PostgreSQL, and trigger alerts when error thresholds are reached. This project aims to simulate real-world production support tasks.

## Goals

- Monitor log files for specific error levels (ERROR, FATAL).
- Insert log entries into a PostgreSQL database.
- Implement a Python-based alert system that tracks error thresholds.
- Automate log generation, monitoring, and alerting with cron jobs.

## Requirements

### Log Generation (Bash)

- You will start with the provided script (`generate_logs.sh`) to simulate application logs. This script generates log entries with varying log levels and messages.

#### Provided `generate_logs.sh` script:

```bash
#!/bin/bash

# Path to the log file where log entries will be written
LOGFILE="/var/log/app.log"

# Infinite loop to continuously generate logs
while true; do
    # Get the current timestamp in the format 'YYYY-MM-DD HH:MM:SS'
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Randomly select a log level from INFO, WARNING, ERROR, and FATAL
    LEVEL=$(shuf -n 1 -e INFO WARNING ERROR FATAL)

    # Generate a variety of realistic log messages based on log levels
    case $LEVEL in
        INFO)
            MESSAGE=$(shuf -n 1 -e \
            "User ID 12345 successfully logged in." \
            "User ID 98765 updated account details." \
            "Daily backup completed successfully." \
            "Scheduled job 'cleanup_temp_files' executed at $TIMESTAMP." \
            "System health check passed; all services running.")
            ;; ## Double semi-colon here indicates the end of a case statement in Bash
        WARNING)
            MESSAGE=$(shuf -n 1 -e \
            "Disk space usage at 85% on /dev/sda1." \
            "API response time for user ID 54321 exceeded 2 seconds." \
            "Memory usage is high: 78% of available memory used." \
            "Unusually high number of login attempts from IP 192.168.1.101." \
            "Database query took longer than expected (3.4 seconds).")
            ;;
        ERROR)
            MESSAGE=$(shuf -n 1 -e \
            "Database connection lost while processing transaction ID 98765." \
            "Failed to load configuration file: /etc/app/config.yml." \
            "User ID 67890 failed to authenticate. Invalid credentials." \
            "Unable to send email: SMTP server not responding." \
            "Payment gateway timeout for transaction ID 87654.")
            ;;
        FATAL)
            MESSAGE=$(shuf -n 1 -e \
            "Server crashed due to memory overflow at address 0x004FA1." \
            "Critical error: Kernel panic occurred. System halted." \
            "Application terminated unexpectedly: Out of memory." \
            "Disk failure detected on /dev/sdb. Immediate replacement required." \
            "Service 'app-backend' failed to start: Missing dependency.")
            ;;
    esac

    # Write the timestamp, log level, and message to the log file
    echo "$TIMESTAMP [$LEVEL] $MESSAGE" >> $LOGFILE
    
    # Wait for a random time between 1 and 5 seconds before generating the next log entry
    sleep $(shuf -i 1-5 -n 1)
done
```

### Log Monitoring and Insertion (Bash + PostgreSQL)

- Develop a Bash script (`log_monitor.sh`) that monitors the generated log file.
- Filter `ERROR` and `FATAL` entries and insert them into a PostgreSQL database.

### Database Setup (PostgreSQL)

- Set up PostgreSQL with a schema to store log data:
  - **log_entries**: Stores timestamps, error levels, and messages.

### Alert System (Python)

- Write a Python script (`alert_system.py`) to monitor the database and trigger alerts if error thresholds (5 errors, 1 fatal) are exceeded.

### Automation

- Schedule the scripts to run every minute using a cron job.

## Technologies

- **Bash** for scripting.
- **PostgreSQL** for database storage.
- **Python** for alerting.
- **Cron** (or equivalent) for task automation.
- **psql** for database queries.