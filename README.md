# AWS-Scripts
This branch includes all the AWS related bash script that can be used in day to day activity.

# What is the AWS Command Line Interface?
The AWS Command Line Interface (AWS CLI) is an open source tool that enables you to interact with AWS services using commands in your command-line shell. With minimal configuration, the AWS CLI enables you to start running commands that implement functionality equivalent to that provided by the browser-based AWS Management Console from the command prompt in your terminal program:

- `Linux shells` – Use common shell programs such as bash, zsh, and tcsh to run commands in Linux or macOS.

- `Windows command line` – On Windows, run commands at the Windows command prompt or in PowerShell.

- `Remotely` – Run commands on Amazon Elastic Compute Cloud (Amazon EC2) instances through a remote terminal program such as PuTTY or SSH, or with AWS Systems Manager.

All IaaS (infrastructure as a service) AWS administration, management, and access functions in the AWS Management Console are available in the AWS API and AWS CLI. New AWS IaaS features and services provide full AWS Management Console functionality through the API and CLI at launch or within 180 days of launch.


## Prerequisites

We need to install AWS-CLI on our machine to perform AWS actions. Click [Install, update, and uninstall the AWS CLI](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-install.html)
Set your IAM permissions to allow for Amazon EC2 access. For more information about IAM permissions for Amazon EC2, see [IAM policies for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-policies-for-amazon-ec2.html) in the Amazon EC2 User Guide.

## Create, display, and delete Amazon EC2 key pairs in the AWS CLI.
You can use the AWS Command Line Interface (AWS CLI) to create, display, and delete your key pairs for Amazon Elastic Compute Cloud (Amazon EC2). You use key pairs to connect to an Amazon EC2 instance.

You must provide the key pair to Amazon EC2 when you create the instance, and then use that key pair to authenticate when you connect to the instance.

### Create a key pair

To create a key pair, use the aws ec2 [create-key-pair](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html) command with the --query option, and the --output text option to pipe your private key directly into a file.

Command to create a key pair in Ubuntu:
```
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
```
Command to create a key pair in Windows:
For PowerShell, the > file redirection defaults to UTF-8 encoding, which cannot be used with some SSH clients. So, you must convert the output by piping it to the out-file command and explicitly set the encoding to ascii.
```
PS C:\> aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath MyKeyPair.pem
```
### Create a VPC
Create a VPC with the specified CIDR blocks. For more information, see IP addressing for your VPCs and subnets in the Amazon VPC User Guide .

You can optionally request an IPv6 CIDR block for the VPC. You can request an Amazon-provided IPv6 CIDR block from Amazon's pool of IPv6 addresses or an IPv6 CIDR block from an IPv6 address pool that you provisioned through bring your own IP addresses.

Example 1: To create a VPC

The following create-vpc example creates a VPC with the specified IPv4 CIDR block and a Name tag.
```
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications ResourceType=vpc,Tags=[{Key=Name,Value=MyVpc}]
```
Example 2: To create a VPC with dedicated tenancy

```
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --instance-tenancy dedicated

```
Example 3: To create a VPC with an IPv6 CIDR block

The following create-vpc example creates a VPC with an Amazon-provided IPv6 CIDR block.
```
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --amazon-provided-ipv6-cidr-block
```




### Create a subnet
```
aws ec2 create-subnet \
    --vpc-id vpc-081ec835f3EXAMPLE \
    --cidr-block 10.0.0.0/24 \
    --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=my-ipv4-only-subnet}]
```

## Create, configure, and delete security groups for Amazon EC2
You can create a security group for your Amazon Elastic Compute Cloud (Amazon EC2) instances that essentially operates as a firewall, with rules that determine what network traffic can enter and leave.

Use the AWS Command Line Interface (AWS CLI) to create a security group, add rules to existing security groups, and delete security groups.

### Create a security group
```
aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id vpc-1a2b3c4d
```
To view the initial information for a security group, run the aws ec2 describe-security-groups command. You can reference an EC2-VPC security group only by its vpc-id, not its name.

```
aws ec2 describe-security-groups --group-ids sg-903004f8
```

### Add rules to your security group

To start, find your system's IP address.
```
curl https://checkip.amazonaws.com
```

You can then add the IP address to your security group by running the aws ec2 authorize-security-group-ingress command.

