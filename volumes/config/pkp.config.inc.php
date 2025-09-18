// In volumes/config/pkp.config.inc.php

[general]

; The base URL of the main site. This will be picked up by the script.
base_url = "http://unijournal.org"

; Ensure restful_urls is On for clean URLs
restful_urls = On


;;;;;;;;;;;;;;;;;;;;
; Database Settings ;
;;;;;;;;;;;;;;;;;;;;

[database]
driver = "env:DB_DRIVER"
host = "env:DB_HOST"
username = "env:MYSQL_USER"
password = "env:MYSQL_PASSWORD"
name = "env:MYSQL_DATABASE"

...

; --- Base URL overrides for specific journals ---
; The script will also pick up all of these.
base_url[hbgr] = "http://submissions.hgbr.org"
base_url[gbej] = "http://submissions.gbej.org"