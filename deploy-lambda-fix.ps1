# Deploy Lambda Permission Fix
# This script fixes the 403 Forbidden error on the Lambda function URL

Write-Host "🔧 FIXING ALLSENSES LAMBDA PERMISSIONS" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

$stackName = "AllSenses-Lambda-Permission-Fix"
$templateFile = "fix-lambda-permissions.yaml"
$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "`n📋 Deployment Details:" -ForegroundColor Cyan
Write-Host "Stack Name: $stackName" -ForegroundColor White
Write-Host "Template: $templateFile" -ForegroundColor White
Write-Host "Lambda URL: $lambdaUrl" -ForegroundColor White

# Check if AWS CLI is available
Write-Host "`n🔍 Checking AWS CLI..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>&1
    Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
    
    # Deploy the fix
    Write-Host "`n🚀 Deploying permission fix..." -ForegroundColor Yellow
    $deployResult = aws cloudformation deploy --template-file $templateFile --stack-name $stackName --region us-east-1 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ SUCCESS: Lambda permissions fixed!" -ForegroundColor Green
        
        # Test the Lambda function
        Write-Host "`n🧪 Testing Lambda function..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5  # Wait for permissions to propagate
        
        try {
            $testPayload = '{"action":"JURY_DEMO_TEST"}'
            $response = Invoke-RestMethod -Uri $lambdaUrl -Method POST -Body $testPayload -ContentType "application/json" -TimeoutSec 15
            
            Write-Host "✅ SUCCESS: Lambda function is now working!" -ForegroundColor Green
            Write-Host "Status: $($response.status)" -ForegroundColor Cyan
            Write-Host "Message: $($response.message)" -ForegroundColor Cyan
            
            Write-Host "`n🎯 DEMO URLS NOW READY:" -ForegroundColor Magenta
            Write-Host "Enhanced Emergency Monitor:" -ForegroundColor White
            Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Gray
            Write-Host "`nHackathon Jury Demo:" -ForegroundColor White
            Write-Host "https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Gray
            
            Write-Host "`n🏆 YOUR ALLSENSES DEMO IS NOW FULLY OPERATIONAL!" -ForegroundColor Green
            Write-Host "All systems ready for hackathon presentation! 🚀" -ForegroundColor Green
            
        } catch {
            Write-Host "⚠️  Lambda permissions updated but still testing..." -ForegroundColor Yellow
            Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Try testing again in a few minutes for permissions to fully propagate." -ForegroundColor Yellow
        }
        
    } else {
        Write-Host "❌ FAILED: CloudFormation deployment failed" -ForegroundColor Red
        Write-Host "Error: $deployResult" -ForegroundColor Red
        
        Write-Host "`n🔧 ALTERNATIVE FIX - Run this AWS CLI command:" -ForegroundColor Yellow
        Write-Host "aws lambda add-permission --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --statement-id allow-url-invoke --action lambda:InvokeFunctionUrl --principal '*' --function-url-auth-type NONE --region us-east-1" -ForegroundColor White
    }
    
} catch {
    Write-Host "❌ AWS CLI not found or not configured" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    Write-Host "`n🔧 MANUAL FIX OPTIONS:" -ForegroundColor Yellow
    Write-Host "1. Install AWS CLI and run this script again" -ForegroundColor White
    Write-Host "2. Use AWS Console:" -ForegroundColor White
    Write-Host "   - Go to Lambda Console" -ForegroundColor Gray
    Write-Host "   - Open function: AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk" -ForegroundColor Gray
    Write-Host "   - Go to Configuration → Function URL" -ForegroundColor Gray
    Write-Host "   - Set Auth type to NONE" -ForegroundColor Gray
    Write-Host "3. Run AWS CLI command manually:" -ForegroundColor White
    Write-Host "   aws lambda add-permission --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --statement-id allow-url-invoke --action lambda:InvokeFunctionUrl --principal '*' --function-url-auth-type NONE --region us-east-1" -ForegroundColor Gray
}

Write-Host "`n📞 NEED HELP?" -ForegroundColor Cyan
Write-Host "Contact your AWS administrator to enable Lambda function URL public access" -ForegroundColor White
Write-Host "This is the only thing preventing your demo from being 100% ready!" -ForegroundColor Yellow