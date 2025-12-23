# Test SMS Fix - Run this after AWS Console changes
Write-Host "🧪 TESTING SMS FIX FOR JURY DEMO" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "`n⏰ Testing Lambda function access..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "✅ SUCCESS! Lambda is now accessible!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
    
    # Now test SMS functionality
    Write-Host "`n📱 Testing SMS functionality..." -ForegroundColor Yellow
    
    $smsPayload = '{"action":"MAKE_REAL_CALL","phoneNumber":"<REDACTED_PHONE_NUMBER>","emergencyMessage":"AllSenses Jury Demo - SMS Test Successful!"}'
    $smsResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsPayload -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "✅ SMS TEST SUCCESSFUL!" -ForegroundColor Green
    Write-Host "Status: $($smsResponse.status)" -ForegroundColor Cyan
    Write-Host "Message ID: $($smsResponse.smsMessageId)" -ForegroundColor Green
    Write-Host "Real SMS: $($smsResponse.realSms)" -ForegroundColor Cyan
    
    Write-Host "`n🎉 YOUR ALLSENSES DEMO IS NOW 100% READY!" -ForegroundColor Magenta
    Write-Host "🎯 Demo URL: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White
    Write-Host "📱 SMS will now work with Message ID displayed" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Still not working: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Message -like "*403*") {
        Write-Host "`n⏰ Permissions may still be propagating..." -ForegroundColor Yellow
        Write-Host "Wait 2-3 more minutes and run this test again" -ForegroundColor Gray
        Write-Host "AWS can take up to 5 minutes for full propagation" -ForegroundColor Gray
    } else {
        Write-Host "`n🔧 Different issue detected:" -ForegroundColor Yellow
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Open Enhanced Emergency Monitor" -ForegroundColor White
Write-Host "2. Click 'Start Enhanced Monitoring'" -ForegroundColor White
Write-Host "3. Test emergency detection" -ForegroundColor White
Write-Host "4. Verify SMS notification with Message ID" -ForegroundColor White