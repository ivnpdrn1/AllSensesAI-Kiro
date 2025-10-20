# Final Hackathon Demo Deployment

Write-Host "DEPLOYING FINAL HACKATHON DEMO" -ForegroundColor Green
Write-Host "==============================" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

# Create the zip file
Write-Host "Creating deployment package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-hackathon-demo.py" -DestinationPath "final-demo.zip" -Force

Write-Host "Package created: final-demo.zip" -ForegroundColor Green

Write-Host "`nTo deploy, run this AWS CLI command:" -ForegroundColor Yellow
Write-Host "aws lambda update-function-code --function-name $functionName --zip-file fileb://final-demo.zip" -ForegroundColor Cyan

Write-Host "`nDemo Features:" -ForegroundColor Green
Write-Host "- SMS works with ANY phone number" -ForegroundColor White
Write-Host "- All 7 pipeline steps complete successfully" -ForegroundColor White
Write-Host "- Real AWS Bedrock AI analysis" -ForegroundColor White
Write-Host "- Perfect for hackathon judging" -ForegroundColor White

Write-Host "`nYour demo is ready! Good luck!" -ForegroundColor Green