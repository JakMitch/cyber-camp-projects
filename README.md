# Automated Elk Stack Deployment 
### The files in this repository were used to configure the network depicted below.
![Cloud Network Diagram with ELK](https://github.com/JakMitch/cyber-camp-projects/blob/main/Diagrams/Cloud%20Network%20Diagram%20with%20ELK.PNG)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.
#### Playbook 1: pentest.yml
```
---
  - name: Config Web VM with Docker
    hosts: webservers
    become: true
    tasks:
   
   - name: docker.io
     apt:
	   update_cache: yes 
	   name: docker.io
	   state: present	  
   
   - name: Install pip3
     apt:
	   name: python3-pip
	   state: present
	   
   - name: Install Python Docker Module
     pip:
	   name: docker
	   state: present
	   
   - name: download and launch a docker web container
     docker_container: 
	   name: dvwa
	   image: cyberxsevurity/dvwa
	   state: started
	   restart_policy: always
	   published_ports: 80:80
	   
   - name: enable docker service
     systemd:
	   name: docker
	   enabled: yes
```
#### Playbook 2: install-elk.yml
```
---
  - name: Config Calf1 elk VM
    hosts: elk 
	become: true
	tasks: 
	
	# Use command module
	- name: Increase virtual memory
	  command: sysctl -w vm.max_map_count=262144
	
	# Use sysctl module
	- name: Use more memory
	  sysctl:
	    name: vm.max_map_count
		value: '262144'
		state: present
		reload: yes
		
	# Use apt module 
	- name: Install docker.io
	  apt: 
	    update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present 

    # Use apt module
	- name: Install pip3
	  apt: 
	    force_apt_get: yes
		name: python3-pip
		state: present 
		
	# Use pip module
	- name: Install Docker module 
	  pip: 
	    name: docker  
		state: present 
		
	# Use docker_container module 
	- name: Download and launch elk container
	  docker_container: 
	    name: elk
		image: sebp/elk:761
		state: started
		restart_policy: always 
		published_ports:
		  - '5601:5601'
		  - '9200:9200'
		  - '5044:5044'
		  
	- name: enable docker service 
	  systemd:
	    name: docker
		enabled: yes
```
#### Playbook 3: filebeat-playbook.yml
```      
---

- name: Installing and Launching filebeat
  hosts: webservers
  become: true
  tasks:
  
  # Use command module
  - name: download filebeat .deb filebeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb
  
  # Use command module
  - name: install filebeat .deb 
    command: dpkg -i filebeat-7.4.0-amd64.deb

  # Use copy module 
  - name: drop in filebeat.yml
    copy: 
      src: /etc/ansible/files/filebeat-config.yml 
      dest: /etc/filebeat/filebeat.yml 
  
  # Use command module
  - name: enable and configure system module 
    command: filebeat modules enable system 

  # Use command module
  - name: setup filebeat 
    command: filebeat setup 
  
  # Use command module
  - name: start filebeat service
    command: service filebeat start 

  # Use systemd module 
  - name: Enable service filebeat on boot
    systemd:
      name: filebeat  
      enabled: yes	  
```
### This document contains the following details:
* Description of the Topology
* Access Policies
* ELK Configuration
* Beats in Use
* Machines Being Monitored
* How to Use the Ansible Build

### Description of Topology
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
Load balancers protect application availability, allowing client requests to be shared across a number of servers. They support encryption through TLS and prevent messages from being modified while the packet is transported to the server. Using a jump-box enables management of devices across separate security zones. A jumpbox shrinks the attack surface by only allowing remote access into the network from a single, monitored VM. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files. 
* Filebeat is used to forward and centralize log files
* Metricbeat records and ships statistics from various services being run on a VM

The configuration details of each machine may be found below.
|Name|Function|IP Adress| Operating system|
|:----:|:--------:|:---------:|:-----------------:|
|Jump-Box-Provisioner|Gateway|10.0.0.4|Linux|
|Web-1|DVWA|10.0.0.5|Linux|
|Web-2|DVWA|10.0.0.6|Linux|
|Calf1|ELK|10.1.0.4|Linux|

### Access Policies
The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 208.104.196.208

Machines within the network can only be accessed by SSH.
- The Jump-Box-Provisioner can access the ELK VM Claf1 using SSH. Jump-Box-Provisioner's IP address is 10.0.0.4(Private) 23.99.66.217(Public)

A summary of the access policies in place can be found in the table 

| Name     | Publicly Accessible | Allowed IP Addresses |
|:--------:|:-------------------:|:--------------------:|
| Jump-Box-Provisioner | Yes(SSH)|208.104.196.208       |
|Web-1     | Yes(HTTP)  |208.104.196.208               |
|Web-2     | Yes(HTTP)|208.104.196.208|
|Calf1| Yes(HTTP)|208.104.196.208|

### Elk Configuration
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because:
- Automation with Ansible allows configuration tasks to be executed on different servers at the same time. Multiple Apps can be installed simultaneously; use of Continuous Integration and Infrastructure as Code

The playbook implements the following tasks:
- Increases virtual memory in order to support the ELK stack
- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Enables the Docker service
- Downloads and launches the Docker ELK container

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance:
![docker_ps_output](https://github.com/JakMitch/cyber-camp-projects/blob/main/Diagrams/docker_ps_output.PNG)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 
	* Private: 10.0.0.5
	* Public: 40.83.149.115
- Web-2: 
	* Private: 10.0.0.6
	* Public: 40.83.149.115 

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat collects logs and sends them to ELK for data processing and enhancement 
- Metricbeat is used to collect metrics from the system and services in order to monitor servers 

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the playbook file to the Ansible Docker Container.
- Update the `/etc/ansible/hosts` file to include:
```
[webservers]
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.6 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Run the playbook, and navigate to Kibana to check that the installation worked as expected.

### Instructions to Run the Playbook

1. Update the Ansible configuration file `/etc/ansible/ansible.cfg` and set the remote_user parameter to the admin user of the web servers.
2. Start an ssh session with the Jump-Box: `$ssh RedAdmin@<Public IP Adress of Jump-Box>`
3. List the Docker container: `$sudo docker container ls -a`
4. Start the Ansible Docker container: `$sudo docker start <Name of Ansible container>`
5. Attach to the Ansible Docker container: `$sudo docker attach <Name of Ansible container>`
6. Run the playbooks:
	* `ansible-playbook /etc/ansible/pentest.yml`
	* `ansible-playbook /etc/ansible/install-elk.yml`
	* `ansible-playbook /etc/ansible/roles/filebeat-playbook.yml`

Once the playbooks are successfully run, navigate to Kibana(http://'elk-server-ip':5601/app/kibana)to ensure Filebeat and Metricbeat are showing data within the Kibana Dashboard.
