- ### Use Packer to create an AMI with all prerequisites
- ### Use Ansible to run Jenkins server on EC2 from generated AMI
---
**Create a suitable AMI based on Amazon Linux2**
```
packer build jenkins.pkr.hcl
```
**Create an EC2 instance from the generated AMI**
```
Use the AWS Management Console to create an EC2 instance
```
---
**OPTIONAL: Generate the required AWS key pair if you wish to connect to the host via SSH**
```
Create a new AWS key pair while installing EC2 instance
```
```
Give this key a name "sec_key"
```
```
Check 'RSA' and '.pem' type options
```
**For testing purposes only, create an SG and allow traffic from anywhere!**
```
Allow incoming traffic from port 22 and 8080
```
```
Allow outgoing traffic from all TCP ports
```
```
chmod 0600 sec_key.pem
```
```
Copy this key to ~/.ssh/ of your master host
```
**Edit inventory file**
```
Copy public IP4 address from running EC2 instance
```
```
Put the public IP4 address in the "inventory.txt" file instead of EC2-IP4-ADDRESS
```
---
**Running Ansible playbook with Jenkins precondition**
```
ansible-playbook jenkins.yaml -i inventory.txt
```
**Get Jenkins URL and temporary password**
```
Copy all the necessary information from the Ansible debug output
```
**Run Jenkins in a browser**
```
The Ansible debug message has all the information you need
```
**Finish Jenkins setup**
```
Select "Install suggested plugins", then click Continue
```
```
Create your user, click Save and Continue, then Save and Finish. Done!
```
