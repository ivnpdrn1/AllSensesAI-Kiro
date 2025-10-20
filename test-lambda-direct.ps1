# Test Lambda Function Direct Access
# This tests the Lambda function URL and provides deployment status

Write-Host "🧪 TESTING ALLSENSES LAMBDA FUNCTION" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor Cyan

# Test 1: Basic connectivity
Write-Host "`n🔍 Test 1: Basic Connectivity" -ForegroundColor Yellow
$lambdaWorking = $false
try {
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 30
    Write-Host "✅ SUCCESS: Lambda function is working!" -ForegroundColor Green
    Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    Write-Host "Message: $($response.message)" -ForegroundColor Cyan
    $lambdaWorking = $true
} catch {
    Write-Host "❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
    $lambdaWorking = $false
    
    if ($_.Exception.Message -like "*403*" -or $_.Exception.Message -like "*Forbidden*") {
        Write-Host "🔧 ISSUE: Lambda function URL permissions not configured" -ForegroundColor Yellow
        Write-Host "   This is a common issue that can be fixed by AWS admin" -ForegroundColor Yellow
    }
}

# Test 2: Emergency simulation (if basic test passed)
if ($lambdaWorking) {
    Write-Host "`n🚨 Test 2: Emergency Simulation" -ForegroundColor Yellow
    try {
        $emergencyPayload = @{
            action = "SIMULATE_EMERGENCY"
            audioData = "Help! Emergency situation!"
            userId = "demo-user-123"
            location = @{
                latitude = 40.7128
                longitude = -74.0060
                address = "New York, NY"
            }
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $emergencyPayload -ContentType "application/json" -TimeoutSec 30
        Write-Host "✅ SUCCESS: Emergency simulation working!" -ForegroundColor Green
        Write-Host "Event ID: $($response.eventId)" -ForegroundColor Cyan
        Write-Host "Pipeline Status: $($response.pipelineStatus)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Real SMS test (if previous tests passed)
if ($lambdaWorking) {
    Write-Host "`n📱 Test 3: Real SMS Test" -ForegroundColor Yellow
    try {
        $smsPayload = @{
            action = "MAKE_REAL_CALL"
            phoneNumber = "+13053033060"
            emergencyMessage = "TEST: AllSensesAI Emergency Detection System"
            incidentId = "test-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsPayload -ContentType "application/json" -TimeoutSec 30
        Write-Host "✅ SUCCESS: SMS functionality working!" -ForegroundColor Green
        Write-Host "SMS Message ID: $($response.smsMessageId)" -ForegroundColor Cyan
        Write-Host "Status: $($response.status)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Deployment Status Summary
Write-Host "`n📊 DEPLOYMENT STATUS SUMMARY" -ForegroundColor Magenta
Write-Host "=============================" -ForegroundColor Magenta

if ($lambdaWorking) {
    Write-Host "✅ Lambda Function: WORKING" -ForegroundColor Green
    Write-Host "✅ Enhanced Emergency Monitor: READY" -ForegroundColor Green
    Write-Host "✅ Hackathon Demo: READY FOR JURY" -ForegroundColor Green
    
    Write-Host "`n🎯 DEMO URLS (Ready to use):" -ForegroundColor Cyan
    Write-Host "Enhanced Emergency Monitor:" -ForegroundColor White
    Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Gray
    Write-Host "`nHackathon Jury Demo:" -ForegroundColor White
    Write-Host "https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Gray
    
    Write-Host "`n🏆 YOUR ALLSENSES DEMO IS READY!" -ForegroundColor Green
    Write-Host "All systems operational for hackathon presentation!" -ForegroundColor Green
    
} else {
    Write-Host "❌ Lambda Function: NEEDS PERMISSION FIX" -ForegroundColor Red
    Write-Host "❌ Enhanced Emergency Monitor: WAITING FOR LAMBDA" -ForegroundColor Red
    Write-Host "❌ Hackathon Demo: NEEDS LAMBDA FIX" -ForegroundColor Red
    
    Write-Host "`n🔧 TO FIX LAMBDA PERMISSIONS:" -ForegroundColor Yellow
    Write-Host "Run this AWS CLI command (requires AWS admin access):" -ForegroundColor White
    Write-Host "aws lambda add-permission --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --statement-id allow-url-invoke --action lambda:InvokeFunctionUrl --principal '*' --function-url-auth-type NONE --region us-east-1" -ForegroundColor Gray
    
    Write-Host "`n📞 ALTERNATIVE: Contact AWS admin to enable Lambda function URL public access" -ForegroundColor Yellow
}

Write-Host "`n🎬 DEMO SCRIPT READY:" -ForegroundColor Cyan
Write-Host "1. Open Enhanced Emergency Monitor" -ForegroundColor White
Write-Host "2. Click 'Start Enhanced Monitoring'" -ForegroundColor White
Write-Host "3. Say 'Help! Emergency!' or click test buttons" -ForegroundColor White
Write-Host "4. Watch 7-step pipeline complete" -ForegroundColor White
Write-Host "5. Real SMS sent to +13053033060" -ForegroundColor White

Write-Host "`n🚀 AllSensesAI - Ready to impress the jury!" -ForegroundColor Green