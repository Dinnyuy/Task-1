#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: bash create_users.sh <name-of-text-file>"
  exit 1
fi

# Variables
USER_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Ensure log and password files exist
touch $LOG_FILE
mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Function to generate random passwords
generate_password() {
  tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

# Read the file and process each line
while IFS=';' read -r username groups; do
  # Remove leading/trailing whitespace from username and groups
  username=$(echo "$username" | xargs)
  groups=$(echo "$groups" | xargs)
  
  # Skip empty lines
  if [ -z "$username" ]; then
    continue
  fi

  # Create the user with a home directory and personal group
  if id "$username" &>/dev/null; then
    echo "User $username already exists." | tee -a $LOG_FILE
  else
    useradd -m -s /bin/bash "$username" 2>>$LOG_FILE
    if [ $? -eq 0 ]; then
      echo "User $username created with home directory and personal group." | tee -a $LOG_FILE
    else
      echo "Failed to create user $username." | tee -a $LOG_FILE
      continue
    fi
  fi

  # Add the user to additional groups
  if [ -n "$groups" ]; then
    IFS=',' read -ra ADDR <<< "$groups"
    for group in "${ADDR[@]}"; do
      if getent group "$group" &>/dev/null; then
        usermod -aG "$group" "$username" 2>>$LOG_FILE
        echo "Added $username to group $group." | tee -a $LOG_FILE
      else
        groupadd "$group" 2>>$LOG_FILE
        usermod -aG "$group" "$username" 2>>$LOG_FILE
        echo "Group $group created and $username added to it." | tee -a $LOG_FILE
      fi
    done
  fi

  # Set up home directory permissions
  if [ -d "/home/$username" ]; then
    chmod 700 /home/"$username"
    chown "$username":"$username" /home/"$username"
    echo "Set permissions for /home/$username." | tee -a $LOG_FILE
  else
    echo "Home directory for $username does not exist." | tee -a $LOG_FILE
  fi

  # Generate and store the user's password
  password=$(generate_password)
  echo "$username,$password" >> $PASSWORD_FILE
  echo "Generated password for $username." | tee -a $LOG_FILE
  echo "$username:$password" | chpasswd 2>>$LOG_FILE
done < "$USER_FILE"

echo "User creation and setup completed." | tee -a $LOG_FILE
