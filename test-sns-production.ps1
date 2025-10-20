# Test SNS Production Status and New Lambda Features

Write-Host "🧪 Testing AllSensesAI Production Features" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Get Lambda function URL
$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

Write-Host "`n🔍 Getting Lambda function URL..." -ForegroundColor Yellow
try {
    $urlResponse = aws lambda get-function-url-config --function-name $functionName --query 'FunctionUrl' --output text
    $lambdaUrl = $urlResponse.Trim()
    Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Could not get Lambda URL" -ForegroundColor Red
    exit 1
}

Write-Host "`n📊 1. Checking SNS Status via Lambda..." -ForegroundColor Yellow
$snsStatusBody = @{
    action = "CHECK_SNS_STATUS"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $snsStatusBody -ContentType "application/json"
    Write-Host "SNS Status Response:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 3
} catch {
    Write-Host "❌ SNS status check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🚨 2. Testing Emergency Pipeline..." -ForegroundColor Yellow
$emergencyBody = @{
    action = "SIMULATE_EMERGENCY"
    userId = "test-user-123"
    audioData = "Help! Emergency situation!"
    lat = 40.712776
    lon = -74.005974
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $emergencyBody -ContentType "application/json"
    Write-Host "Emergency Pipeline Response:" -ForegroundColor Green
    $response.steps.step5_sms | ConvertTo-Json -Depth 3
} catch {
    Write-Host "❌ Emergency test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📱 3. Direct SMS Test..." -ForegroundColor Yellow
$phoneNumber = Read-Host "Enter phone number to test (+1234567890)"
if ($phoneNumber) {
    $smsBody = @{
        action = "MAKE_REAL_CALL"
        phoneNumber = $phoneNumber
        emergencyMessage = "Production test from AllSensesAI"
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsBody -ContentType "application/json"
        Write-Host "SMS Test Response:" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 2
    } catch {
        Write-Host "❌ SMS test failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n✅ Testing Complete!" -ForegroundColor Green