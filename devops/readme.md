
- This readme lists down steps for setting up the node from where we would run terraform & ansible commands


# Step-1 : Install terraform & ansible
install ansible & terraform (steps in sh files in this dir)

# Step-2 : Install aws-cli
- install `aws-cli`

```
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

# verify installation
aws --version



# Step-3 : Do aws configure

- do `aws configure`
- get secret key & access id from `secure_credential` section (create new if needed)

```
AWS Access Key ID [None]: ??
AWS Secret Access Key [None]: ??
Default region name [None]: ap-south-1
Default output format [None]: json
```


# Step-4 : Use Terraform to spawn instances
- create a new dir called `terraform` & a file in this dir `main.tf`
- `cd` into this dir
- run `terraform init`
- run `terraform plan` to see which all resource will be created/updated
- run `terraform apply -auto-approve` to update the cloud resources (without entering `yes` to confirm)
- run `terraform destroy -auto-approve` to destroy the created the cloud resources (without entering `yes` to confirm)



# Step-5 : Use Ansible to install dependencies on instances
- create a new dir called `terraform` & a file in this dir `main.tf`
- `cd` into this dir
- create playbook called `setup.yml`
- create inventory file called `inventory.yml`
- run playbook : `ansible-playbook -i inventory.yml playbook.yml`


# [updates needed after spawning aws instanaces using terraform]
- update private IP of all machines in `devops/ansible/playbooks/inventory.yml`
- update STATSD_HOST to private IP of monitoring node in `devops/static/env_file.env`
- update private IPs of al nodes in `devops/static/new_etc_hosts.txt`



[to-do]
- host-name consistency [app & scripts & tf & ansibble & etc]
- ec2 to spin in a subnet without private IP



###### ###### ###### ###### ###### ###### ###### ######
###### ###### ###### [Challenges] ###### ###### ######
###### ###### ###### ###### ###### ###### ###### ######
[C1]
- spikey & irregular metrics for JVM thread-count & system load avg
[Resolution]
- use gauge instead of counter metrics


[C2]
- Getting error : `Exception: java.lang.OutOfMemoryError thrown from the UncaughtExceptionHandler in thread "clojure-agent-send-off-pool-9"`
[Resolution]
- need to check ??