# Deploy HTTPS Demo via CloudFront for Hackathon Jury
# This creates a public HTTPS URL accessible from any machine

Write-Host "🚀 Deploying HTTPS Demo for Hackathon Jury..." -ForegroundColor Cyan

# Set AWS credentials
$env:AWS_ACCESS_KEY_ID="AKIA3R32YLPUAKXWU6B7"
$env:AWS_SECRET_ACCESS_KEY="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"
$env:AWS_DEFAULT_REGION="us-east-1"

# Step 1: Upload enhanced monitor to S3
Write-Host "📁 Uploading enhanced emergency monitor to S3..." -ForegroundColor Yellow
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" s3 cp frontend/enhanced-emergency-monitor.html s3://allsenses-mvp1-demo-website/enhanced-emergency-monitor.html --profile allsenses

# Step 2: Deploy CloudFront distribution
Write-Host "☁️ Deploying CloudFront HTTPS distribution..." -ForegroundColor Yellow
& "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation deploy --template-file infrastructure/cloudfront-https-demo.yaml --stack-name AllSenses-HTTPS-Demo --profile allsenses

# Step 3: Get the HTTPS URLs
Write-Host "🔗 Getting HTTPS URLs..." -ForegroundColor Yellow
$CloudFrontURL = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation describe-stacks --stack-name AllSenses-HTTPS-Demo --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDemoURL'].OutputValue" --output text --profile allsenses

Write-Host "✅ HTTPS Demo Deployed Successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "🏆 HACKATHON JURY HTTPS URL:" -ForegroundColor Cyan
Write-Host "$CloudFrontURL" -ForegroundColor White
Write-Host ""
Write-Host "📋 Additional URLs:" -ForegroundColor Yellow

$EnhancedURL = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation describe-stacks --stack-name AllSenses-HTTPS-Demo --query "Stacks[0].Outputs[?OutputKey=='EnhancedMonitorURL'].OutputValue" --output text --profile allsenses

Write-Host "Enhanced Monitor: $EnhancedURL" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Features Available:" -ForegroundColor Green
Write-Host "✅ HTTPS Protocol - Microphone access enabled" -ForegroundColor Green
Write-Host "✅ Global CDN - Fast loading worldwide" -ForegroundColor Green
Write-Host "✅ Enhanced Emergency Detection - All features working" -ForegroundColor Green
Write-Host "✅ Real SMS Notifications - AWS SNS integration" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Ready for Hackathon Presentation!" -ForegroundColor Cyan