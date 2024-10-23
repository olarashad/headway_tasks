
# Install the Nginx web server
sudo apt install nginx 
# Start the Nginx service manually 
sudo nginx
# Check the running processes to confirm that Nginx is active.
ps aux | grep nginx


# Enable Nginx to start automatically on system boot.
sudo systemctl enable nginx
# Check if Nginx is enabled to start at boot.
sudo systemctl is-enabled nginx


# Open the nano text editor to create or edit a script that will start Nginx and log the start time.
sudo nano /usr/local/bin/start_nginx_with_log.sh
# Add the script content
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#!/bin/bash
echo "Nginx started at: $(date)" >> /var/log/nginx_start_time.log
sudo nginx  # Start Nginx
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Change the script file permissions to make it executable.
sudo chmod +x /usr/local/bin/start_nginx_with_log.sh
# Run the script to start Nginx and log the start time.
/usr/local/bin/start_nginx_with_log.sh
    # Display the content of the log file to verify that the Nginx start time was logged.
    cat /var/log/nginx_start_time.log
    # Test the Nginx configuration for any syntax errors.
    sudo nginx -t


# Use curl to send a request to the local Nginx server and get the response.
curl http://localhost
# Search the access log for entries that indicate successful HTTP requests (status code 200).
cat /var/log/nginx/access.log | grep " 200 "