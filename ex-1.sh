
# Create a directory named 'devops_projects'
mkdir devops_projects 


# Create the directory structure inside 'devops_project'
mkdir -p devops_project/{scripts,bin/tools,logs}


# Create an empty file named 'deploy.sh' inside the 'scripts/' folder
touch devops_project/scripts/deploy.sh


# Add the line '#!/bin/bash' to the beginning of 'deploy.sh'
echo '#!/bin/bash' | sudo tee scripts/deploy.sh 


# This command adds the 'ls' command to recursively list the 'devops_project' directory
# and save the output to 'logs/tree.txt'
sudo bash -c 'cat <<EOF > scripts/deploy.sh
#!/bin/bash
ls -lR devops_project >> devops_project/logs/tree.txt
EOF' 

# Change the permissions of 'deploy.sh' so that only the owner can read, write, and execute it.
chmod 700 scripts/deploy.sh 


# Create a compressed tarball (tar.gz) of the 'devops_project/' directory.
tar -czvf devops_project.tar.gz devops_project