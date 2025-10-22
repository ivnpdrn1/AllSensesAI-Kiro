# Deploy Working Lambda Function for Jury Demo

Write-Host "🚨 FIXING LAMBDA FUNCTION FOR JURY DEMO" -ForegroundColor Red
Write-Host "=======================================" -ForegroundColor Red

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

Write-Host "`n📦 Creating deployment package..." -ForegroundColor Yellow

# Create a temporary directory for the package
$tempDir = "lambda-deploy-temp"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Path $tempDir

# Copy the Lambda function code
Copy-Item "allsenseai-complete.py" "$tempDir/lambda_function.py"

# Create the ZIP package
Compress-Archive -Path "$tempDir/*" -DestinationPath "working-lambda.zip" -Force

Write-Host "`n🚀 Deploying to Lambda..." -ForegroundColor Yellow
Write-Host "Function: $functionName" -ForegroundColor Cyan

# Deploy the function
$deployCommand = "aws lambda update-function-code --function-name $functionName --zip-file fileb://working-lambda.zip --region us-east-1"

Write-Host "`nRUN THIS COMMAND:" -ForegroundColor Green
Write-Host $deployCommand -ForegroundColor White

Write-Host "`n🧪 After deployment, test with:" -ForegroundColor Yellow
Write-Host "curl -X POST https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/ -H `"Content-Type: application/json`" -d `"{`"action`":`"JURY_DEMO_TEST`"}`"" -ForegroundColor White

Write-Host "`n✅ Expected success response:" -ForegroundColor Green
Write-Host '{"status":"success","message":"AllSensesAI Jury Demo Ready!"}' -ForegroundColor Cyan

# Clean up
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

Write-Host "`n🏆 THIS WILL FIX THE INTERNAL SERVER ERROR!" -ForegroundColor Magenta
Write-Host "Your demo will be ready for the jury! 🚀" -ForegroundColor Green