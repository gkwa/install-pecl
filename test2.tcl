package require Expect

spawn php -d detect_unicode=0 go-pear.phar
# expect "Are you installing a system-wide PEAR or a local copy?"
# expect "(system|local)"

expect "local"
send "system"
send "\r"

expect "Enter to continue:"
send "all"
send "\r"

expect "Installation base"
expect ":"
send "c:\tools\pecl"
send "\r"

expect "Temporary directory for processing"
expect ":"
send "c:\tools\pecl\tmp"
send "\r"

expect "Temporary directory for downloads"
expect ":"
send "c:\tools\pecl\tmp"
send "\r"

expect "Binaries directory"
expect ":"
send "c:\tools\pecl"
send "\r"

expect "PHP code directory"
expect ":"
send "$prefix\pear"
send "\r"

expect "Documentation directory"
expect ":"
send "$prefix\docs"
send "\r"

expect "Data directory"
expect ":"
send "$prefix\data"
send "\r"

expect "User-modifiable configuration files directory"
expect ":"
send "$prefix\cfg"
send "\r"

expect "Public Web Files directory"
expect ":"
send "$prefix\www"
send "\r"

expect "System manauage pages directory"
expect ":"
send "$prefix\man"
send "\r"

expect "Tests directory"
expect ":"
send "$prefix\tests"
send "\r"

expect "Name of configuration file"
expect ":"
send "c:\windows\pear.ini"
send "\r"

expect "Path to CLI php.exe"
expect ":"
send "c:\tools\php"
send "\r"
