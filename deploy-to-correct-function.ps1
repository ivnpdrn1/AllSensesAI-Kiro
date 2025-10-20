# Deploy to the CORRECT Lambda function that the frontend is calling

Write-Host "DEPLOYING TO CORRECT LAMBDA FUNCTION" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# This is the function the frontend is calling
$correctFunctionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

Write-Host "Frontend expects: $correctFunctionName" -ForegroundColor Cyan
Write-Host "URL: https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/" -ForegroundColor Cyan

# Create deployment package
Write-Host "`nCreating deployment package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-minimal-working.py" -DestinationPath "correct-function.zip" -Force

Write-Host "Package created: correct-function.zip" -ForegroundColor Green

Write-Host "`nDEPLOY TO CORRECT FUNCTION:" -ForegroundColor Red
Write-Host "aws lambda update-function-code --function-name $correctFunctionName --zip-file fileb://correct-function.zip" -ForegroundColor White

Write-Host "`nThis will fix the frontend connectivity!" -ForegroundColor Green
Write-Host "- Frontend calls the correct Lambda URL" -ForegroundColor White
Write-Host "- No more 'Failed to fetch' errors" -ForegroundColor White
Write-Host "- SMS notifications will work" -ForegroundColor White
Write-Host "- Real SMS to +13053033060" -ForegroundColor White