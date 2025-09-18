// In volumes/config/pkp.config.inc.php

[general]

; The base URL of the main site. This will be picked up by the script.
base_url = "https://unijournal.org"

; Ensure restful_urls is On for clean URLs
restful_urls = On


;;;;;;;;;;;;;;;;;;;;
; Database Settings ;
;;;;;;;;;;;;;;;;;;;;

[database]
driver = mysqli
host = "db"
username = "pkp"
password = "changeMePlease" ; IMPORTANT: Use the value from your .env file's MYSQL_PASSWORD
name = "pkp"

...

; --- Base URL overrides for specific journals ---
; The script will also pick up all of these.
base_url[hbgr] = "https://submissions.hgbr.org"
base_url[gbej] = "https://submissions.gbej.org"
