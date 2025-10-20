# Update Frontend Lambda URL and Redeploy

Write-Host "UPDATING FRONTEND LAMBDA URL AND REDEPLOYING" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

$oldUrl = "https://53x75wmoi5qtdv2gfc4sn3btzu0rivqx.lambda-url.us-east-1.on.aws/"
$newUrl = "https://ufwarjq6fvrk-lambda-url.us-east-1.on.aws/"
$bucketName = "allsenses-mvp1-demo-website"
$cloudFrontDistributionId = "E3EB0YJG06PX1P"

Write-Host "Old Lambda URL: $oldUrl" -ForegroundColor Red
Write-Host "New Lambda URL: $newUrl" -ForegroundColor Green

Write-Host "`n📁 Files Updated:" -ForegroundColor Yellow
Write-Host "✅ hackathon-jury-demo.html" -ForegroundColor White
Write-Host "✅ frontend/enhanced-emergency-monitor.html" -ForegroundColor White
Write-Host "✅ allsense-live-incident-panel.html" -ForegroundColor White
Write-Host "✅ frontend/mvp1-complete-demo.html" -ForegroundColor White

Write-Host "`n🚀 Deploying to S3..." -ForegroundColor Yellow

# Upload updated files to S3
$filesToUpload = @(
    @{Local="hackathon-jury-demo.html"; S3="hackathon-jury-demo.html"},
    @{Local="frontend/enhanced-emergency-monitor.html"; S3="enhanced-emergency-monitor.html"},
    @{Local="allsense-live-incident-panel.html"; S3="allsense-live-incident-panel.html"},
    @{Local="frontend/mvp1-complete-demo.html"; S3="mvp1-complete-demo.html"}
)

foreach ($file in $filesToUpload) {
    Write-Host "Uploading $($file.Local) → s3://$bucketName/$($file.S3)" -ForegroundColor Cyan
    Write-Host "aws s3 cp `"$($file.Local)`" s3://$bucketName/$($file.S3) --content-type text/html" -ForegroundColor Gray
}

Write-Host "`n🔄 Invalidating CloudFront Cache..." -ForegroundColor Yellow
Write-Host "aws cloudfront create-invalidation --distribution-id $cloudFrontDistributionId --paths `"/*`"" -ForegroundColor Gray

Write-Host "`n🧪 Test URLs After Deployment:" -ForegroundColor Magenta
Write-Host "• Jury Demo: https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html" -ForegroundColor Cyan
Write-Host "• Enhanced Monitor: https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html" -ForegroundColor Cyan
Write-Host "• Live Incident Panel: https://d4om8j6cvwtqd.cloudfront.net/allsense-live-incident-panel.html" -ForegroundColor Cyan
Write-Host "• MVP Complete Demo: https://d4om8j6cvwtqd.cloudfront.net/mvp1-complete-demo.html" -ForegroundColor Cyan

Write-Host "`n⚡ Commands to Run:" -ForegroundColor Red
Write-Host "1. Upload files to S3:" -ForegroundColor Yellow
foreach ($file in $filesToUpload) {
    Write-Host "   aws s3 cp `"$($file.Local)`" s3://$bucketName/$($file.S3) --content-type text/html" -ForegroundColor White
}
Write-Host "`n2. Invalidate CloudFront:" -ForegroundColor Yellow
Write-Host "   aws cloudfront create-invalidation --distribution-id $cloudFrontDistributionId --paths `"/*`"" -ForegroundColor White

Write-Host "`n🎯 After deployment, test the new Lambda URL:" -ForegroundColor Green
Write-Host $newUrl -ForegroundColor White