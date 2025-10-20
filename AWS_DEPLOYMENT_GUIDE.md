# AllSenses AI Guardian - AWS Deployment Guide

## 🚀 **Complete AWS Deployment for Hackathon Demo**

This guide will deploy AllSenses AI Guardian to your AWS account with live AWS Bedrock, DynamoDB, Lambda, SNS, and API Gateway integration.

---

## 📋 **Prerequisites**

### **Required AWS Services Access**
- ✅ **Amazon Bedrock** (Claude-3 Sonnet, Titan Text Express)
- ✅ **Amazon DynamoDB** (Tables and auto-scaling)
- ✅ **AWS Lambda** (Function execution)
- ✅ **Amazon SNS** (Notification services)
- ✅ **Amazon API Gateway** (REST API management)
- ✅ **AWS CloudWatch** (Monitoring and logging)
- ✅ **AWS IAM** (Roles and permissions)

### **Local Requirements**
- ✅ **AWS CLI v2** installed
- ✅ **Java 17** or higher
- ✅ **Maven 3.8+**
- ✅ **Git** for version control

---

## 🔐 **Step 1: Secure AWS Credentials Setup**

### **Option A: AWS CLI Configuration (Recommended)**

#### **1.1 Install AWS CLI v2**
```powershell
# Download and install AWS CLI v2 for Windows
# Visit: https://awscli.amazonaws.com/AWSCLIV2.msi
# Or use chocolatey:
choco install awscli

# Verify installation
aws --version
```

#### **1.2 Configure AWS Credentials**
```powershell
# Configure AWS credentials (you'll need your Access Key ID and Secret Access Key)
aws configure

# You'll be prompted for:
# AWS Access Key ID [None]: YOUR_ACCESS_KEY_ID
# AWS Secret Access Key [None]: YOUR_SECRET_ACCESS_KEY
# Default region name [None]: us-east-1
# Default output format [None]: json
```

#### **1.3 Verify AWS Access**
```powershell
# Test AWS connection
aws sts get-caller-identity

# Should return your account information
```

### **Option B: Environment Variables**
```powershell
# Set environment variables (alternative to AWS CLI config)
$env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
$env:AWS_DEFAULT_REGION="us-east-1"
```

### **Option C: IAM Role (For EC2 deployment)**
```powershell
# If deploying on EC2, attach IAM role with required permissions
# See IAM permissions section below
```

---

## 🔑 **Step 2: Required IAM Permissions**

### **2.1 Create IAM Policy for AllSenses**

Create this IAM policy in your AWS account:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:ListFoundationModels",
                "bedrock:GetFoundationModel"
            ],
            "Resource": [
                "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
                "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-text-express-v1"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:CreateTable",
                "dynamodb:DeleteTable",
                "dynamodb:DescribeTable",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem",
                "dynamodb:DeleteItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchGetItem",
                "dynamodb:BatchWriteItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:us-east-1:*:table/AllSenses-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "lambda:DeleteFunction",
                "lambda:GetFunction",
                "lambda:InvokeFunction",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:ListFunctions"
            ],
            "Resource": [
                "arn:aws:lambda:us-east-1:*:function:AllSenses-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:GetTopicAttributes",
                "sns:ListTopics",
                "sns:Publish",
                "sns:Subscribe",
                "sns:Unsubscribe"
            ],
            "Resource": [
                "arn:aws:sns:us-east-1:*:AllSenses-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "apigateway:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/AllSenses-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:GetRole",
                "iam:PassRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy"
            ],
            "Resource": [
                "arn:aws:iam::*:role/AllSenses-*"
            ]
        }
    ]
}
```

### **2.2 Attach Policy to User/Role**
```powershell
# Create the policy
aws iam create-policy --policy-name AllSensesDeploymentPolicy --policy-document file://allsenses-iam-policy.json

# Attach to your user (replace YOUR_USERNAME)
aws iam attach-user-policy --user-name YOUR_USERNAME --policy-arn arn:aws:iam::YOUR_ACCOUNT_ID:policy/AllSensesDeploymentPolicy
```

---

## 🏗️ **Step 3: Enable Required AWS Services**

### **3.1 Enable Amazon Bedrock Models**

```powershell
# Check Bedrock model access
aws bedrock list-foundation-models --region us-east-1

