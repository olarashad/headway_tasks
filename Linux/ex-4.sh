
# Display all network interfaces and their associated IP addresses
ip a


# Open the resolv.conf file in nano editor to modify DNS settings.
sudo nano /etc/resolv.conf
# Add the line below to use Cloudflare's DNS server (1.1.1.1)
nameserver 1.1.1.1


# Ping Google's server (www.google.com) to check if the machine has network connectivity.
ping www.google.com
# Trace the route packets take to reach Google's server. This shows each hop the packet goes through.
traceroute www.google.com


# Create a firewall rule to allow inbound HTTP traffic on port 80 (used for websites).
New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
# Create a firewall rule to allow inbound HTTPS traffic on port 443 (used for secure websites).
New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow
# Create a firewall rule to allow inbound SSH traffic on port 22 (used for remote connections).
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
# Retrieve and display all firewall rules where the display name contains "Allow".
Get-NetFirewallRule | Where-Object { $_.DisplayName -match "Allow" }
