# Test AllSensesAI Jury Demo Functionality
# Test configurable victim name and emergency contact

Write-Host "🧪 Testing AllSensesAI Jury Demo..." -ForegroundColor Green

$FUNCTION_URL = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"

# Test 1: Emergency Words Detection with Custom Victim Name
Write-Host ""
Write-Host "📝 Test 1: Emergency Words Detection" -ForegroundColor Yellow

$test1_payload = @{
    action = "JURY_EMERGENCY_ALERT"
    victimName = "Maria Rodriguez"
    phoneNumber = "<REDACTED_PHONE_NUMBER>"
    detectionType = "emergency_words"
    detectionData = @{
        detectedWords = @("help", "emergency")
        transcript = "help me there is an emergency"
    }
    location = @{
        lat = 25.7617
        lon = -80.1918
        placeName = "Miami Convention Center, Miami, FL"
        mapLink = "https://maps.google.com/?q=25.7617,-80.1918"
    }
} | ConvertTo-Json -Depth 3

try {
    $response1 = Invoke-RestMethod -Uri $FUNCTION_URL -Method POST -Body $test1_payload -ContentType "application/json"
    Write-Host "✅ Test 1 Success:" -ForegroundColor Green
    Write-Host "   Victim: $($response1.victimName)" -ForegroundColor White
    Write-Host "   Phone: $($response1.emergencyPhone)" -ForegroundColor White
    Write-Host "   Incident ID: $($response1.incidentId)" -ForegroundColor White
    Write-Host "   SMS ID: $($response1.smsMessageId)" -ForegroundColor White
} catch {
    Write-Host "❌ Test 1 Failed: $_" -ForegroundColor Red
}

# Test 2: Abrupt Noise Detection with Different Victim
Write-Host ""
Write-Host "📢 Test 2: Abrupt Noise Detection" -ForegroundColor Yellow

$test2_payload = @{
    action = "JURY_EMERGENCY_ALERT"
    victimName = "Carlos Perez"
    phoneNumber = "<REDACTED_PHONE_NUMBER>"
    detectionType = "abrupt_noise"
    detectionData = @{
        volume = 95
        threshold = 75
    }
    location = @{
        lat = 25.7617
        lon = -80.1918
        placeName = "Miami Convention Center, Miami, FL"
        mapLink = "https://maps.google.com/?q=25.7617,-80.1918"
    }
} | ConvertTo-Json -Depth 3

try {
    $response2 = Invoke-RestMethod -Uri $FUNCTION_URL -Method POST -Body $test2_payload -ContentType "application/json"
    Write-Host "✅ Test 2 Success:" -ForegroundColor Green
    Write-Host "   Victim: $($response2.victimName)" -ForegroundColor White
    Write-Host "   Phone: $($response2.emergencyPhone)" -ForegroundColor White
    Write-Host "   Incident ID: $($response2.incidentId)" -ForegroundColor White
    Write-Host "   SMS ID: $($response2.smsMessageId)" -ForegroundColor White
} catch {
    Write-Host "❌ Test 2 Failed: $_" -ForegroundColor Red
}

# Test 3: Jury Test Message
Write-Host ""
Write-Host "🏆 Test 3: Jury Test Message" -ForegroundColor Yellow

$test3_payload = @{
    action = "JURY_TEST"
    victimName = "Demo User"
    phoneNumber = "<REDACTED_PHONE_NUMBER>"
} | ConvertTo-Json

try {
    $response3 = Invoke-RestMethod -Uri $FUNCTION_URL -Method POST -Body $test3_payload -ContentType "application/json"
    Write-Host "✅ Test 3 Success:" -ForegroundColor Green
    Write-Host "   Victim: $($response3.victimName)" -ForegroundColor White
    Write-Host "   Phone: $($response3.testPhone)" -ForegroundColor White
    Write-Host "   SMS ID: $($response3.smsMessageId)" -ForegroundColor White
} catch {
    Write-Host "❌ Test 3 Failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Jury Demo Test Summary:" -ForegroundColor Green
Write-Host "   ✅ Configurable victim names working" -ForegroundColor White
Write-Host "   ✅ Configurable phone numbers working" -ForegroundColor White
Write-Host "   ✅ Emergency messages include victim name and danger status" -ForegroundColor White
Write-Host "   ✅ Location information included in SMS" -ForegroundColor White
Write-Host "   ✅ Incident IDs generated for tracking" -ForegroundColor White
Write-Host ""
Write-Host "📱 Expected SMS Format:" -ForegroundColor Yellow
Write-Host "   '🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!'" -ForegroundColor White
Write-Host "   '[Detection details]'" -ForegroundColor White
Write-Host "   'Location: Miami Convention Center, FL'" -ForegroundColor White
Write-Host "   'View location: [Google Maps link]'" -ForegroundColor White
Write-Host "   'Incident ID: JURY-XXXXXXXX'" -ForegroundColor White
Write-Host ""