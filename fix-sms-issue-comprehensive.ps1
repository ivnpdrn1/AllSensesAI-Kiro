# Comprehensive SMS Issue Fix for AllSenses AI Guardian
# This script addresses multiple potential causes of SMS notification failure

Write-Host "🚨 COMPREHENSIVE SMS FIX - AllSenses AI Guardian" -ForegroundColor Red
Write-Host "=================================================" -ForegroundColor Red

$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"
$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"
$juryPhone = "<REDACTED_PHONE_NUMBER>"

Write-Host "`n📋 System Information:" -ForegroundColor Cyan
Write-Host "Lambda Function: $functionName" -ForegroundColor White
Write-Host "Function URL: $lambdaUrl" -ForegroundColor White
Write-Host "Target Phone: $juryPhone" -ForegroundColor White

# Step 1: Test current Lambda status
Write-Host "`n🧪 Step 1: Testing current Lambda status..." -ForegroundColor Yellow
try {
    $testPayload = '{"action":"JURY_DEMO_TEST"}'
    $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $testPayload -ContentType "application/json" -TimeoutSec 10
    Write-Host "✅ SUCCESS: Lambda is working!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Cyan
    $lambdaWorking = $true
} catch {
    Write-Host "❌ Lambda not accessible: $($_.Exception.Message)" -ForegroundColor Red
    $lambdaWorking = $false
    
    if ($_.Exception.Message -like "*403*") {
        Write-Host "🔧 Diagnosis: Lambda function URL permissions issue" -ForegroundColor Yellow
        Write-Host "   This is the root cause of SMS failure" -ForegroundColor Yellow
    }
}

# Step 2: If Lambda is working, test SMS directly
if ($lambdaWorking) {
    Write-Host "`n📱 Step 2: Testing SMS functionality..." -ForegroundColor Yellow
    try {
        $smsPayload = @{
            action = "MAKE_REAL_CALL"
            phoneNumber = $juryPhone
            emergencyMessage = "AllSenses SMS Test - $(Get-Date -Format 'HH:mm:ss')"
        } | ConvertTo-Json
        
        $smsResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $smsPayload -ContentType "application/json" -TimeoutSec 15
        
        Write-Host "✅ SMS Test Response:" -ForegroundColor Green
        Write-Host "Status: $($smsResponse.status)" -ForegroundColor Cyan
        Write-Host "Message ID: $($smsResponse.smsMessageId)" -ForegroundColor Cyan
        Write-Host "Real SMS: $($smsResponse.realSms)" -ForegroundColor Cyan
        
        if ($smsResponse.smsMessageId) {
            Write-Host "🎉 SMS FUNCTIONALITY IS WORKING!" -ForegroundColor Green
            Write-Host "The Enhanced Emergency Monitor should now work correctly." -ForegroundColor Green
        } else {
            Write-Host "⚠️ SMS response received but no Message ID" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "❌ SMS test failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "`n🔧 Step 2: Lambda permission fixes needed..." -ForegroundColor Yellow
    
    # Check if AWS CLI is available
    Write-Host "Checking for AWS CLI..." -ForegroundColor Cyan
    try {
        $awsVersion = & "C:\Program Files\Git\bin\git.exe" --version 2>$null
        Write-Host "Git found, checking AWS CLI paths..." -ForegroundColor Green
        
        # Try different AWS CLI locations
        $awsPaths = @(
            "aws",
            "C:\Program Files\Amazon\AWSCLIV2\aws.exe",
            "C:\Program Files (x86)\Amazon\AWSCLIV2\aws.exe"
        )
        
        $awsFound = $false
        foreach ($awsPath in $awsPaths) {
            try {
                $awsTest = & $awsPath --version 2>$null
                if ($awsTest) {
                    Write-Host "✅ AWS CLI found at: $awsPath" -ForegroundColor Green
                    $awsCommand = $awsPath
                    $awsFound = $true
                    break
                }
            } catch {
                # Continue to next path
            }
        }
        
        if ($awsFound) {
            Write-Host "`n🚀 Attempting to fix Lambda permissions..." -ForegroundColor Green
            
            # Try to add permission with different statement ID
            $permissionCommand = "$awsCommand lambda add-permission --function-name $functionName --statement-id allow-public-invoke-$(Get-Date -Format 'yyyyMMddHHmmss') --action lambda:InvokeFunctionUrl --principal `"*`" --function-url-auth-type NONE --region us-east-1"
            
            Write-Host "Running: $permissionCommand" -ForegroundColor White
            
            try {
                $permResult = Invoke-Expression $permissionCommand
                Write-Host "✅ Permission added successfully!" -ForegroundColor Green
                Write-Host "Result: $permResult" -ForegroundColor Cyan
                
                Write-Host "`n⏰ Waiting 30 seconds for propagation..." -ForegroundColor Yellow
                Start-Sleep -Seconds 30
                
                # Test again
                Write-Host "Testing Lambda after permission fix..." -ForegroundColor Cyan
                try {
                    $retestResponse = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body '{"action":"JURY_DEMO_TEST"}' -ContentType "application/json" -TimeoutSec 15
                    Write-Host "🎉 SUCCESS! Lambda is now working!" -ForegroundColor Green
                    Write-Host "Status: $($retestResponse.status)" -ForegroundColor Cyan
                } catch {
                    Write-Host "Still propagating: $($_.Exception.Message)" -ForegroundColor Yellow
                    Write-Host "May need 2-5 more minutes for full propagation" -ForegroundColor Gray
                }
                
            } catch {
                Write-Host "Permission command failed: $($_.Exception.Message)" -ForegroundColor Red
                if ($_.Exception.Message -like "*already exists*") {
                    Write-Host "Permission may already exist, checking propagation..." -ForegroundColor Yellow
                }
            }
            
        } else {
            Write-Host "❌ AWS CLI not found" -ForegroundColor Red
            Write-Host "Manual fix required via AWS Console" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "Error checking AWS CLI: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 3: Provide manual fix instructions
Write-Host "`n📋 MANUAL FIX INSTRUCTIONS (if needed):" -ForegroundColor Magenta
Write-Host "=======================================" -ForegroundColor Magenta

Write-Host "`n🔧 AWS Console Fix:" -ForegroundColor Cyan
Write-Host "1. Go to AWS Lambda Console" -ForegroundColor White
Write-Host "2. Open function: $functionName" -ForegroundColor White
Write-Host "3. Go to Configuration → Function URL" -ForegroundColor White
Write-Host "4. Click Edit" -ForegroundColor White
Write-Host "5. Set Auth type to NONE" -ForegroundColor White
Write-Host "6. Save changes" -ForegroundColor White
Write-Host "7. Wait 2-5 minutes for propagation" -ForegroundColor White

Write-Host "`n📱 Expected Result:" -ForegroundColor Green
Write-Host "- Enhanced Emergency Monitor will show 'Notification sent successfully'" -ForegroundColor White
Write-Host "- SMS Message ID will be displayed" -ForegroundColor White
Write-Host "- Real SMS will be sent to $juryPhone" -ForegroundColor White

Write-Host "`n🎯 Demo URLs (will work after fix):" -ForegroundColor Cyan
Write-Host "Enhanced Emergency Monitor:" -ForegroundColor White
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Gray

Write-Host "`n⏰ Current Time: $(Get-Date)" -ForegroundColor Gray
Write-Host "If permissions were just added, they may take 2-5 minutes to propagate." -ForegroundColor Gray

Write-Host "`n🏆 ONCE FIXED: Your AllSenses demo will be 100% ready for jury presentation!" -ForegroundColor Green