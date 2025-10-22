# Deploy Production-Ready AllSensesAI Lambda Function
# This version handles both SNS sandbox and production modes

Write-Host "Deploying Production-Ready AllSensesAI Lambda" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Check if production-ready file exists
if (-not (Test-Path "allsenseai-production-ready.py")) {
    Write-Host "allsenseai-production-ready.py not found!" -ForegroundColor Red
    exit 1
}

# Get Lambda function name
$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

Write-Host "Creating deployment package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-production-ready.py" -DestinationPath "allsenseai-production.zip" -Force

Write-Host "Updating Lambda function..." -ForegroundColor Yellow
try {
    aws lambda update-function-code --function-name $functionName --zip-file fileb://allsenseai-production.zip
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Lambda function updated successfully!" -ForegroundColor Green
        
        Write-Host "Checking SNS sandbox status..." -ForegroundColor Yellow
        aws sns get-sms-sandbox-account-status --region us-east-1
        
        Write-Host "To verify phone numbers in sandbox mode:" -ForegroundColor Cyan
        Write-Host "aws sns create-sms-sandbox-phone-number --phone-number +1234567890" -ForegroundColor Gray
        
        Write-Host "To request production access:" -ForegroundColor Cyan
        Write-Host "Run: .\scripts\request-sns-production-access.ps1" -ForegroundColor Gray
        
        Write-Host "Test the new functionality:" -ForegroundColor Yellow
        Write-Host "POST to Lambda with action: 'CHECK_SNS_STATUS'" -ForegroundColor Gray
        
    } else {
        Write-Host "Lambda update failed!" -ForegroundColor Red
    }
} catch {
    Write-Host "Error updating Lambda: $($_.Exception.Message)" -ForegroundColor Red
}

# Clean up
Remove-Item "allsenseai-production.zip" -ErrorAction SilentlyContinue

Write-Host "Key Improvements in Production Version:" -ForegroundColor Green
Write-Host "- Automatic sandbox/production mode detection" -ForegroundColor White
Write-Host "- Graceful handling of unverified numbers" -ForegroundColor White
Write-Host "- Better error messages and suggestions" -ForegroundColor White
Write-Host "- SNS status checking endpoint" -ForegroundColor White
Write-Host "- Phone number verification helpers" -ForegroundColor White