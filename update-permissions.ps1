# AllSenses IAM Permission Update Script
# Run this as an AWS administrator to grant deployment permissions

Write-Host "🔧 Updating AllSenses Deployer Permissions..." -ForegroundColor Cyan

# Set AWS credentials for admin user (replace with your admin credentials)
$env:AWS_ACCESS_KEY_ID = "YOUR_ADMIN_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY = "YOUR_ADMIN_SECRET_KEY"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Create the policy
$policyName = "AllSensesDeploymentPolicy"
$policyDocument = Get-Content "add-iam-permissions.json" -Raw

try {
    # Create the policy
    Write-Host "Creating IAM policy: $policyName" -ForegroundColor Yellow
    aws iam create-policy --policy-name $policyName --policy-document $policyDocument --description "AllSenses AI Guardian deployment permissions"
    
    # Get the policy ARN
    $accountId = (aws sts get-caller-identity --query Account --output text)
    $policyArn = "arn:aws:iam::${accountId}:policy/$policyName"
    
    # Attach to user
    Write-Host "Attaching policy to allsenses-deployer user..." -ForegroundColor Yellow
    aws iam attach-user-policy --user-name allsenses-deployer --policy-arn $policyArn
    
    Write-Host "✅ Permissions updated successfully!" -ForegroundColor Green
    Write-Host "The allsenses-deployer user now has deployment permissions." -ForegroundColor Green
    
} catch {
    Write-Host "❌ Error updating permissions: $_" -ForegroundColor Red
    Write-Host "You may need to run this as an AWS administrator." -ForegroundColor Yellow
}

Write-Host "`n🚀 Ready to deploy AllSenses MVP!" -ForegroundColor Cyan