# If models are not available, enable them in AWS Console:
# 1. Go to Amazon Bedrock console
# 2. Navigate to "Model access" in left sidebar
# 3. Click "Enable specific models"
# 4. Enable: Claude-3 Sonnet, Titan Text Express
# 5. Submit access request (usually approved instantly)
```

### **3.2 Verify Service Availability**
```powershell
# Test Bedrock access
aws bedrock list-foundation-models --region us-east-1 --query "modelSummaries[?contains(modelId, 'claude') || contains(modelId, 'titan')]"

# Test DynamoDB access
aws dynamodb list-tables --region us-east-1

# Test Lambda access
aws lambda list-functions --region us-east-1

# Test SNS access
aws sns list-topics --region us-east-1
```

---

## 📦 **Step 4: Deploy Infrastructure**

### **4.1 Create Deployment Configuration**

Create `deployment/aws-config.properties`:

```properties
# AWS Configuration
aws.region=us-east-1
aws.profile=default

# Application Configuration
app.name=AllSenses-AI-Guardian
app.environment=production
app.version=1.0.0

# DynamoDB Configuration
dynamodb.table.prefix=AllSenses
dynamodb.billing.mode=ON_DEMAND

# Bedrock Configuration
bedrock.primary.model=anthropic.claude-3-sonnet-20240229-v1:0
bedrock.fallback.model=amazon.titan-text-express-v1

# SNS Configuration
sns.topic.prefix=AllSenses
sns.emergency.topic=AllSenses-Emergency-Alerts

# Lambda Configuration
lambda.function.prefix=AllSenses
lambda.runtime=java17
lambda.memory=512
lambda.timeout=30
```

### **4.2 Create DynamoDB Tables**

Create `scripts/create-dynamodb-tables.ps1`:

```powershell
# Create DynamoDB Tables for AllSenses AI Guardian

Write-Host "Creating DynamoDB tables..." -ForegroundColor Green

# Users Table
aws dynamodb create-table `
    --table-name "AllSenses-Users" `
    --attribute-definitions `
        AttributeName=userId,AttributeType=S `
    --key-schema `
        AttributeName=userId,KeyType=HASH `
    --billing-mode ON_DEMAND `
    --region us-east-1

Write-Host "Created Users table" -ForegroundColor Yellow

# ThreatAssessments Table
aws dynamodb create-table `
    --table-name "AllSenses-ThreatAssessments" `
    --attribute-definitions `
        AttributeName=assessmentId,AttributeType=S `
        AttributeName=userId,AttributeType=S `
        AttributeName=timestamp,AttributeType=S `
    --key-schema `
        AttributeName=assessmentId,KeyType=HASH `
    --global-secondary-indexes `
        IndexName=UserIndex,KeySchema=[{AttributeName=userId,KeyType=HASH},{AttributeName=timestamp,KeyType=RANGE}],Projection={ProjectionType=ALL} `
    --billing-mode ON_DEMAND `
    --region us-east-1

Write-Host "Created ThreatAssessments table" -ForegroundColor Yellow

# EmergencyEvents Table
aws dynamodb create-table `
    --table-name "AllSenses-EmergencyEvents" `
    --attribute-definitions `
        AttributeName=eventId,AttributeType=S `
        AttributeName=userId,AttributeType=S `
        AttributeName=createdAt,AttributeType=S `
    --key-schema `
        AttributeName=eventId,KeyType=HASH `
    --global-secondary-indexes `
        IndexName=UserEventsIndex,KeySchema=[{AttributeName=userId,KeyType=HASH},{AttributeName=createdAt,KeyType=RANGE}],Projection={ProjectionType=ALL} `
    --billing-mode ON_DEMAND `
    --region us-east-1

Write-Host "Created EmergencyEvents table" -ForegroundColor Yellow

# Wait for tables to be active
Write-Host "Waiting for tables to become active..." -ForegroundColor Blue

aws dynamodb wait table-exists --table-name "AllSenses-Users" --region us-east-1
aws dynamodb wait table-exists --table-name "AllSenses-ThreatAssessments" --region us-east-1
aws dynamodb wait table-exists --table-name "AllSenses-EmergencyEvents" --region us-east-1

Write-Host "All DynamoDB tables created successfully!" -ForegroundColor Green
```

### **4.3 Create SNS Topics**

Create `scripts/create-sns-topics.ps1`:

