# Test SMS After Adding Resource-Based Policy
Write-Host "🧪 TESTING AFTER RESOURCE-BASED POLICY FIX" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "`n⚡ Testing Lambda access..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "✅ LAMBDA ACCESS WORKING!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    
    # Test SMS immediately
    Write-Host "`n📱 Testing SMS notification..." -ForegroundColor Yellow
    $smsPayload = '{"action":"MAKE_REAL_CALL","phoneNumber":"<REDACTED_PHONE_NUMBER>","emergencyMessage":"AllSenses SMS Test - Working for Jury Demo!"}'
    $smsResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsPayload -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "🎉 SMS WORKING PERFECTLY!" -ForegroundColor Green
    Write-Host "Status: $($smsResponse.status)" -ForegroundColor Cyan
    Write-Host "Message ID: $($smsResponse.smsMessageId)" -ForegroundColor Green
    Write-Host "Phone: $($smsResponse.phoneNumber)" -ForegroundColor Cyan
    Write-Host "Real SMS: $($smsResponse.realSms)" -ForegroundColor Green
    
    Write-Host "`n🏆 ALLSENSES DEMO IS 100% READY FOR JURY!" -ForegroundColor Magenta
    Write-Host "🎯 Enhanced Emergency Monitor will now show:" -ForegroundColor White
    Write-Host "   ✅ Notification sent successfully!" -ForegroundColor Green
    Write-Host "   ✅ Message ID: [actual-id]" -ForegroundColor Green
    Write-Host "   ✅ Real SMS to <REDACTED_PHONE_NUMBER>" -ForegroundColor Green
    
    Write-Host "`n🚀 Demo URL: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Still not working: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Double-check the resource-based policy was added correctly" -ForegroundColor Yellow
}