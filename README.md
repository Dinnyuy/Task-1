
# User Creation Bash Script

This project contains a Bash script called `create_users.sh` that automates the creation of Linux users and groups. The script reads a text file containing the usernames and group names, creates the users and their respective groups, sets up home directories with appropriate permissions, generates random passwords, and logs all actions.

## Requirements

- Each user must have a personal group with the same group name as the username.
- A user can have multiple groups, each group delimited by a comma `,`.
- Usernames and user groups are separated by a semicolon `;`.
- The script logs all actions to `/var/log/user_management.log`.
- The script stores the generated passwords securely in `/var/secure/user_passwords.csv`.

## Input File Format

The input file should contain usernames and groups in the following format:

username; group1,group2,group3


Example `users.txt` file:

light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data
john; sudo,dev
jane; www-data
mark; sudo,dev,www-data
Dinnyuy; sudo,dev
Alita; www-data,dev
Ande; sudo,dev
Lemnyuy; www-data
Fru; sudo,dev,www-data
Bame; sudo


## Usage

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
## Make the script executable:

chmod +x create_users.sh
Run the script with the input file:
sudo bash create_users.sh users.txt


## Files
create_users.sh: The main Bash script for creating users and groups.
users.txt: Sample input file containing usernames and groups.
README.md: This README file.
Script Details
The create_users.sh script performs the following actions:

Reads the input file line by line.
For each line, extracts the username and groups.
Creates a user with a home directory and a personal group.
Adds the user to the specified groups.
Sets permissions for the user's home directory.
Generates a random password for the user and updates it.
Logs all actions to /var/log/user_management.log.
Stores the generated passwords securely in /var/secure/user_passwords.csv.
Error Handling
The script checks if the input file is provided.
The script handles existing users and groups gracefully.
The script skips empty lines in the input file.
The script ensures the necessary directories and files exist and have the correct permissions.
Example Output
Example log entries in /var/log/user_management.log:

User light created with home directory and personal group.
Added light to group sudo.
Group dev created and light added to it.
Added light to group www-data.
Set permissions for /home/light.
Generated password for light.
...
Example entries in /var/secure/user_passwords.csv:


light,RanDomP@ssw0rd
idimma,RanDomP@ssw0rd
mayowa,RanDomP@ssw0rd
...

## Links
For more information on the HNG Internship program, visit the following links:
https://hng.tech/internship
https://hng.tech/hire

