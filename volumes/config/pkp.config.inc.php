; In volumes/config/pkp.config.inc.php

[general]

; The base URL of the main site. This will be picked up by the script.
base_url = "http://unijournal.org"

; Ensure restful_urls is On for clean URLs
restful_urls = On

; --- Base URL overrides for specific journals ---
; The script will also pick up all of these.
base_url[hbgr] = "http://submissions.hgbr.org"
base_url[gbej] = "http://submissions.gbej.org"


;;;;;;;;;;;;;;;;;;;;
; Database Settings ;
;;;;;;;;;;;;;;;;;;;;

[database]
driver = "mysqli"
host = "env:DB_HOST"
username = "env:MYSQL_USER"
password = "env:MYSQL_PASSWORD"
name = "env:MYSQL_DATABASE"


;;;;;;;;;;;;;;;;;;
; Email Settings ;
;;;;;;;;;;;;;;;;;;

[email]

; The driver to use for sending mail. For development, "log" is recommended.
; Valid options: "smtp", "sendmail", "log", "test"
default = "log"


;;;;;;;;;;;;;;;;
; Cache Cache ;
;;;;;;;;;;;;;;;;

[cache]

; The type of object cache to use.
; For development, "none" is a safe choice.
object_cache = "none"

; The web cache to use.
web_cache = "none"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Internationalization    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[i18n]

; Default locale
locale = "en_US"

; Client output/input character set
client_charset = "utf-8"