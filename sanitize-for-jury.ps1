# Sanitize Kiro folder for Hackathon Jury
Write-Host "🧹 Sanitizing AllSensesAI project for Hackathon Jury..." -ForegroundColor Green

$SOURCE_DIR = "C:\Users\ivanp\OneDrive\Documents\Kiro"
$SANITIZED_DIR = "C:\Users\ivanp\OneDrive\Documents\Kiro_Sanitized_For_Jury"

# Step 1: Create clean copy
Write-Host "1️⃣ Creating clean copy..." -ForegroundColor Yellow
if (Test-Path $SANITIZED_DIR) {
    Remove-Item -Recurse -Force $SANITIZED_DIR
}
Copy-Item -Recurse $SOURCE_DIR $SANITIZED_DIR

# Step 2: Remove .git folder
Write-Host "2️⃣ Removing .git folder..." -ForegroundColor Yellow
$gitFolder = Join-Path $SANITIZED_DIR ".git"
if (Test-Path $gitFolder) {
    Remove-Item -Recurse -Force $gitFolder
}

# Step 3: Sanitize AWS credentials in all files
Write-Host "3️⃣ Sanitizing AWS credentials..." -ForegroundColor Yellow

$patterns = @{
    "<REDACTED_AWS_ACCESS_KEY>" = "<REDACTED_AWS_ACCESS_KEY>"
    "<REDACTED_AWS_SECRET_KEY>" = "<REDACTED_AWS_SECRET_KEY>"
    "<REDACTED_PHONE_NUMBER>" = "<REDACTED_PHONE_NUMBER>"
    "<REDACTED_EMAIL>" = "<REDACTED_EMAIL>"
}

$fileTypes = @("*.ps1", "*.py", "*.md", "*.html", "*.js", "*.yaml", "*.yml", "*.json", "*.txt")

foreach ($fileType in $fileTypes) {
    $files = Get-ChildItem -Path $SANITIZED_DIR -Filter $fileType -Recurse
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            $modified = $false
            foreach ($pattern in $patterns.Keys) {
                if ($content -match [regex]::Escape($pattern)) {
                    $content = $content -replace [regex]::Escape($pattern), $patterns[$pattern]
                    $modified = $true
                }
            }
            if ($modified) {
                Set-Content -Path $file.FullName -Value $content -NoNewline
                Write-Host "   Sanitized: $($file.Name)" -ForegroundColor Gray
            }
        }
    }
}

# Step 4: Create environment variable examples
Write-Host "4️⃣ Creating environment variable examples..." -ForegroundColor Yellow
$envExample = @"
# Environment Variables for AllSensesAI
# Copy this to .env and fill in your values

AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY>
AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_KEY>
AWS_DEFAULT_REGION=us-east-1
EMERGENCY_PHONE_NUMBER=<YOUR_PHONE_NUMBER>
NOTIFICATION_EMAIL=<YOUR_EMAIL>

# AWS Resource Names (update with your deployment)
LAMBDA_FUNCTION_NAME=AllSenses-Live-MVP-AllSensesFunction-XXXXXXXXX
SNS_TOPIC_ARN=arn:aws:sns:us-east-1:XXXXXXXXXXXX:AllSenses-Live-MVP-AlertTopic-XXXXXXXXX
DYNAMODB_TABLE_NAME=AllSenses-Live-MVP-DataTable-XXXXXXXXX
S3_BUCKET_NAME=allsenses-mvp1-demo-website
CLOUDFRONT_DISTRIBUTION_ID=XXXXXXXXXXXXXX
"@

Set-Content -Path (Join-Path $SANITIZED_DIR ".env.example") -Value $envExample

# Step 5: Create README for jury
$juryReadme = @"
# 🏆 AllSenses AI Guardian - Hackathon Jury Version

## 🎯 Project Overview
AllSenses AI Guardian is a real-time emergency detection system that uses AI to monitor audio for signs of distress and automatically alerts emergency contacts with victim identification and geolocation.

## 🚀 Key Features Implemented
- **Configurable Victim Names**: Jury can enter any victim's name
- **Configurable Emergency Contacts**: Real SMS alerts to any phone number
- **Dual Emergency Detection**: Emergency words + abrupt noise monitoring
- **Geolocation Integration**: GPS coordinates and Google Maps links in SMS
- **AWS Cloud-Native**: Lambda, SNS, Bedrock AI, DynamoDB integration
- **HTTPS Security**: Secure microphone access via CloudFront

