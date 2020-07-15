# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 245 and 164 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 296 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design
- The network is subdiveded into 4 different subnets, and routhing between them is handled by router-1 and router-2 via Linux kernel IP Forwarding and routing tables.
For simplicity the IPv4 adresses are chosen in the private adress range, and more specifically on the 172.16.0.0/12 range.
- The subnet beetwen router-1 and router-2 has a net address of 172.16.0.0/30 since only two devices are present on the subnet and no additional devices are expected. 
Both routers are connected to this subnet through the enp0s9 interface with static IPv4 adresses.
-On router-1 both 172.16.1.0/24 and 172.16.2.0/24 subnets are connected on enp0s8 interface taking advantage of IP aliasing. These two subnets are respectivily connected to host-a and host-b though the switch. Adding devicese to the host-a and host-b groups is done simply by connecting the new devices to the switch.
The switch is implemented using OpenVSwitch and operates as a simple L2 switch, switching the packets based on the MAC adress of the destination. It does not have in IPv4 address since it does not operate on L3.
- On router-2 the 172.16.4.0/23  subnet is connected on enp0s8 interface. This subnet rappresent the "hub" network and has 510 possible adresses.
host-c is connected to the 172.16.4.0/23 subnet via the enp0s8 interface. It also hosts the ngix-test web server inside of a docker container. Tha container is set up to forward port 80 and port 443 to host-c to allow acces to the web server from within the whole network.
- Routing inside the network is handled via static routing. To keep routing as generic, in addition the the direct link routes, routing are implemented to deliver packets with an IP of 172.16.0.0/23 to router-1 and packets with IP 172.16.4.0/23 to router-2. All packets from 172.16.1.0/24 to 172.16.2.0/24 and vice versa are routed through the gateway of router-1 and not directly via the switch allowing the switch to operate only on layer 2 level reducing the complexity of the switch even if that results in a small loss of performance.
- Every device on the network was tested in its ability to ping every other device on the network succefully. In addition to that acces to the webserver on port 80 and port 443 of host-c was also tested succefully.
