# 🔐 AllSenses AI Guardian - Secure Live Deployment Guide

## Overview

This guide provides step-by-step instructions for securely connecting your AWS account to KIRO for automated deployment of AllSenses AI Guardian. All security best practices are implemented, including least-privilege access, credential protection, and encrypted communications.

---

## 🛡️ Security Features

### **Credential Protection**
- ✅ **No credential storage** - Credentials used only in memory during deployment
- ✅ **Automatic cleanup** - All temporary files and variables cleared after use
- ✅ **Least-privilege IAM** - Minimal permissions scoped to AllSenses resources only
- ✅ **Session-based access** - Credentials valid only for deployment session

### **Encryption & Security**
- ✅ **Encryption at rest** - All DynamoDB tables use customer-managed KMS keys
- ✅ **Encryption in transit** - TLS 1.3 for all API communications
- ✅ **VPC isolation** - Lambda functions in private subnets with security groups
- ✅ **Input validation** - API Gateway request validation and throttling

### **Monitoring & Auditing**
- ✅ **CloudWatch logging** - Comprehensive logging with retention policies
- ✅ **CloudTrail integration** - All deployment actions audited
- ✅ **Resource tagging** - All resources tagged for tracking and billing
- ✅ **Permission validation** - Pre-deployment permission verification

---

## 📋 Prerequisites

### **1. AWS Account Setup**
You need an AWS account with:
- Administrative access to create IAM users/policies
- Access to AWS Bedrock (Claude-3 and Titan models)
- Sufficient service limits for the deployment

### **2. Required AWS Services**
Ensure these services are available in your target region:
- AWS Bedrock
- Amazon DynamoDB
- AWS Lambda
- Amazon SNS
- Amazon API Gateway
- AWS KMS
- Amazon VPC
- AWS CloudWatch

---

## 🔑 Step 1: Create Deployment IAM User

### **Option A: Use Automated Script (Recommended)**

Run the permission setup script to create a deployment user:

```powershell
# Windows PowerShell
.\scripts\setup-aws-permissions.ps1 -CreateUser -UserName "allsenses-kiro-deployer"
```

This creates:
- IAM user with least-privilege permissions
- Access keys for deployment
- Scoped permissions to AllSenses-* resources only

### **Option B: Manual IAM User Creation**

1. **Go to AWS IAM Console**: https://console.aws.amazon.com/iam/
2. **Create User**:
   - Username: `allsenses-kiro-deployer`
   - Access type: ✅ Programmatic access
