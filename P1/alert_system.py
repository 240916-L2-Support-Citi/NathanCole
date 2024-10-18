import psycopg
import time

FATAL_THRESHOLD = 1
ERROR_THRESHOLD = 5

try: 
    with psycopg.connect(
        "dbname=p1 user=nate password=nate host=/var/run/postgresql port=5432"
    ) as conn:
        last_fatal_count = 0
        last_error_count = 0
        
        while True:
            with conn.cursor() as cur:
                cur.execute("SELECT COUNT(*) FROM log_entries WHERE error_level = 'FATAL'")
                fatal_count = cur.fetchone()[0]
                
                cur.execute("SELECT COUNT(*) FROM log_entries WHERE error_level = 'ERROR'")
                error_count = cur.fetchone()[0]

                if fatal_count > last_fatal_count:
                    if fatal_count > FATAL_THRESHOLD:
                        print(f"ALERT: The number of FATAL logs ({fatal_count}) has exceeded threshold ({FATAL_THRESHOLD})")
                    last_fatal_count = fatal_count

                if error_count > last_error_count:
                    if error_count > ERROR_THRESHOLD:
                        print(f"ALERT: The number of ERROR logs ({error_count}) has exceeded threshold ({ERROR_THRESHOLD})")
                    last_error_count = error_count

            time.sleep(5)
except Exception as e:
    print("Error connecting to DB: ", e)
