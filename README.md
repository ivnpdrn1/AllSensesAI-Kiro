# AllSenses AI Guardian - Enhanced Emergency Detection System

🏆 **HACKATHON JURY ACCESS**: http://allsenses-mvp1-demo-website.s3-website-us-east-1.amazonaws.com/mvp1-complete-demo.html

A fully operational AWS AI Agent with enhanced emergency detection capabilities that meets all three required conditions for AI agent qualification:

1. **Large Language Model (LLM)** hosted on AWS Bedrock (Claude-3-Haiku)
2. **Multiple AWS services** integrated (Bedrock, Lambda, DynamoDB, SNS)
3. **Complete AI agent qualification**:
   - Uses reasoning LLMs for autonomous decision-making
   - Demonstrates real-time autonomous emergency response
   - Integrates APIs, databases, and external tools for complete workflow

## 🚨 **Enhanced Emergency Detection Features**

### **Dual Detection Systems**
- **Emergency Word Detection**: Continuous monitoring for "help", "emergency", "danger", "911"
- **Abrupt Noise Detection**: Real-time audio analysis for sudden loud sounds
- **Visual Listening Indicator**: Clear status showing active monitoring
- **Immediate SMS Notifications**: Real emergency contact alerts via AWS SNS

## Architecture

This AI agent provides real-time threat detection and autonomous emergency response using:

- **AWS Bedrock**: Claude/Titan models for LLM-powered reasoning and decision-making
- **AWS DynamoDB**: Data persistence for threat assessments and emergency events
- **AWS Lambda**: Serverless processing for autonomous agent operations
- **AWS SNS**: Notification system for emergency contacts
- **Spring Boot**: Java application framework with AWS SDK integration

## Quick Start

### Prerequisites

1. **AWS Account** with appropriate permissions for:
   - AWS Bedrock (foundation models access)
   - AWS DynamoDB
   - AWS Lambda
   - AWS SNS

2. **AWS CLI** configured with credentials:
   ```bash
   aws configure
   ```

3. **Java 17** and **Maven** installed

### Local Development

1. **Clone and build**:
   ```bash
   git clone <repository>
   cd allsenses-ai-guardian
   mvn clean compile
   ```

2. **Configure AWS credentials** (one of):
   - AWS CLI: `aws configure`
   - Environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
   - IAM roles (when running on EC2)

3. **Run the application**:
   ```bash
   mvn spring-boot:run
   ```

4. **Access the application**:
   - Health check: http://localhost:8080/api/public/health
   - AWS status: http://localhost:8080/api/public/aws-status
   - AWS connectivity test: http://localhost:8080/api/public/aws-test
   - H2 Console: http://localhost:8080/h2-console

### Authentication

- **Username**: admin
- **Password**: admin123

## API Endpoints

### Public Endpoints (No Authentication)

- `GET /api/public/health` - Basic health check
- `GET /api/public/aws-status` - AWS services configuration status
- `GET /api/public/aws-test` - Test AWS services connectivity

### Protected Endpoints (Basic Auth Required)

- `GET /actuator/health` - Spring Boot actuator health
- `GET /actuator/info` - Application information
- `GET /h2-console` - H2 database console

## AWS AI Agent Qualification

This application demonstrates all three required conditions:

### ✅ Condition 1: LLM Integration
- AWS Bedrock Runtime client configured
- Claude 3 Sonnet and Titan models available
- LLM-powered reasoning for threat assessment

### ✅ Condition 2: AWS Services
- **AWS Bedrock**: Foundation model hosting and inference
- **AWS DynamoDB**: Data persistence and state management
- **AWS Lambda**: Serverless autonomous processing
- **AWS SNS**: External notification integration

### ✅ Condition 3: AI Agent Qualification
- **Reasoning LLMs**: Bedrock models make autonomous decisions
- **Autonomous Capabilities**: Agent operates with minimal human intervention
- **External Integrations**: APIs, databases, and AWS services integrated

## 🏆 **HACKATHON STATUS: COMPLETE**

- ✅ **MVP-1**: AWS-integrated project structure (COMPLETED)
- ✅ **MVP-2**: AWS Bedrock LLM integration (COMPLETED)
- ✅ **MVP-3**: Core data models with DynamoDB (COMPLETED)
- ✅ **MVP-4**: Bedrock-powered threat detection (COMPLETED)
- ✅ **MVP-5**: Autonomous emergency response (COMPLETED)
- ✅ **MVP-6**: REST API with AWS API Gateway (COMPLETED)
- ✅ **MVP-7**: Agent demonstration interface (COMPLETED)
- ✅ **MVP-8**: AWS deployment and qualification (COMPLETED)
- ✅ **ENHANCED**: Dual emergency detection systems (COMPLETED)
- ✅ **ENHANCED**: Real SMS notifications (COMPLETED)
- ✅ **ENHANCED**: Visual emergency monitoring (COMPLETED)

## Configuration

Key configuration properties in `application.properties`:

```properties
# AWS Configuration
aws.region=us-east-1
aws.bedrock.model.claude=anthropic.claude-3-sonnet-20240229-v1:0
aws.bedrock.model.titan=amazon.titan-text-express-v1

# DynamoDB Configuration
aws.dynamodb.table.prefix=allsenses-
```

## Next Steps

1. Implement AWS Bedrock LLM integration for reasoning
2. Create DynamoDB data models and repositories
3. Build autonomous threat detection with LLM decision-making
4. Add emergency response automation
5. Deploy to AWS with full service integration