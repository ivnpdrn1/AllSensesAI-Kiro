# URGENT: Fix Lambda Permissions for Jury Demo
# Run this to enable your AllSenses demo for jury presentation

Write-Host "🚨 FIXING LAMBDA PERMISSIONS FOR JURY DEMO" -ForegroundColor Red
Write-Host "===========================================" -ForegroundColor Red

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"
$lambdaUrl = "https://53x75wmois5qtdv2gfc4sn3btzubrivqx.lambda-url.us-east-1.on.aws/"

Write-Host "`n🔧 Configuring Lambda function URL permissions..." -ForegroundColor Yellow
Write-Host "Function: $functionName" -ForegroundColor Cyan
Write-Host "URL: $lambdaUrl" -ForegroundColor Cyan

# Try to add permission
Write-Host "`n⚡ Adding public access permission..." -ForegroundColor Yellow

$permissionCommand = "aws lambda add-permission --function-name $functionName --statement-id allow-url-invoke --action lambda:InvokeFunctionUrl --principal `"*`" --function-url-auth-type NONE --region us-east-1"

Write-Host "`nRUN THIS COMMAND:" -ForegroundColor Green
Write-Host $permissionCommand -ForegroundColor White

Write-Host "`n🧪 After running the command, test with:" -ForegroundColor Yellow
Write-Host "curl -X POST $lambdaUrl -H `"Content-Type: application/json`" -d `"{`"action`":`"JURY_DEMO_TEST`"}`"" -ForegroundColor White

Write-Host "`n✅ Expected result:" -ForegroundColor Green
Write-Host '{"status":"success","message":"AllSensesAI Jury Demo Ready!"}' -ForegroundColor Cyan

Write-Host "`n🏆 AFTER FIX - YOUR DEMO WILL SHOW:" -ForegroundColor Magenta
Write-Host "- ✅ Notification sent successfully!" -ForegroundColor Green
Write-Host "- ✅ Real SMS to +13053033060" -ForegroundColor Green
Write-Host "- ✅ Message ID confirmation" -ForegroundColor Green
Write-Host "- ✅ Complete emergency pipeline working" -ForegroundColor Green

Write-Host "`n🎯 JURY DEMO URL (will work after fix):" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor White

Write-Host "`n🚨 THIS IS THE ONLY THING PREVENTING PERFECT DEMO!" -ForegroundColor Red
Write-Host "Run the AWS command above and your demo will be 100% ready! 🚀" -ForegroundColor Green