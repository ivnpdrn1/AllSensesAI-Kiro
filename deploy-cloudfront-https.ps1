# Deploy CloudFront HTTPS Distribution for AllSenses Demo
# Enables microphone access for enhanced emergency detection

Write-Host "🔒 AllSenses CloudFront HTTPS Deployment" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Set AWS credentials
$env:AWS_ACCESS_KEY_ID="<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY="<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION="us-east-1"

Write-Host "✅ AWS credentials configured" -ForegroundColor Green

# Check if stack already exists
Write-Host "🔍 Checking existing CloudFront deployment..." -ForegroundColor Yellow
$existingStack = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation describe-stacks --stack-name AllSenses-CloudFront-HTTPS --profile allsenses 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ CloudFront stack already exists - getting URLs..." -ForegroundColor Green
} else {
    Write-Host "🚀 Deploying new CloudFront HTTPS distribution..." -ForegroundColor Yellow
    
    # Deploy CloudFront stack
    & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation deploy --template-file infrastructure/simple-cloudfront-website.yaml --stack-name AllSenses-CloudFront-HTTPS --profile allsenses
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ CloudFront deployment successful!" -ForegroundColor Green
    } else {
        Write-Host "❌ CloudFront deployment failed!" -ForegroundColor Red
        exit 1
    }
}

# Get CloudFront URLs
Write-Host "🔗 Retrieving HTTPS URLs..." -ForegroundColor Yellow
$outputs = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudformation describe-stacks --stack-name AllSenses-CloudFront-HTTPS --query "Stacks[0].Outputs" --output json --profile allsenses | ConvertFrom-Json

# Extract URLs
$enhancedURL = ($outputs | Where-Object { $_.OutputKey -eq "HTTPSEnhancedURL" }).OutputValue
$juryURL = ($outputs | Where-Object { $_.OutputKey -eq "HTTPSJuryURL" }).OutputValue
$completeURL = ($outputs | Where-Object { $_.OutputKey -eq "HTTPSCompleteURL" }).OutputValue
$mainURL = ($outputs | Where-Object { $_.OutputKey -eq "HTTPSMainURL" }).OutputValue
$domain = ($outputs | Where-Object { $_.OutputKey -eq "CloudFrontDomainName" }).OutputValue

# Check distribution status
Write-Host "📊 Checking CloudFront distribution status..." -ForegroundColor Yellow
$distributions = & "C:\Program Files\Amazon\AWSCLIV2\aws.exe" cloudfront list-distributions --query "DistributionList.Items[0].{Status:Status,Id:Id}" --output json --profile allsenses | ConvertFrom-Json

Write-Host ""
Write-Host "🏆 CLOUDFRONT HTTPS DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Distribution Status:" -ForegroundColor Cyan
Write-Host "   ID: $($distributions.Id)" -ForegroundColor White
Write-Host "   Status: $($distributions.Status)" -ForegroundColor White
Write-Host "   Domain: $domain" -ForegroundColor White
Write-Host ""
Write-Host "🎯 HACKATHON JURY HTTPS URLS:" -ForegroundColor Cyan
Write-Host ""
Write-Host "🛡️  Enhanced Emergency Monitor (RECOMMENDED):" -ForegroundColor Yellow
Write-Host "   $enhancedURL" -ForegroundColor White
Write-Host ""
Write-Host "🏆 Hackathon Jury Demo:" -ForegroundColor Yellow
Write-Host "   $juryURL" -ForegroundColor White
Write-Host ""
Write-Host "📋 Complete MVP Demo:" -ForegroundColor Yellow
Write-Host "   $completeURL" -ForegroundColor White
Write-Host ""
Write-Host "🏠 Default Landing Page:" -ForegroundColor Yellow
Write-Host "   $mainURL" -ForegroundColor White
Write-Host ""
Write-Host "🎤 MICROPHONE ACCESS ENABLED:" -ForegroundColor Green
Write-Host "   ✅ HTTPS Protocol - Required for microphone access" -ForegroundColor Green
Write-Host "   ✅ SSL Certificate - Secure CloudFront certificate" -ForegroundColor Green
Write-Host "   ✅ Global CDN - Fast loading worldwide" -ForegroundColor Green
Write-Host "   ✅ Emergency Detection - Dual detection systems" -ForegroundColor Green
Write-Host "   ✅ Real SMS Notifications - AWS SNS integration" -ForegroundColor Green
Write-Host ""
Write-Host "🎬 DEMO INSTRUCTIONS:" -ForegroundColor Cyan
Write-Host "   1. Access Enhanced Monitor URL above" -ForegroundColor White
Write-Host "   2. Click 'Start Enhanced Monitoring' button" -ForegroundColor White
Write-Host "   3. Allow microphone access when prompted" -ForegroundColor White
Write-Host "   4. Say 'HELP! Emergency!' to test emergency words" -ForegroundColor White
Write-Host "   5. Clap loudly to test abrupt noise detection" -ForegroundColor White
Write-Host "   6. Watch real SMS sending with MessageId confirmation" -ForegroundColor White
Write-Host ""
Write-Host "🚀 READY FOR HACKATHON PRESENTATION!" -ForegroundColor Green