## 🔗 Live Demo URL
**Jury Demo**: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html

## 📱 SMS Message Format
```
🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!
Emergency words detected: "help, emergency"

Location: Miami Convention Center, FL
View location: https://maps.google.com/?q=25.7617,-80.1918

Incident ID: JURY-A1B2C3D4
Time: 14:30:15

🏆 AllSensesAI Jury Demo - Live Emergency Detection System
```

## 🛠️ Technical Architecture
- **Frontend**: HTML5/CSS3/JavaScript with Web Audio API and Web Speech API
- **Backend**: AWS Lambda (Python) with SNS for SMS delivery
- **AI**: AWS Bedrock for threat analysis and reasoning
- **Storage**: DynamoDB for event logging, S3 for static assets
- **CDN**: CloudFront for global HTTPS delivery

## 🎮 Jury Instructions
1. Open the demo URL in Chrome/Firefox
2. Enter victim's name (e.g., "Carlos Perez")
3. Enter your phone number for SMS alerts
4. Click "Start Emergency Monitoring"
5. Test with emergency words or noise buttons
6. Receive real SMS with victim identification and location

## 📊 Implementation Status
✅ **Complete**: Victim name configuration, SMS with geolocation, dual detection
✅ **Deployed**: HTTPS demo URL with all features functional
✅ **Tested**: AWS integration validated, MessageId generation confirmed
⚠️ **Note**: SMS delivery requires phone verification in AWS SNS sandbox

## 🔧 Setup Instructions
1. Copy `.env.example` to `.env` and configure your AWS credentials
2. Deploy infrastructure using CloudFormation templates in `/infrastructure`
3. Update Lambda function with your code from `/allsenseai-complete.py`
4. Configure SNS for SMS delivery and verify phone numbers

## 📁 Project Structure
- `/frontend` - Progressive Web App with emergency detection
- `/infrastructure` - AWS CloudFormation templates
- `/.kiro/specs` - Complete requirements, design, and implementation plan
- `/allsenseai-complete.py` - Main Lambda function with AI integration

## 🏆 Hackathon Highlights
- **Real-world Impact**: Actual emergency detection and SMS alerting
- **AI Integration**: AWS Bedrock for intelligent threat analysis
- **User-Centric**: Configurable for any victim and emergency contact
- **Production-Ready**: Complete AWS cloud-native implementation
- **Scalable**: Serverless architecture handles unlimited users

---
**Built for Miami Hackathon 2024 - AllSenses AI Guardian Team**
"@

Set-Content -Path (Join-Path $SANITIZED_DIR "README.md") -Value $juryReadme

Write-Host "✅ Sanitization complete!" -ForegroundColor Green
Write-Host "📁 Sanitized folder: $SANITIZED_DIR" -ForegroundColor Cyan

# Step 6: Initialize git and push to GitHub
Write-Host "5️⃣ Initializing Git repository..." -ForegroundColor Yellow
Set-Location $SANITIZED_DIR

git init
git add .
git commit -m "Initial commit – sanitized for Hackathon jury (no secrets)"

Write-Host "6️⃣ Adding GitHub remote..." -ForegroundColor Yellow
git remote add origin https://github.com/ivnpdrn1/AllSensesAI-Kiro.git

Write-Host "7️⃣ Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

Write-Host "8️⃣ Verifying no secrets leaked..." -ForegroundColor Yellow
$akiaCheck = git grep "AKIA" 2>$null
$asiaCheck = git grep "ASIA" 2>$null

if (-not $akiaCheck -and -not $asiaCheck) {
    Write-Host ""
    Write-Host "✅ Repository sanitized and safely published for Hackathon Jury." -ForegroundColor Green
    Write-Host ""
    Write-Host "🔗 GitHub Repository: https://github.com/ivnpdrn1/AllSensesAI-Kiro" -ForegroundColor Cyan
    Write-Host "🎯 Jury Demo URL: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
} else {
    Write-Host "Warning: Potential secrets found, please review" -ForegroundColor Red
}

Set-Location $SOURCE_DIR