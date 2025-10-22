# Quick Phone Verification for Hackathon Demo
# Verify your phone number immediately for real SMS testing

param(
    [Parameter(Mandatory=$true)]
    [string]$PhoneNumber,
    [string]$VerificationCode = ""
)

Write-Host "📱 Quick Phone Verification for Hackathon" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

if ($VerificationCode -eq "") {
    # Start verification
    Write-Host "`n🚀 Starting verification for: $PhoneNumber" -ForegroundColor Yellow
    Write-Host "Make sure to use international format: +1234567890" -ForegroundColor Gray
    
    try {
        Write-Host "`nSending verification SMS..." -ForegroundColor Cyan
        aws sns create-sms-sandbox-phone-number --phone-number $PhoneNumber --region us-east-1
        
        Write-Host "✅ Verification SMS sent to $PhoneNumber" -ForegroundColor Green
        Write-Host "`n📨 Check your phone for the verification code" -ForegroundColor Cyan
        Write-Host "`n🔄 Complete verification with:" -ForegroundColor Yellow
        Write-Host ".\quick-phone-verify.ps1 -PhoneNumber '$PhoneNumber' -VerificationCode 'YOUR_CODE'" -ForegroundColor Gray
        
    } catch {
        Write-Host "❌ Verification failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n💡 Possible solutions:" -ForegroundColor Yellow
        Write-Host "1. Check phone number format (+1234567890)" -ForegroundColor White
        Write-Host "2. Ensure AWS credentials are configured" -ForegroundColor White
        Write-Host "3. Try a different phone number" -ForegroundColor White
    }
} else {
    # Complete verification
    Write-Host "`n🔐 Completing verification for: $PhoneNumber" -ForegroundColor Yellow
    Write-Host "Using verification code: $VerificationCode" -ForegroundColor Gray
    
    try {
        aws sns verify-sms-sandbox-phone-number --phone-number $PhoneNumber --one-time-password $VerificationCode --region us-east-1
        
        Write-Host "✅ Phone number $PhoneNumber verified successfully!" -ForegroundColor Green
        
        Write-Host "`n📱 Testing SMS to verified number..." -ForegroundColor Cyan
        
        # Test SMS immediately
        $testMessage = "🚨 AllSensesAI Test - Your phone is verified and ready for emergency alerts! Time: $(Get-Date -Format 'HH:mm:ss')"
        
        try {
            $smsResult = aws sns publish --phone-number $PhoneNumber --message $testMessage --region us-east-1 | ConvertFrom-Json
            Write-Host "✅ Test SMS sent successfully!" -ForegroundColor Green
            Write-Host "Message ID: $($smsResult.MessageId)" -ForegroundColor Cyan
            Write-Host "`n📱 Check your phone for the test message!" -ForegroundColor Yellow
            
        } catch {
            Write-Host "⚠️ SMS test failed, but number is verified" -ForegroundColor Yellow
        }
        
        Write-Host "`n🎯 Your phone is ready for hackathon demo!" -ForegroundColor Green
        Write-Host "Update your Lambda function to use real SMS now." -ForegroundColor White
        
    } catch {
        Write-Host "❌ Verification failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "`n💡 Check the verification code and try again" -ForegroundColor Yellow
    }
}

Write-Host "`n📋 Verified Numbers:" -ForegroundColor Cyan
try {
    aws sns list-sms-sandbox-phone-numbers --region us-east-1
} catch {
    Write-Host "Could not list verified numbers" -ForegroundColor Yellow
}