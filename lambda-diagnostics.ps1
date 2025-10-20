# Lambda Function Diagnostics
Write-Host "🔍 LAMBDA FUNCTION DIAGNOSTICS" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"
$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "`n📋 Function Details:" -ForegroundColor Yellow
Write-Host "Function Name: $functionName" -ForegroundColor White
Write-Host "Function URL: $lambdaUrl" -ForegroundColor White

# Test 1: Basic connectivity
Write-Host "`n🧪 Test 1: Basic Lambda Connectivity" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -UseBasicParsing -TimeoutSec 10
    Write-Host "✅ SUCCESS: Lambda is accessible!" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Response: $($response.Content)" -ForegroundColor Cyan
    $lambdaWorking = $true
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "HTTP Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
        Write-Host "Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Yellow
    }
    $lambdaWorking = $false
}

# Test 2: Different HTTP methods
if (-not $lambdaWorking) {
    Write-Host "`n🧪 Test 2: GET Request Test" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri $lambdaUrl -Method GET -UseBasicParsing -TimeoutSec 10
        Write-Host "✅ GET request successful!" -ForegroundColor Green
        Write-Host "Response: $($response.Content)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ GET request failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Check if it's a CORS issue
if (-not $lambdaWorking) {
    Write-Host "`n🧪 Test 3: OPTIONS Request (CORS Check)" -ForegroundColor Yellow
    try {
        $response = Invoke-WebRequest -Uri $lambdaUrl -Method OPTIONS -UseBasicParsing -TimeoutSec 10
        Write-Host "✅ OPTIONS request successful!" -ForegroundColor Green
        Write-Host "Response Headers:" -ForegroundColor Cyan
        $response.Headers | ForEach-Object { Write-Host "  $($_.Key): $($_.Value)" -ForegroundColor Gray }
    } catch {
        Write-Host "❌ OPTIONS request failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Diagnosis and recommendations
Write-Host "`n🔧 DIAGNOSIS & RECOMMENDATIONS" -ForegroundColor Magenta
Write-Host "==============================" -ForegroundColor Magenta

if (-not $lambdaWorking) {
    Write-Host "`n❌ Lambda function is still returning 403 Forbidden" -ForegroundColor Red
    Write-Host "`n🔍 Possible causes:" -ForegroundColor Yellow
    Write-Host "1. AWS permissions still propagating (can take up to 5 minutes)" -ForegroundColor White
    Write-Host "2. Resource-based policy not correctly applied" -ForegroundColor White
    Write-Host "3. Function URL configuration issue" -ForegroundColor White
    Write-Host "4. IAM role permissions for Lambda execution" -ForegroundColor White
    
    Write-Host "`n🛠️ Recommended actions:" -ForegroundColor Cyan
    Write-Host "1. Wait 2-3 more minutes for AWS propagation" -ForegroundColor White
    Write-Host "2. Check Lambda function permissions in AWS Console" -ForegroundColor White
    Write-Host "3. Verify Function URL auth type is set to NONE" -ForegroundColor White
    Write-Host "4. Check if resource-based policy was correctly added" -ForegroundColor White
    
    Write-Host "`n📞 Alternative approaches:" -ForegroundColor Green
    Write-Host "1. Use AWS Console to manually test the function" -ForegroundColor White
    Write-Host "2. Check CloudWatch logs for error details" -ForegroundColor White
    Write-Host "3. Verify SNS permissions for SMS sending" -ForegroundColor White
} else {
    Write-Host "`n✅ Lambda function is working correctly!" -ForegroundColor Green
    Write-Host "The Enhanced Emergency Monitor should now work properly." -ForegroundColor Green
}

Write-Host "`n⏰ Current time: $(Get-Date)" -ForegroundColor Gray
Write-Host "If permissions were just added, wait 2-5 minutes for full propagation." -ForegroundColor Gray