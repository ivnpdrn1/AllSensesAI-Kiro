# SMS Delivery Verification and Fix
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "🔍 SMS Delivery Verification for <REDACTED_PHONE_NUMBER>" -ForegroundColor Green
Write-Host ""

# 1. Check SMS Sandbox Status
Write-Host "1. Checking SMS Sandbox Status..." -ForegroundColor Yellow
try {
    $smsAttributes = aws sns get-sms-attributes --output json | ConvertFrom-Json
    Write-Host "SMS Attributes:" -ForegroundColor Cyan
    $smsAttributes.attributes | Format-Table
} catch {
    Write-Host "⚠️ Cannot access SMS attributes (likely permissions issue)" -ForegroundColor Yellow
}

# 2. Check Account SMS Settings
Write-Host "2. Checking Account SMS Settings..." -ForegroundColor Yellow
try {
    aws sns get-account-attributes --output json
} catch {
    Write-Host "⚠️ Cannot access account attributes" -ForegroundColor Yellow
}

# 3. List Verified Phone Numbers (if in sandbox)
Write-Host "3. Checking Verified Phone Numbers..." -ForegroundColor Yellow
try {
    aws sns list-phone-numbers-opted-out --output json
} catch {
    Write-Host "⚠️ Cannot list phone numbers" -ForegroundColor Yellow
}

# 4. Check CloudWatch Logs for SNS
Write-Host "4. Checking Recent CloudWatch Logs..." -ForegroundColor Yellow
try {
    aws logs describe-log-groups --log-group-name-prefix "/aws/sns" --output json
} catch {
    Write-Host "⚠️ No SNS CloudWatch logs found" -ForegroundColor Yellow
}

# 5. Verify Phone Number in Sandbox
Write-Host "5. Attempting to Verify Phone Number..." -ForegroundColor Yellow
try {
    aws sns opt-in-phone-number --phone-number "<REDACTED_PHONE_NUMBER>"
    Write-Host "✅ Phone number opt-in attempted" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Phone number opt-in failed: $_" -ForegroundColor Red
}

# 6. Send Test SMS with Detailed Logging
Write-Host "6. Sending Test SMS with Full Logging..." -ForegroundColor Yellow
$testMessage = "🚨 EMERGENCY ALERT: Carlos Perez is in DANGER! Emergency detected. Location: Miami Convention Center, FL. View: https://maps.google.com/?q=25.7617,-80.1918 - AllSensesAI Jury Test $(Get-Date -Format 'HH:mm:ss')"

try {
    $result = aws sns publish --phone-number "<REDACTED_PHONE_NUMBER>" --message $testMessage --output json | ConvertFrom-Json
    Write-Host "✅ SMS Publish Result:" -ForegroundColor Green
    Write-Host "MessageId: $($result.MessageId)" -ForegroundColor White
    
    # Wait and check delivery status
    Write-Host "⏳ Waiting 30 seconds to check delivery..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    # Try to get message attributes (if available)
    try {
        aws sns get-sms-attributes --output json
    } catch {
        Write-Host "Cannot check delivery status directly" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "❌ SMS Publish Failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🔧 LIKELY ISSUE: AWS SNS SANDBOX MODE" -ForegroundColor Red
Write-Host ""
Write-Host "📋 Sandbox Mode Restrictions:" -ForegroundColor Yellow
Write-Host "- Only verified phone numbers can receive SMS" -ForegroundColor White
Write-Host "- Phone numbers must be manually verified in SNS console" -ForegroundColor White
Write-Host "- MessageId is returned but SMS is not delivered" -ForegroundColor White
Write-Host ""
Write-Host "🔧 SOLUTIONS:" -ForegroundColor Green
Write-Host "1. Verify <REDACTED_PHONE_NUMBER> in AWS SNS Console" -ForegroundColor White
Write-Host "2. Request production access for SNS SMS" -ForegroundColor White
Write-Host "3. Use a different verified phone number" -ForegroundColor White
Write-Host ""
Write-Host "🌐 AWS SNS Console URL:" -ForegroundColor Cyan
Write-Host "https://console.aws.amazon.com/sns/v3/home?region=us-east-1#/mobile/text-messaging" -ForegroundColor White