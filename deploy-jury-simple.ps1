# Simple Jury Demo Deployment
Write-Host "Deploying AllSensesAI Jury Demo..." -ForegroundColor Green

$FUNCTION_NAME = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"

# Create deployment package
Write-Host "Creating deployment package..." -ForegroundColor Yellow
$TEMP_DIR = "jury-deploy"
if (Test-Path $TEMP_DIR) { Remove-Item -Recurse -Force $TEMP_DIR }
New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null
Copy-Item "allsenseai-jury-simple.py" "$TEMP_DIR/lambda_function.py"

# Create zip
$ZIP_FILE = "jury-deployment.zip"
if (Test-Path $ZIP_FILE) { Remove-Item $ZIP_FILE }
Compress-Archive -Path "$TEMP_DIR/*" -DestinationPath $ZIP_FILE

# Update Lambda
Write-Host "Updating Lambda function..." -ForegroundColor Yellow
aws lambda update-function-code --function-name $FUNCTION_NAME --zip-file "fileb://$ZIP_FILE" --no-cli-pager

if ($LASTEXITCODE -eq 0) {
    Write-Host "SUCCESS: Lambda function updated!" -ForegroundColor Green
    Write-Host "Demo ready at: jury-emergency-demo.html" -ForegroundColor Cyan
} else {
    Write-Host "ERROR: Failed to update Lambda function" -ForegroundColor Red
}

# Cleanup
Remove-Item -Recurse -Force $TEMP_DIR -ErrorAction SilentlyContinue
Remove-Item $ZIP_FILE -ErrorAction SilentlyContinue

Write-Host "Deployment complete!" -ForegroundColor Green