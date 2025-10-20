# AllSenses AI Guardian - AWS Deployment Guide

## 🚀 Complete Secure Deployment to AWS

This guide provides a comprehensive, secure deployment process for AllSenses AI Guardian to your AWS account, following AWS security best practices and implementing least-privilege access controls.

---

## 📋 Prerequisites

### Required Tools
- **AWS CLI v2** - [Download here](https://aws.amazon.com/cli/)
- **PowerShell 5.1+** (Windows) or **Bash** (Linux/macOS)
- **jq** (for Linux/macOS JSON processing)

### AWS Account Requirements
- AWS account with appropriate permissions
- Access to the following AWS services:
  - AWS Bedrock (Claude-3 and Titan models)
  - Amazon DynamoDB
  - AWS Lambda
  - Amazon SNS
  - Amazon API Gateway
  - AWS KMS
  - Amazon VPC
  - AWS CloudWatch

---

## 🔐 Step 1: Setup AWS Permissions

Before deploying, you need proper IAM permissions. Choose one of the following options:

### Option A: Create New Deployment User (Recommended)

**Windows:**
```powershell
.\scripts\setup-aws-permissions.ps1 -CreateUser -UserName "allsenses-deployer"
```

**Linux/macOS:**
```bash
chmod +x scripts/setup-aws-permissions.sh
./scripts/setup-aws-permissions.sh --create-user --user-name "allsenses-deployer"
```

This will:
- Create a new IAM user with minimal required permissions
- Generate access keys for deployment
- Save credentials to `allsenses-aws-credentials.txt`

### Option B: Attach to Current User

**Windows:**
```powershell
.\scripts\setup-aws-permissions.ps1 -AttachToCurrentUser
```

**Linux/macOS:**
```bash
./scripts/setup-aws-permissions.sh --attach-current
```

### Option C: Manual Policy Attachment

If you prefer to handle user management separately:

**Windows:**
```powershell
.\scripts\setup-aws-permissions.ps1
```

**Linux/macOS:**
```bash
./scripts/setup-aws-permissions.sh
```

Then manually attach the created policy `AllSenses-Deployment-Policy` to your desired user.

---

## 🧠 Step 2: Enable AWS Bedrock Access

1. **Navigate to AWS Bedrock Console**: https://console.aws.amazon.com/bedrock/
2. **Go to "Model access"** in the left sidebar
3. **Request access** to these models:
   - ✅ **Claude-3 Sonnet** (`anthropic.claude-3-sonnet-20240229-v1:0`)
   - ✅ **Titan Text Express** (`amazon.titan-text-express-v1`)

> **Note:** Model access approval can take a few minutes to several hours.

---

## 🚀 Step 3: Deploy AllSenses Infrastructure

### Configure AWS CLI (if using new user)

If you created a new user in Step 1:

```bash
aws configure
# Enter the Access Key ID and Secret Access Key from allsenses-aws-credentials.txt
# Set region: us-east-1 (or your preferred region)
# Set output format: json
```

### Run Deployment Script

**Windows:**
```powershell
.\scripts\deploy-allsenses.ps1 -NotificationEmail "your-email@company.com"
```

**Linux/macOS:**
```bash
chmod +x scripts/deploy-allsenses.sh
./scripts/deploy-allsenses.sh -e "your-email@company.com"
```

### Advanced Deployment Options

**Custom Environment and Region:**
```bash
# Windows
.\scripts\deploy-allsenses.ps1 -NotificationEmail "admin@company.com" -Environment "staging" -Region "us-west-2"

# Linux/macOS
./scripts/deploy-allsenses.sh -e "admin@company.com" -n "staging" -r "us-west-2"
```

**Skip Prerequisites Check:**
```bash
# Windows
.\scripts\deploy-allsenses.ps1 -NotificationEmail "admin@company.com" -SkipPrerequisites

# Linux/macOS
./scripts/deploy-allsenses.sh -e "admin@company.com" --skip-prerequisites
```

---

## 📊 Step 4: Verify Deployment

### Check Deployment Status

The deployment script will automatically:
1. ✅ Validate CloudFormation template
2. ✅ Deploy all AWS resources
3. ✅ Configure security settings
4. ✅ Test the API endpoint
5. ✅ Save configuration to `deployment-config.json`

### Manual Verification

**Test API Endpoint:**
```bash
# Use the test script created during deployment
./test-deployment.sh
```

**Check AWS Console:**
- **CloudFormation**: Verify stack `AllSenses-AI-Guardian` is `CREATE_COMPLETE`
- **Lambda**: Check `AllSenses-Audio-Processor-production` function
- **DynamoDB**: Verify tables are created with encryption
- **SNS**: Confirm email subscription (check your email)
- **API Gateway**: Test the `/audio/analyze` endpoint

---

## 🔧 Step 5: Configure Frontend

Update your frontend configuration with the deployed API endpoint:

```javascript
// Update in frontend/assets/js/*.js files
const API_BASE_URL = 'https://your-api-id.execute-api.us-east-1.amazonaws.com/production';
```

The deployment script provides the exact URL in its output and saves it to `deployment-config.json`.

---

## 🛡️ Security Features Implemented

### Encryption
- **Data at Rest**: All DynamoDB tables encrypted with customer-managed KMS keys
- **Data in Transit**: TLS 1.3 for all API communications
- **SNS Topics**: Encrypted with dedicated KMS keys

### Access Control
- **Least Privilege IAM**: Minimal permissions for each service
- **VPC Isolation**: Lambda functions in private subnets
- **API Gateway**: Request validation and rate limiting
- **Resource Scoping**: All permissions limited to AllSenses-* resources

### Monitoring
- **CloudWatch Logs**: Centralized logging for all services
- **API Gateway Logging**: Request/response logging with data privacy
- **Lambda Monitoring**: Performance and error tracking

### Data Protection
- **Input Validation**: JSON schema validation on API requests
- **Error Handling**: Secure error responses without sensitive data exposure
- **Audit Trail**: All resource changes tracked via CloudFormation

---

## 📈 Monitoring and Maintenance

### CloudWatch Dashboards

Access monitoring at:
- **Lambda Metrics**: https://console.aws.amazon.com/lambda/
- **API Gateway Metrics**: https://console.aws.amazon.com/apigateway/
- **DynamoDB Metrics**: https://console.aws.amazon.com/dynamodb/

### Log Analysis

**View Lambda Logs:**
```bash
aws logs filter-log-events \
  --log-group-name "/aws/lambda/AllSenses-Audio-Processor-production" \
  --start-time $(date -d '1 hour ago' +%s)000
```

**View API Gateway Logs:**
```bash
aws logs filter-log-events \
  --log-group-name "/aws/apigateway/AllSenses-production" \
  --start-time $(date -d '1 hour ago' +%s)000
```

### Cost Monitoring

Set up billing alerts:
1. Go to **AWS Billing Console**
2. Create **Budget** for AllSenses resources
3. Set alerts for monthly spend thresholds

---

## 🔄 Updates and Maintenance

### Update Deployment

To update the infrastructure:
```bash
# Re-run the deployment script with same parameters
./scripts/deploy-allsenses.sh -e "your-email@company.com"
```

### Update Lambda Function Code

```bash
# Package new code
zip -r function.zip audio_processor.py

# Update function
aws lambda update-function-code \
  --function-name AllSenses-Audio-Processor-production \
  --zip-file fileb://function.zip
```

### Rotate KMS Keys

```bash
# Create new key version (automatic rotation)
aws kms enable-key-rotation --key-id alias/allsenses-production
```

---

## 🚨 Troubleshooting

### Common Issues

**1. Bedrock Access Denied**
```
Error: AccessDeniedException when calling InvokeModel
```
**Solution:** Request model access in Bedrock console and wait for approval.

**2. CloudFormation Stack Rollback**
```
Error: Stack creation failed
```
**Solution:** Check CloudFormation events in AWS console for specific error details.

**3. SNS Subscription Not Confirmed**
```
Warning: Emergency notifications not working
```
**Solution:** Check email and confirm SNS subscription.

**4. API Gateway 403 Errors**
```
Error: Forbidden when calling API
```
**Solution:** Verify API Gateway deployment and Lambda permissions.

### Debug Commands

**Check Stack Status:**
```bash
aws cloudformation describe-stacks --stack-name AllSenses-AI-Guardian
```

**Test Lambda Function:**
```bash
aws lambda invoke \
  --function-name AllSenses-Audio-Processor-production \
  --payload '{"audioData":"test","userId":"debug","location":"test"}' \
  response.json
```

**Verify DynamoDB Tables:**
```bash
aws dynamodb list-tables --query 'TableNames[?starts_with(@, `AllSenses-`)]'
```

---

## 🧹 Cleanup

To remove all AllSenses resources:

```bash
# Delete CloudFormation stack
aws cloudformation delete-stack --stack-name AllSenses-AI-Guardian

# Wait for deletion to complete
aws cloudformation wait stack-delete-complete --stack-name AllSenses-AI-Guardian

# Clean up IAM policy (optional)
aws iam delete-policy --policy-arn arn:aws:iam::ACCOUNT-ID:policy/AllSenses-Deployment-Policy
```

---

## 📞 Support

### Documentation
- **AWS CloudFormation**: https://docs.aws.amazon.com/cloudformation/
- **AWS Bedrock**: https://docs.aws.amazon.com/bedrock/
- **AWS Lambda**: https://docs.aws.amazon.com/lambda/

### Logs and Debugging
- All deployment logs are saved during execution
- CloudWatch logs provide runtime debugging information
- CloudFormation events show infrastructure deployment details

### Security Best Practices
- Regularly review IAM permissions
- Monitor CloudWatch logs for anomalies
- Keep AWS CLI and tools updated
- Rotate access keys periodically

---

## ✅ Deployment Checklist

- [ ] **AWS CLI configured** with proper credentials
- [ ] **Bedrock model access** approved for Claude-3 and Titan
- [ ] **IAM permissions** set up with least privilege
- [ ] **Email notification** configured and confirmed
- [ ] **CloudFormation stack** deployed successfully
- [ ] **API endpoint** tested and responding
- [ ] **Frontend configuration** updated with new API URL
- [ ] **Monitoring** configured in CloudWatch
- [ ] **Security settings** reviewed and validated

**🎉 Your AllSenses AI Guardian is now securely deployed and ready for production use!**