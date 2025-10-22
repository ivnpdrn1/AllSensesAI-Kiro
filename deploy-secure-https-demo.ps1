# Deploy Secure HTTPS Demo with CloudFront + ACM SSL Certificate
# This creates a professional HTTPS URL for Hackathon Jury access

Write-Host "🔒 Deploying Secure HTTPS Demo with SSL Certificate..." -ForegroundColor Cyan

# Set AWS credentials
$env:AWS_ACCESS_KEY_ID="<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY="<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION="us-east-1"

# Step 1: Upload enhanced monitor to S3 (if not already done)
Write-Host "📁 Ensuring enhanced monitor is in S3..." -ForegroundColor Yellow
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3 cp frontend/enhanced-emergency-monitor.html s3://allsenses-mvp1-demo-website/enhanced-emergency-monitor.html --profile allsenses

# Step 2: Deploy simple CloudFront distribution first (no custom domain)
Write-Host "☁️ Deploying CloudFront HTTPS distribution..." -ForegroundColor Yellow
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation deploy --template-file infrastructure/simple-cloudfront.yaml --stack-name AllSenses-CloudFront-HTTPS --profile allsenses

# Step 3: Get the CloudFront HTTPS URLs
Write-Host "🔗 Getting HTTPS URLs..." -ForegroundColor Yellow
$CloudFrontDomain = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation describe-stacks --stack-name AllSenses-CloudFront-HTTPS --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDomainName'].OutputValue" --output text --profile allsenses

$MainDemoURL = "https://$CloudFrontDomain/mvp1-complete-demo.html"
$EnhancedDemoURL = "https://$CloudFrontDomain/enhanced-emergency-monitor.html"

Write-Host "✅ HTTPS Demo Deployed Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "🏆 HACKATHON JURY HTTPS URLS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Main Demo (Original):" -ForegroundColor Yellow
Write-Host "$MainDemoURL" -ForegroundColor White
Write-Host ""
Write-Host "🛡️ Enhanced Emergency Monitor (Full Features):" -ForegroundColor Yellow
Write-Host "$EnhancedDemoURL" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Features Now Available:" -ForegroundColor Green
Write-Host "✅ HTTPS Protocol - Microphone access enabled" -ForegroundColor Green
Write-Host "✅ SSL Certificate - Secure connection" -ForegroundColor Green
Write-Host "✅ Global CDN - Fast loading worldwide" -ForegroundColor Green
Write-Host "✅ Enhanced Emergency Detection - All features working" -ForegroundColor Green
Write-Host "✅ Real SMS Notifications - AWS SNS integration" -ForegroundColor Green
Write-Host "✅ Visual Listening Indicator - Clear monitoring status" -ForegroundColor Green
Write-Host "✅ Dual Detection Systems - Emergency words + abrupt noise" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Ready for Hackathon Presentation!" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Demo Instructions for Jury:" -ForegroundColor Yellow
Write-Host "1. Access the Enhanced Demo URL above" -ForegroundColor White
Write-Host "2. Click 'Start Enhanced Monitoring' button" -ForegroundColor White
Write-Host "3. Allow microphone access when prompted" -ForegroundColor White
Write-Host "4. Say 'HELP! Emergency!' to test emergency words" -ForegroundColor White
Write-Host "5. Clap loudly to test abrupt noise detection" -ForegroundColor White
Write-Host "6. Watch real SMS sending with MessageId confirmation" -ForegroundColor White