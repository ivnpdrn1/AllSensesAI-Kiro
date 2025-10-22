# Test SMS Direct to Your Phone
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "Testing SMS delivery to your phone..." -ForegroundColor Green

$FUNCTION_URL = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

$testPayload = @{
    action = "JURY_EMERGENCY_ALERT"
    victimName = "Carlos Perez"
    phoneNumber = "<REDACTED_PHONE_NUMBER>"
    detectionType = "emergency_words"
    detectionData = @{
        detectedWords = @("help", "emergency")
    }
    location = @{
        lat = 25.7617
        lon = -80.1918
        placeName = "Miami Convention Center, Miami, FL"
        mapLink = "https://maps.google.com/?q=25.7617,-80.1918"
    }
} | ConvertTo-Json -Depth 3

Write-Host "Sending test SMS with geolocation..." -ForegroundColor Yellow
Write-Host "Phone: <REDACTED_PHONE_NUMBER>" -ForegroundColor Cyan
Write-Host "Victim: Carlos Perez" -ForegroundColor Cyan
Write-Host "Location: Miami Convention Center (25.7617, -80.1918)" -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri $FUNCTION_URL -Method POST -Body $testPayload -ContentType "application/json"
    
    Write-Host ""
    Write-Host "SMS TEST RESULT:" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor White
    Write-Host "SMS Message ID: $($response.smsMessageId)" -ForegroundColor White
    Write-Host "Victim: $($response.victimName)" -ForegroundColor White
    Write-Host "Phone: $($response.emergencyPhone)" -ForegroundColor White
    
    if ($response.smsMessageId) {
        Write-Host ""
        Write-Host "SMS SENT SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "Check your phone for SMS with geolocation" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "Error testing SMS: $_" -ForegroundColor Red
    
    # Try direct AWS SNS test
    Write-Host ""
    Write-Host "Testing direct AWS SNS..." -ForegroundColor Yellow
    
    $smsMessage = "🚨 EMERGENCY ALERT: Carlos Perez is in DANGER! Emergency words detected. Location: Miami Convention Center, FL. View: https://maps.google.com/?q=25.7617,-80.1918 - AllSensesAI Test"
    
    aws sns publish --phone-number "<REDACTED_PHONE_NUMBER>" --message $smsMessage
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Direct SNS test sent!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Expected SMS Format:" -ForegroundColor Yellow
Write-Host "🚨 EMERGENCY ALERT: Carlos Perez is in DANGER!" -ForegroundColor White
Write-Host "Emergency words detected: help, emergency" -ForegroundColor White
Write-Host "Location: Miami Convention Center, FL" -ForegroundColor White
Write-Host "View location: https://maps.google.com/?q=25.7617,-80.1918" -ForegroundColor White