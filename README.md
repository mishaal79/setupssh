# Overview

Bash script to distribute ssh keys to servers and setup key-based authentication.
A list of servers can be provided through a file.
Script outputs statuses of succsessfull key distributions and failures.

## How to use

Arguments to pass:
1. file to load list of hosts from
2. server account user name
3. ssh password for services

> `bash dist.sh servers_example.txt test_user test_password`
Note: User password is stored in plaintext for the duration of script.