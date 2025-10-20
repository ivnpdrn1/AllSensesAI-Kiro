# Deploy Updated Frontend with New Lambda URL

Write-Host "DEPLOYING UPDATED FRONTEND" -ForegroundColor Green
Write-Host "==========================" -ForegroundColor Green

$bucketName = "allsenses-mvp1-demo-website"
$cloudFrontDistributionId = "E3EB0YJG06PX1P"
$newLambdaUrl = "https://ufwarjq6fvrk-lambda-url.us-east-1.on.aws/"

Write-Host "New Lambda URL: $newLambdaUrl" -ForegroundColor Green
Write-Host "S3 Bucket: $bucketName" -ForegroundColor Cyan
Write-Host "CloudFront Distribution: $cloudFrontDistributionId" -ForegroundColor Cyan

Write-Host "`nFiles to upload:" -ForegroundColor Yellow
Write-Host "1. hackathon-jury-demo.html" -ForegroundColor White
Write-Host "2. frontend/enhanced-emergency-monitor.html -> enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "3. allsense-live-incident-panel.html" -ForegroundColor White
Write-Host "4. frontend/mvp1-complete-demo.html -> mvp1-complete-demo.html" -ForegroundColor White

Write-Host "`nCommands to run:" -ForegroundColor Red

Write-Host "`n1. Upload files to S3:" -ForegroundColor Yellow
Write-Host "aws s3 cp hackathon-jury-demo.html s3://$bucketName/hackathon-jury-demo.html --content-type text/html" -ForegroundColor White
Write-Host "aws s3 cp frontend/enhanced-emergency-monitor.html s3://$bucketName/enhanced-emergency-monitor.html --content-type text/html" -ForegroundColor White
Write-Host "aws s3 cp allsense-live-incident-panel.html s3://$bucketName/allsense-live-incident-panel.html --content-type text/html" -ForegroundColor White
Write-Host "aws s3 cp frontend/mvp1-complete-demo.html s3://$bucketName/mvp1-complete-demo.html --content-type text/html" -ForegroundColor White

Write-Host "`n2. Invalidate CloudFront cache:" -ForegroundColor Yellow
Write-Host "aws cloudfront create-invalidation --distribution-id $cloudFrontDistributionId --paths /*" -ForegroundColor White

Write-Host "`n3. Test URLs after deployment:" -ForegroundColor Green
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Cyan
Write-Host "https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan

Write-Host "`nFrontend updated to call: $newLambdaUrl" -ForegroundColor Green