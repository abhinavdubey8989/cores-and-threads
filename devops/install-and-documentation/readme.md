
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
