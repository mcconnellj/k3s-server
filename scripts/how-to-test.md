Configure the Unit File: Inside the unit file, specify the following:

    [Unit] section: Define the description and dependencies of your script.
    [Service] section: Specify the command to run, the user to run it as, and any environment variables.
    [Install] section: (Optional) Specify when the service should be started (e.g., on boot).

Enable the Service (Optional):
If you want the script to run on boot, enable the service using sudo systemctl enable <your_script_name>.service. 
Start the Service Manually:
To test the script, start the service manually using sudo systemctl start <your_script_name>.service. 
Check the Logs:
After starting the service, check the logs to see if the script ran successfully and if there were any errors. 

    Use sudo journalctl -u <your_script_name>.service to view the logs. 

Stop the Service:
You can stop the service using sudo systemctl stop <your_script_name>.service. 
Restart the Service:
You can restart the service using sudo systemctl restart <your_script_name>.service. 

3. Additional Tips

    Debugging: If your script fails, use the logs to identify the problem.
    Permissions: Ensure that the user running the script has the necessary permissions to execute it and access the required resources.
    Dependencies: Make sure that any dependencies of your script are installed and available. 


Make the script executable:

sudo chmod +x /usr/local/bin/k3s-setup.sh

Create a systemd Unit File

Create a new systemd service file at:

sudo nano /etc/systemd/system/k3s-setup.service

Paste the following configuration:

[Unit]
Description=K3s and k9s Setup Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/k3s-setup.sh
Restart=on-failure
User=root
Environment="HOME=/root"

[Install]
WantedBy=multi-user.target

3️⃣ Enable and Start the Service
Enable the service to run on boot:

sudo systemctl enable k3s-setup.service

Start the service manually (for testing):

sudo systemctl start k3s-setup.service

Check the service status:

sudo systemctl status k3s-setup.service

Check the logs:

sudo journalctl -u k3s-setup.service -f

4️⃣ Manage the Service

    Stop the service:

sudo systemctl stop k3s-setup.service

Restart the service:

sudo systemctl restart k3s-setup.service

Disable it from running on boot (if needed):

sudo systemctl disable k3s-setup.service