```
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 3389 --cidr x.x.x.x/x
```
The following command adds another rule to enable SSH to instances in the same security group.
```
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 22 --cidr x.x.x.x/x
```


### Describe your Security group

To view the changes to the security group, run the aws ec2 describe-security-groups command.

```
aws ec2 describe-security-groups --group-ids sg-903004f8
```

### Delete your security group
```
aws ec2 delete-security-group --group-id sg-903004f8
```


### Launch your instance
```
aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e
```

### Add a block device to your instance


Each instance that you launch has an associated root device volume. You can use block device mapping to specify additional Amazon Elastic Block Store (Amazon EBS) volumes or instance store volumes to attach to an instance when it's launched.

To add a block device to your instance, specify the --block-device-mappings option when you use run-instances.

The following example parameter provisions a standard Amazon EBS volume that is 20 GB in size, and maps it to your instance using the identifier /dev/sdf.

```
--block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":20,\"DeleteOnTermination\":false}}]"
```

### Add a tag to your instance
A tag is a label that you assign to an AWS resource. It enables you to add metadata to your resources that you can use for a variety of purposes. For more information, see [Tagging Your Resources](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) in the Amazon EC2 User Guide.
```
aws ec2 create-tags --resources i-5203422c --tags Key=Name,Value=MyInstance
```

### List your instances

You can use the AWS CLI to list your instances and view information about them. You can list all your instances, or filter the results based on the instances that you're interested in.
```
aws ec2 describe-instances
```

The following command filters the list to only your t2.micro instances and outputs only the InstanceId values for each match.

```
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId"
```

```
Output
[
"i-05e998023d9c69f9a"
]
```
The following command lists any of your instances that have the tag Name=MyInstance.

```
aws ec2 describe-instances --filters "Name=tag:Name,Values=MyInstance"
```

### Terminate your instances
Terminating an instance deletes it. You can't reconnect to an instance after you've terminated it.
```
aws ec2 terminate-instances --instance-ids i-5203422c
```


### Change an Amazon EC2 instance type with a bash script
This bash scripting example for Amazon EC2 changes the instance type for an Amazon EC2 instance using the AWS Command Line Interface (AWS CLI). It stops the instance if it's running, changes the instance type, and then, if requested, restarts the instance. Shell scripts are programs designed to run in a command line interface.
This example is written as a function in the shell script file change_ec2_instance_type.sh that you can source from another script or from the command line. Each script file contains comments describing each of the functions. Once the function is in memory, you can invoke it from the command line. For example, the following commands change the type of the specified instance to t2.nano:


Clone [GitHub](https://external.ink?to=/[placeholder.com](https://github.com/awsdocs/aws-doc-sdk-examples/blob/main/aws-cli/bash-linux/ec2/change-ec2-instance-type/test_change_ec2_instance_type.sh
)) repository.

```
source ./change_ec2_instance_type.sh
```
```
./change_ec2_instance_type -i *instance-id* -t new-type
```
More information on EC2 instance change is available [here](https://docs.aws.amazon.com/cli/v1/userguide/cli-services-ec2-instance-type-script.html)



## Amazon S3 bucket
Creating an AWS S3 (Simple Storage Service) Bucket using AWS CLI (Command Line Interface) is very easy and we can S3 Bucket using few AWS CLI commands.

S3 bucket guide 
```
aws s3 help
```

To view buckets in your existing account
```
aws s3 ls
```

Example 1: To create a bucket

The following create-bucket example creates a bucket named my-bucket:
```
aws s3api create-bucket \
    --bucket my-bucket \
    --region us-east-1
```

Example 2: To create a bucket with owner enforced

The following create-bucket example creates a bucket named my-bucket that uses the bucket owner enforced setting for S3 Object Ownership.
```
aws s3api create-bucket \
    --bucket my-bucket \
    --region us-east-1 \
    --object-ownership BucketOwnerEnforced
```

### Bash script to create instances
https://docs.aws.amazon.com/cli/v1/userguide/bash_ec2_code_examples.html





















<details>
<summary>References to all the files uploaded in this branch</summary>

|   File Name   | Purpose             |
| ------------- | ------------------- |
| aws-start.sh  | Start the instance  |
| aws-stop.sh   | Stop the instance   |
| aws-check.sh  | Check the instance  |
</details>

