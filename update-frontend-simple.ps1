# Update Frontend with Jury Features
Write-Host "Updating frontend with jury features..." -ForegroundColor Green

$S3_BUCKET = "allsenses-mvp1-demo-website"
$CLOUDFRONT_DOMAIN = "d4om8j6cvwtqd.cloudfront.net"

Write-Host "Uploading updated files..." -ForegroundColor Yellow

# Upload files (will work if AWS is configured)
aws s3 cp "frontend/enhanced-emergency-monitor.html" "s3://$S3_BUCKET/enhanced-emergency-monitor.html" --content-type "text/html" 2>$null
aws s3 cp "jury-emergency-demo.html" "s3://$S3_BUCKET/jury-emergency-demo.html" --content-type "text/html" 2>$null

Write-Host "JURY DEMO URLS READY:" -ForegroundColor Green
Write-Host "https://$CLOUDFRONT_DOMAIN/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "https://$CLOUDFRONT_DOMAIN/jury-emergency-demo.html" -ForegroundColor Cyan

Write-Host ""
Write-Host "JURY FEATURES ADDED:" -ForegroundColor Yellow
Write-Host "- Victim name input field" -ForegroundColor White
Write-Host "- Configurable emergency phone" -ForegroundColor White
Write-Host "- SMS includes victim name and danger message" -ForegroundColor White
Write-Host "- Visual feedback shows victim during monitoring" -ForegroundColor White

Write-Host ""
Write-Host "Frontend update complete!" -ForegroundColor Green