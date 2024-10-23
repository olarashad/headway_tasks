
# Create a new group called 'devops'
sudo groupadd devops
# Create a new user called 'devops_user'
sudo adduser devops_user
# Add 'devops_user' to the 'devops' group
sudo usermod -aG devops devops_user


# Force 'devops_user' to change their password on the first login
sudo chage -d 0 devops_user


# Open the sudoers file to grant 'devops_user' sudo privileges
sudo visudo
    # In the visudo editor, add the following line to grant 'devops_user' sudo access:
    devops_user ALL=(ALL:ALL) ALL
# OR alternatively, add 'devops_user' to the 'sudo' group:
sudo usermod -aG sudo devops_user
    groups devops_user


# Create another user called 'intern_user'
sudo adduser intern_user
# Add 'intern_user' to the 'devops' group
sudo usermod -aG devops intern_user


# Verify the groups for 'devops_user' to check membership
groups devops_user