```powershell
# Create SNS Topics for AllSenses AI Guardian

Write-Host "Creating SNS topics..." -ForegroundColor Green

# Emergency Alerts Topic
$emergencyTopicArn = aws sns create-topic --name "AllSenses-Emergency-Alerts" --region us-east-1 --query "TopicArn" --output text
Write-Host "Created Emergency Alerts topic: $emergencyTopicArn" -ForegroundColor Yellow

# System Notifications Topic
$systemTopicArn = aws sns create-topic --name "AllSenses-System-Notifications" --region us-east-1 --query "TopicArn" --output text
Write-Host "Created System Notifications topic: $systemTopicArn" -ForegroundColor Yellow

# User Notifications Topic
$userTopicArn = aws sns create-topic --name "AllSenses-User-Notifications" --region us-east-1 --query "TopicArn" --output text
Write-Host "Created User Notifications topic: $userTopicArn" -ForegroundColor Yellow

Write-Host "All SNS topics created successfully!" -ForegroundColor Green

# Output topic ARNs for application configuration
Write-Host "Topic ARNs:" -ForegroundColor Cyan
Write-Host "Emergency: $emergencyTopicArn"
Write-Host "System: $systemTopicArn"
Write-Host "User: $userTopicArn"
```

---

## ⚙️ **Step 5: Configure Application for AWS**

### **5.1 Update Application Properties**

Create `src/main/resources/application-aws.yml`:

```yaml
spring:
  profiles:
    active: aws
  application:
    name: allsenses-ai-guardian

# AWS Configuration
aws:
  region: us-east-1
  bedrock:
    primary-model: anthropic.claude-3-sonnet-20240229-v1:0
    fallback-model: amazon.titan-text-express-v1
    max-tokens: 1000
    temperature: 0.3
  
  dynamodb:
    tables:
      users: AllSenses-Users
      threat-assessments: AllSenses-ThreatAssessments
      emergency-events: AllSenses-EmergencyEvents
    
  sns:
    topics:
      emergency-alerts: AllSenses-Emergency-Alerts
      system-notifications: AllSenses-System-Notifications
      user-notifications: AllSenses-User-Notifications
  
  lambda:
    functions:
      audio-processor: AllSenses-AudioProcessor
      emergency-responder: AllSenses-EmergencyResponder

# Server Configuration
server:
  port: 8080
  servlet:
    context-path: /

# Logging Configuration
logging:
  level:
    com.allsenses: INFO
    software.amazon.awssdk: WARN
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"

# Management Endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
  endpoint:
    health:
      show-details: always
```

### **5.2 Update AWS SDK Configuration**

Update `src/main/java/com/allsenses/config/AwsConfig.java`:

```java
package com.allsenses.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.bedrock.BedrockClient;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.lambda.LambdaClient;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.cloudwatch.CloudWatchClient;

@Configuration
@Profile("aws")
public class AwsConfig {

    @Value("${aws.region:us-east-1}")
    private String awsRegion;

    @Bean
    public BedrockClient bedrockClient() {
        return BedrockClient.builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    @Bean
    public DynamoDbClient dynamoDbClient() {
        return DynamoDbClient.builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    @Bean
    public SnsClient snsClient() {
        return SnsClient.builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    @Bean
    public LambdaClient lambdaClient() {
        return LambdaClient.builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }

    @Bean
    public CloudWatchClient cloudWatchClient() {
        return CloudWatchClient.builder()
                .region(Region.of(awsRegion))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .build();
    }
}
```

---

## 🚀 **Step 6: Deploy Application**

### **6.1 Build Application**

```powershell
# Clean and build the application
./mvnw clean package -DskipTests

# Verify JAR file is created
ls target/allsenses-ai-guardian-*.jar
```

### **6.2 Run Deployment Scripts**

```powershell
# Make scripts executable and run deployment
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Create DynamoDB tables
./scripts/create-dynamodb-tables.ps1

# Create SNS topics
./scripts/create-sns-topics.ps1

# Wait for resources to be ready
Start-Sleep -Seconds 30
```

### **6.3 Start Application with AWS Profile**

```powershell
# Start the application with AWS profile
java -jar target/allsenses-ai-guardian-1.0.0.jar --spring.profiles.active=aws

# Or using Maven
./mvnw spring-boot:run -Dspring-boot.run.profiles=aws
```

---

## 🧪 **Step 7: Verify Deployment**

### **7.1 Health Check**

```powershell
# Check application health
curl http://localhost:8080/actuator/health

# Expected response:
# {"status":"UP","components":{"diskSpace":{"status":"UP"},"ping":{"status":"UP"}}}
```

### **7.2 Test AWS Integration**

```powershell
# Test Bedrock integration
curl http://localhost:8080/api/v1/threat-detection/test/llm-integration

# Test DynamoDB integration
curl http://localhost:8080/api/v1/users/statistics

# Test SNS integration
curl http://localhost:8080/api/v1/threat-detection/test/sns-integration

# Test complete workflow
curl http://localhost:8080/api/v1/emergency-events/test/complete-workflow
```

