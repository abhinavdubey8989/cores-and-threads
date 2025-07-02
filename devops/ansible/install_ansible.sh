
# Link : https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu


# 1
sudo apt update

#2
sudo apt install software-properties-common

# 3
sudo add-apt-repository --yes --update ppa:ansible/ansible

# 4
sudo apt install ansible

# 5 verify
ansible --version