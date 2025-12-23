# Quick SMS Fix Command
Write-Host "🔧 Quick SMS Fix for AllSenses" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "Run this AWS CLI command:" -ForegroundColor Yellow
Write-Host "aws lambda add-permission --function-name $functionName --statement-id allow-public-access --action lambda:InvokeFunctionUrl --principal `"*`" --function-url-auth-type NONE --region us-east-1" -ForegroundColor White

Write-Host "`nAfter running the command:" -ForegroundColor Cyan
Write-Host "1. Wait 2-3 minutes for AWS propagation" -ForegroundColor White
Write-Host "2. Test the Enhanced Emergency Monitor" -ForegroundColor White
Write-Host "3. SMS should work with Message ID displayed" -ForegroundColor White

Write-Host "`nDemo URL:" -ForegroundColor Green
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Gray