### **7.3 Test Audio Processing**

```powershell
# Test audio analysis endpoint
curl -X POST http://localhost:8080/api/v1/audio/test

# Expected response with threat analysis results
```

---

## 🎬 **Step 8: Hackathon Demo Setup**

### **8.1 Open Demo Interface**

```powershell
# Start a simple HTTP server for frontend
python -m http.server 8080 --directory frontend

# Or use Node.js
npx serve frontend -p 8080
```

### **8.2 Access Demo URLs**

- **Main Dashboard**: http://localhost:8080/index.html
- **Audio Monitor**: http://localhost:8080/audio-monitor.html
- **LLM Reasoning**: http://localhost:8080/reasoning.html
- **AWS Integration**: http://localhost:8080/aws-integration.html

### **8.3 Demo Verification Checklist**

- [ ] ✅ **Backend Running**: Spring Boot app on port 8080
- [ ] ✅ **Frontend Accessible**: All demo pages loading
- [ ] ✅ **AWS Services Connected**: All health checks passing
- [ ] ✅ **Audio Capture Working**: Microphone permissions granted
- [ ] ✅ **AI Analysis Functional**: Bedrock responding to requests
- [ ] ✅ **Emergency Response Active**: SNS notifications working
- [ ] ✅ **Performance Metrics**: Sub-200ms response times

---

## 🔧 **Troubleshooting**

### **Common Issues and Solutions**

#### **Issue: Bedrock Access Denied**
```powershell
# Solution: Enable model access in Bedrock console
# Go to AWS Console > Bedrock > Model access > Enable models
```

#### **Issue: DynamoDB Table Already Exists**
```powershell
# Solution: Delete and recreate tables
aws dynamodb delete-table --table-name AllSenses-Users --region us-east-1
# Wait and recreate
```

#### **Issue: SNS Permission Denied**
```powershell
# Solution: Check IAM permissions
aws iam list-attached-user-policies --user-name YOUR_USERNAME
```

#### **Issue: Application Won't Start**
```powershell
# Check Java version
java -version

# Check AWS credentials
aws sts get-caller-identity

# Check application logs
tail -f logs/application.log
```

### **Debug Commands**

```powershell
# Check AWS service status
aws bedrock list-foundation-models --region us-east-1
aws dynamodb list-tables --region us-east-1
aws sns list-topics --region us-east-1

# Test individual endpoints
curl -v http://localhost:8080/actuator/health
curl -v http://localhost:8080/api/v1/well-architected/status

# Check application logs
Get-Content logs/application.log -Tail 50 -Wait
```

---

## 💰 **Cost Estimation**

### **Expected AWS Costs for Demo**

| Service | Usage | Estimated Cost |
|---------|-------|----------------|
| **Bedrock** | 100 API calls | $0.50 |
| **DynamoDB** | On-demand, minimal data | $0.10 |
| **Lambda** | 50 invocations | $0.01 |
| **SNS** | 20 messages | $0.01 |
| **API Gateway** | 100 requests | $0.01 |
| **CloudWatch** | Basic monitoring | $0.05 |
| **Total** | **Demo session** | **~$0.68** |

**Note**: Costs are minimal for demo purposes. Production usage would scale accordingly.

---

## 🎯 **Success Criteria**

### **Deployment Complete When:**

- ✅ All AWS services are accessible and configured
- ✅ Application starts without errors
- ✅ All health checks return "UP" status
- ✅ Audio processing works end-to-end
- ✅ Emergency response triggers successfully
- ✅ Demo interface shows real-time processing
- ✅ Performance metrics show sub-200ms response times

### **Ready for Hackathon When:**

- ✅ Live demo runs smoothly with real AWS services
- ✅ All test scenarios work (normal, distress, emergency)
- ✅ AWS integration dashboard shows connected services
- ✅ Well-Architected compliance endpoints respond correctly
- ✅ Performance metrics demonstrate production readiness

---

## 🏆 **You're Ready for Hackathon Success!**

Once deployed, you'll have:

1. **Live AWS Integration**: Real Bedrock, DynamoDB, Lambda, SNS services
2. **Working Demo**: Complete audio-to-emergency response cycle
3. **Performance Proof**: Sub-200ms processing with actual AWS services
4. **Professional Architecture**: Production-ready deployment
5. **Competitive Edge**: Only hackathon project with live AWS AI agent

**AllSenses AI Guardian is now running live on AWS and ready to win the hackathon!** 🚀