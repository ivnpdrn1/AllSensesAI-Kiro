# Deploy Hybrid Real SMS Version for Hackathon
# Real SMS for verified numbers + simulation for others

Write-Host "📱 DEPLOYING HYBRID REAL SMS VERSION" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK"

# Create deployment package
Write-Host "`n📦 Creating hybrid deployment package..." -ForegroundColor Yellow
Compress-Archive -Path "allsenseai-hybrid-real-sms.py" -DestinationPath "hybrid-real-sms.zip" -Force

Write-Host "✅ Package created: hybrid-real-sms.zip" -ForegroundColor Green

Write-Host "`n🚀 Deploy with this command:" -ForegroundColor Yellow
Write-Host "aws lambda update-function-code --function-name $functionName --zip-file fileb://hybrid-real-sms.zip" -ForegroundColor Cyan

Write-Host "`n📱 Hybrid Features:" -ForegroundColor Magenta
Write-Host "• REAL SMS to verified phone numbers" -ForegroundColor Green
Write-Host "• Simulated SMS to unverified numbers" -ForegroundColor Yellow
Write-Host "• Phone number verification via API" -ForegroundColor Cyan
Write-Host "• Perfect for hackathon demo" -ForegroundColor White

Write-Host "`n🔧 New API Endpoints:" -ForegroundColor Yellow
Write-Host "• CHECK_SNS_STATUS - Shows verified numbers" -ForegroundColor White
Write-Host "• VERIFY_PHONE - Start/complete phone verification" -ForegroundColor White
Write-Host "• MAKE_REAL_CALL - Hybrid real/simulated SMS" -ForegroundColor White

Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Deploy the hybrid Lambda function" -ForegroundColor White
Write-Host "2. Verify your phone number:" -ForegroundColor White
Write-Host "   .\quick-phone-verify.ps1 -PhoneNumber '+1234567890'" -ForegroundColor Gray
Write-Host "3. Test real SMS to your verified number" -ForegroundColor White
Write-Host "4. Demo shows real SMS + simulated SMS" -ForegroundColor White

Write-Host "`n🏆 Perfect for hackathon judging!" -ForegroundColor Green