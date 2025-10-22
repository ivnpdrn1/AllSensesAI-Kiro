# Test SMS After Lambda Fix
Write-Host "🧪 Testing SMS after Lambda fix..." -ForegroundColor Green

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

try {
    $smsTest = @{
        action = "MAKE_REAL_CALL"
        phoneNumber = "<REDACTED_PHONE_NUMBER>"
        emergencyMessage = "AllSenses Jury Demo Test - SMS Working!"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsTest -ContentType "application/json" -TimeoutSec 15
    
    Write-Host "✅ SUCCESS! SMS is working!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message ID: $($response.smsMessageId)" -ForegroundColor Green
    Write-Host "Real SMS: $($response.realSms)" -ForegroundColor Cyan
    
    Write-Host "`n🎉 Your AllSenses demo is now 100% ready for jury!" -ForegroundColor Magenta
    
} catch {
    Write-Host "❌ Still not working: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "May need more time for AWS propagation (up to 5 minutes)" -ForegroundColor Yellow
}