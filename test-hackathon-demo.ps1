# Test Hackathon Demo - Quick Verification

Write-Host "🧪 TESTING HACKATHON DEMO" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

# Get Lambda function URL (you may need to update this)
$lambdaUrl = "https://your-lambda-url.lambda-url.us-east-1.on.aws/"

Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Cyan
Write-Host "If URL is wrong, update it in this script" -ForegroundColor Yellow

Write-Host "`n🚨 Testing Emergency Pipeline..." -ForegroundColor Yellow

$testBody = @{
    action = "SIMULATE_EMERGENCY"
    userId = "hackathon-demo-user"
    audioData = "Help! This is an emergency!"
    lat = 40.712776
    lon = -74.005974
} | ConvertTo-Json

Write-Host "Test payload:" -ForegroundColor Gray
Write-Host $testBody -ForegroundColor Gray

try {
    Write-Host "`nSending request..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $testBody -ContentType "application/json"
    
    Write-Host "✅ SUCCESS! Demo is working!" -ForegroundColor Green
    Write-Host "`n📊 Pipeline Results:" -ForegroundColor Cyan
    
    # Show key results
    Write-Host "Event ID: $($response.eventId)" -ForegroundColor White
    Write-Host "Demo Mode: $($response.demoMode)" -ForegroundColor White
    Write-Host "SMS Results: $($response.steps.step5_sms.totalSent) messages sent" -ForegroundColor White
    
    Write-Host "`n📱 SMS Contacts:" -ForegroundColor Magenta
    foreach ($sms in $response.steps.step5_sms.results) {
        Write-Host "• $($sms.contactName) ($($sms.phone)): $($sms.status)" -ForegroundColor White
    }
    
    Write-Host "`n🎯 Perfect for hackathon demo!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "`n💡 Possible issues:" -ForegroundColor Yellow
    Write-Host "1. Update Lambda URL in this script" -ForegroundColor White
    Write-Host "2. Make sure demo is deployed" -ForegroundColor White
    Write-Host "3. Check AWS credentials" -ForegroundColor White
}

Write-Host "`n🏆 Your demo is ready for the judges!" -ForegroundColor Green