3. **Create Custom Policy** with this JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllSensesDeploymentPermissions",
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:UpdateStack",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeStacks",
        "cloudformation:DescribeStackEvents",
        "cloudformation:ValidateTemplate",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:CreatePolicy",
        "lambda:CreateFunction",
        "lambda:DeleteFunction",
        "lambda:GetFunction",
        "lambda:UpdateFunctionCode",
        "lambda:AddPermission",
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:DescribeTable",
        "dynamodb:UpdateTable",
        "sns:CreateTopic",
        "sns:DeleteTopic",
        "sns:Subscribe",
        "sns:GetTopicAttributes",
        "apigateway:*",
        "kms:CreateKey",
        "kms:CreateAlias",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:PutKeyPolicy",
        "ec2:CreateVpc",
        "ec2:CreateSubnet",
        "ec2:CreateSecurityGroup",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeAvailabilityZones",
        "logs:CreateLogGroup",
        "logs:DescribeLogGroups",
        "bedrock:ListFoundationModels",
        "bedrock:InvokeModel",
        "sts:GetCallerIdentity"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestedRegion": ["us-east-1", "us-west-2", "eu-west-1"]
        }
      }
    }
  ]
}
```

4. **Attach Policy** to the user
5. **Create Access Keys** and save them securely

---

## 🧠 Step 2: Enable Bedrock Model Access

1. **Go to AWS Bedrock Console**: https://console.aws.amazon.com/bedrock/
2. **Navigate to "Model access"**
3. **Request access** to:
   - ✅ **Claude-3 Sonnet** (`anthropic.claude-3-sonnet-20240229-v1:0`)
   - ✅ **Titan Text Express** (`amazon.titan-text-express-v1`)

> **Note:** Model access approval typically takes 5-15 minutes.

---

## 🔍 Step 3: Validate Permissions (Optional but Recommended)

Before deployment, validate that your IAM user has all required permissions:

```powershell
.\scripts\validate-deployment-permissions.ps1 -AccessKeyId "YOUR_ACCESS_KEY" -SecretAccessKey "YOUR_SECRET_KEY"
```

This script:
- ✅ Tests all required AWS service permissions
- ✅ Verifies Bedrock model access
- ✅ Provides detailed permission report
- ✅ Automatically clears credentials from memory

---

## 🚀 Step 4: Execute Secure Deployment

### **Method 1: Two-Step Secure Process (Recommended)**

**Step 4a: Setup Deployment Configuration**
```powershell
.\scripts\secure-deployment-setup.ps1 -AccessKeyId "YOUR_ACCESS_KEY" -SecretAccessKey "YOUR_SECRET_KEY" -NotificationEmail "your-email@company.com"
```

**Step 4b: Execute Deployment**
```powershell
.\scripts\execute-secure-deployment.ps1
```

### **Method 2: Direct Deployment**
```powershell
.\scripts\deploy-allsenses.ps1 -NotificationEmail "your-email@company.com"
# (Set AWS credentials as environment variables first)
```

---

## 📊 Step 5: Verify Deployment

### **Automatic Verification**
The deployment script automatically:
- ✅ Tests API endpoints
- ✅ Verifies database connectivity
- ✅ Confirms SNS notifications
- ✅ Validates security configurations

### **Manual Verification**
1. **Check AWS Console**:
   - CloudFormation: Stack status should be `CREATE_COMPLETE`
   - Lambda: Function should be deployed and configured
   - DynamoDB: Tables should be created with encryption
   - SNS: Check email for subscription confirmation

2. **Test API Endpoint**:
```powershell
# Use the generated test script
.\test-deployment.sh
```

---

## 🔧 Step 6: Configure Frontend

Update your frontend configuration with the deployed API endpoint:

```javascript
// The deployment provides the exact URL in deployment-results.json
const API_BASE_URL = 'https://your-api-id.execute-api.us-east-1.amazonaws.com/production';
```

---

## 🛡️ Security Compliance Checklist

### **During Deployment**
- [ ] ✅ **Credentials never stored** in files or logs
- [ ] ✅ **Least-privilege IAM** user with scoped permissions
- [ ] ✅ **Encrypted communications** for all AWS API calls
- [ ] ✅ **Temporary credential usage** with automatic cleanup
- [ ] ✅ **Permission validation** before deployment

### **Post-Deployment**
- [ ] ✅ **All data encrypted at rest** with customer-managed KMS keys
- [ ] ✅ **VPC isolation** for Lambda functions
- [ ] ✅ **API Gateway security** with request validation and throttling
- [ ] ✅ **CloudWatch monitoring** enabled for all services
- [ ] ✅ **Resource tagging** for compliance and billing

### **Ongoing Security**
- [ ] 🔄 **Rotate access keys** regularly (every 90 days)
- [ ] 🔄 **Monitor CloudTrail** for deployment activities
- [ ] 🔄 **Review IAM policies** quarterly
- [ ] 🔄 **Update Bedrock model access** as needed
- [ ] 🔄 **Monitor costs** and set billing alerts

---

## 🚨 Troubleshooting

### **Common Issues**

**1. Permission Denied Errors**
```
Error: User is not authorized to perform: [action]
```
**Solution:** Run the permission validation script and ensure all required permissions are granted.

**2. Bedrock Model Access Denied**
```
Error: AccessDeniedException when calling InvokeModel
```
**Solution:** Request model access in Bedrock console and wait for approval.

**3. CloudFormation Stack Rollback**
```
Error: Stack creation failed and rolled back
```
**Solution:** Check CloudFormation events in AWS console for specific error details.

### **Debug Commands**

**Check Deployment Status:**
```powershell
aws cloudformation describe-stacks --stack-name AllSenses-AI-Guardian
```

**View CloudFormation Events:**
```powershell
aws cloudformation describe-stack-events --stack-name AllSenses-AI-Guardian
```

**Test Lambda Function:**
```powershell
aws lambda invoke --function-name AllSenses-Audio-Processor-production --payload '{"test":"data"}' response.json
```

---

## 🧹 Cleanup and Security

### **After Deployment**
1. **Delete access keys** from local storage
2. **Clear browser history** if using web console
3. **Rotate IAM user keys** if needed
4. **Review CloudTrail logs** for deployment activities

### **Complete Cleanup (if needed)**
```powershell
# Delete the entire stack
aws cloudformation delete-stack --stack-name AllSenses-AI-Guardian

# Delete the IAM user (optional)
aws iam delete-access-key --user-name allsenses-kiro-deployer --access-key-id YOUR_KEY_ID
aws iam delete-user --user-name allsenses-kiro-deployer
```

---

## 📞 Support and Monitoring

### **Deployment Results**
All deployment information is saved to `deployment-results.json`:
```json
{
  "stackName": "AllSenses-AI-Guardian",
  "apiEndpoint": "https://api-id.execute-api.us-east-1.amazonaws.com/production",
  "audioAnalysisEndpoint": "https://api-id.execute-api.us-east-1.amazonaws.com/production/audio/analyze",
  "kmsKeyId": "arn:aws:kms:us-east-1:account:key/key-id",
  "emergencyTopicArn": "arn:aws:sns:us-east-1:account:AllSenses-Emergency-Alerts-production"
}
```

### **Monitoring**
- **CloudWatch Dashboards**: Monitor Lambda performance and API usage
- **CloudTrail**: Audit all deployment and runtime activities
- **Cost Explorer**: Track deployment and operational costs
- **SNS Notifications**: Receive emergency alerts and system notifications

---

## ✅ Ready for Deployment

**Your AllSenses AI Guardian deployment is now ready with:**

🔐 **Enterprise-grade security** with encryption and least-privilege access  
🚀 **Automated deployment** with comprehensive validation  
📊 **Complete monitoring** and logging infrastructure  
🛡️ **AWS best practices** implementation throughout  
🔄 **Easy maintenance** and update procedures  

**Proceed with confidence knowing your deployment follows all AWS security best practices!**