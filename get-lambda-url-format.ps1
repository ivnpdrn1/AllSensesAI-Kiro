# Get correct Lambda URL format for AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk

Write-Host "GETTING CORRECT LAMBDA URL FORMAT" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

$functionName = "AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk"
Write-Host "Function Name: $functionName" -ForegroundColor Cyan

# The function suffix is "ufWarJQ6FVRk"
# Lambda URLs typically use lowercase and different format
$functionSuffix = "ufWarJQ6FVRk"
Write-Host "Function Suffix: $functionSuffix" -ForegroundColor Yellow

# Try different URL formats
$possibleUrls = @(
    "https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/",
    "https://ufwarjq6fvrk-lambda-url.us-east-1.on.aws/",
    "https://ufwarjq6fvrk.lambda-url.us-east-1.amazonaws.com/",
    "https://lambda-url-ufwarjq6fvrk.us-east-1.on.aws/"
)

Write-Host "`nTesting possible URL formats:" -ForegroundColor Yellow

foreach ($url in $possibleUrls) {
    Write-Host "`nTesting: $url" -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri $url -Method POST -Body '{"message":"test"}' -ContentType "application/json" -TimeoutSec 5
        Write-Host "SUCCESS: $url works!" -ForegroundColor Green
        Write-Host "Response: $($response.status)" -ForegroundColor White
        
        Write-Host "`nCORRECT LAMBDA URL FOUND:" -ForegroundColor Magenta
        Write-Host $url -ForegroundColor White
        break
    } catch {
        Write-Host "Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nIf none work, we need to:" -ForegroundColor Yellow
Write-Host "1. Check if Lambda URL is created for the function" -ForegroundColor White
Write-Host "2. Create Lambda URL if it doesn't exist" -ForegroundColor White
Write-Host "3. Get the actual URL from AWS console" -ForegroundColor White

Write-Host "`nAlternative: Deploy to the original function instead:" -ForegroundColor Cyan
Write-Host "aws lambda update-function-code --function-name AllSenses-Live-MVP-LambdaFunction-1JGAWXA3I5IUK --zip-file fileb://allsenseai-minimal-working.py" -ForegroundColor Gray