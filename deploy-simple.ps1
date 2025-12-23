# Simple Deploy Script
$env:AWS_ACCESS_KEY_ID = "<REDACTED_AWS_ACCESS_KEY>"
$env:AWS_SECRET_ACCESS_KEY = "<REDACTED_AWS_SECRET_KEY>"
$env:AWS_DEFAULT_REGION = "us-east-1"

Write-Host "Uploading enhanced emergency monitor..." -ForegroundColor Green
aws s3 cp "frontend/enhanced-emergency-monitor.html" "s3://allsenses-mvp1-demo-website/enhanced-emergency-monitor.html" --content-type "text/html"

Write-Host "Uploading jury demo..." -ForegroundColor Green
aws s3 cp "jury-emergency-demo.html" "s3://allsenses-mvp1-demo-website/jury-emergency-demo.html" --content-type "text/html"

Write-Host "Invalidating CloudFront cache..." -ForegroundColor Yellow
aws cloudfront create-invalidation --distribution-id "E3EB0YJG06PX1P" --paths "/*"

Write-Host ""
Write-Host "DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "Jury Demo URL: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "Alternative URL: https://d4om8j6cvwtqd.cloudfront.net/jury-emergency-demo.html" -ForegroundColor Cyan
Write-Host ""
Write-Host "Victim name fields are now deployed!" -ForegroundColor Yellow
Write-Host "Cache may take 1-2 minutes to update" -ForegroundColor Gray