#!/usr/bin/env bash
set -e

# Prerequisites:
# 1. Create the EKS cluster using the course's eks-config.yaml.
# 2. Ensure the cluster name below matches metadata.name in eks-config.yaml.
# 3. Confirm all four CIDRs below are unused and fit within the EKS VPC CIDR range.
# 4. Run this script only once for this VPC.
#
# This script discovers the EKS VPC and its public route table automatically.
# Requirements: AWS CLI configured for the correct account, with permissions to manage VPC subnets and route tables.

# AWS region used by this project.
REGION="ap-south-1"

# Cluster name from metadata.name in eks-config.yaml.
CLUSTER_NAME="cwvj-mega-demo-eks"

# Find the VPC created by eksctl for this cluster.
VPC_ID=$(aws ec2 describe-vpcs \
  --region "$REGION" \
  --filters "Name=tag:alpha.eksctl.io/cluster-name,Values=$CLUSTER_NAME" \
  --query 'Vpcs[0].VpcId' \
  --output text)

# Find the public route table in that VPC, identified by its active default route to an Internet Gateway.
PUBLIC_ROUTE_TABLE_ID=$(aws ec2 describe-route-tables \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "RouteTables[?Routes[?DestinationCidrBlock=='0.0.0.0/0' && GatewayId!=null && starts_with(GatewayId, 'igw-') && State=='active']].RouteTableId | [0]" \
  --output text)

# Display the automatically discovered IDs before creating resources.
echo "EKS cluster: $CLUSTER_NAME"
echo "VPC ID: $VPC_ID"
echo "Public route table ID: $PUBLIC_ROUTE_TABLE_ID"

# Create the first public DevOps subnet in AZ ap-south-1a.
DEVOPS_PUBLIC_SUBNET_A_ID=$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block 192.168.128.0/27 \
  --availability-zone ap-south-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=cwvj-mega-demo-devops-public-a},{Key=owner,Value=cloudwithvarjosh},{Key=project,Value=cwvj-mega-demo},{Key=purpose,Value=github-actions-mega-project},{Key=managed-by,Value=manual}]' \
  --query 'Subnet.SubnetId' \
  --output text)

# Create the second public DevOps subnet in AZ ap-south-1b.
DEVOPS_PUBLIC_SUBNET_B_ID=$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block 192.168.128.32/27 \
  --availability-zone ap-south-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=cwvj-mega-demo-devops-public-b},{Key=owner,Value=cloudwithvarjosh},{Key=project,Value=cwvj-mega-demo},{Key=purpose,Value=github-actions-mega-project},{Key=managed-by,Value=manual}]' \
  --query 'Subnet.SubnetId' \
  --output text)

# Enable automatic public IPv4 assignment for instances launched in both DevOps subnets.
aws ec2 modify-subnet-attribute \
  --region "$REGION" \
  --subnet-id "$DEVOPS_PUBLIC_SUBNET_A_ID" \
  --map-public-ip-on-launch

aws ec2 modify-subnet-attribute \
  --region "$REGION" \
  --subnet-id "$DEVOPS_PUBLIC_SUBNET_B_ID" \
  --map-public-ip-on-launch

# Associate both DevOps subnets with the existing public route table.
aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$PUBLIC_ROUTE_TABLE_ID" \
  --subnet-id "$DEVOPS_PUBLIC_SUBNET_A_ID"

aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$PUBLIC_ROUTE_TABLE_ID" \
  --subnet-id "$DEVOPS_PUBLIC_SUBNET_B_ID"

# Create the first private database subnet in AZ ap-south-1a.
DB_PRIVATE_SUBNET_A_ID=$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block 192.168.128.64/27 \
  --availability-zone ap-south-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=cwvj-mega-demo-db-private-a},{Key=owner,Value=cloudwithvarjosh},{Key=project,Value=cwvj-mega-demo},{Key=purpose,Value=github-actions-mega-project},{Key=managed-by,Value=manual}]' \
  --query 'Subnet.SubnetId' \
  --output text)

# Create the second private database subnet in AZ ap-south-1b.
DB_PRIVATE_SUBNET_B_ID=$(aws ec2 create-subnet \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block 192.168.128.96/27 \
  --availability-zone ap-south-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=cwvj-mega-demo-db-private-b},{Key=owner,Value=cloudwithvarjosh},{Key=project,Value=cwvj-mega-demo},{Key=purpose,Value=github-actions-mega-project},{Key=managed-by,Value=manual}]' \
  --query 'Subnet.SubnetId' \
  --output text)

# Create a dedicated private route table for databases. AWS adds the local VPC route automatically.
DB_PRIVATE_ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --region "$REGION" \
  --vpc-id "$VPC_ID" \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=cwvj-mega-demo-db-private-rt},{Key=owner,Value=cloudwithvarjosh},{Key=project,Value=cwvj-mega-demo},{Key=purpose,Value=github-actions-mega-project},{Key=managed-by,Value=manual}]' \
  --query 'RouteTable.RouteTableId' \
  --output text)

# Associate the first database subnet with the dedicated private route table.
aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$DB_PRIVATE_ROUTE_TABLE_ID" \
  --subnet-id "$DB_PRIVATE_SUBNET_A_ID"

# Associate the second database subnet with the same private route table.
aws ec2 associate-route-table \
  --region "$REGION" \
  --route-table-id "$DB_PRIVATE_ROUTE_TABLE_ID" \
  --subnet-id "$DB_PRIVATE_SUBNET_B_ID"

# Display the IDs needed in later labs.
echo "DevOps public subnet A ID: $DEVOPS_PUBLIC_SUBNET_A_ID"
echo "DevOps public subnet B ID: $DEVOPS_PUBLIC_SUBNET_B_ID"
echo "Database private subnet A ID: $DB_PRIVATE_SUBNET_A_ID"
echo "Database private subnet B ID: $DB_PRIVATE_SUBNET_B_ID"
echo "Database private route table ID: $DB_PRIVATE_ROUTE_TABLE_ID"

# Verify the created subnets, their AZs, CIDRs, and public IPv4 setting.
aws ec2 describe-subnets \
  --region "$REGION" \
  --subnet-ids "$DEVOPS_PUBLIC_SUBNET_A_ID" "$DEVOPS_PUBLIC_SUBNET_B_ID" "$DB_PRIVATE_SUBNET_A_ID" "$DB_PRIVATE_SUBNET_B_ID" \
  --query 'Subnets[].{Name:Tags[?Key==`Name`]|[0].Value,SubnetId:SubnetId,CIDR:CidrBlock,AZ:AvailabilityZone,AutoPublicIP:MapPublicIpOnLaunch}' \
  --output table

# Verify route-table associations and routes.
aws ec2 describe-route-tables \
  --region "$REGION" \
  --route-table-ids "$PUBLIC_ROUTE_TABLE_ID" "$DB_PRIVATE_ROUTE_TABLE_ID" \
  --query 'RouteTables[].{RouteTableId:RouteTableId,Associations:Associations[?SubnetId!=null].SubnetId,Routes:Routes[].{Destination:DestinationCidrBlock,Gateway:GatewayId,NAT:NatGatewayId,State:State}}' \
  --output json
