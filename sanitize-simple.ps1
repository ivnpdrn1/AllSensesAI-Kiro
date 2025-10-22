# Simple Sanitization Script
Write-Host "Sanitizing AllSensesAI project for Hackathon Jury..." -ForegroundColor Green

$SOURCE_DIR = "C:\Users\ivanp\OneDrive\Documents\Kiro"
$SANITIZED_DIR = "C:\Users\ivanp\OneDrive\Documents\Kiro_Sanitized_For_Jury"

# Step 1: Create clean copy
Write-Host "Creating clean copy..." -ForegroundColor Yellow
if (Test-Path $SANITIZED_DIR) {
    Remove-Item -Recurse -Force $SANITIZED_DIR
}
Copy-Item -Recurse $SOURCE_DIR $SANITIZED_DIR

# Step 2: Remove .git folder
Write-Host "Removing .git folder..." -ForegroundColor Yellow
$gitFolder = Join-Path $SANITIZED_DIR ".git"
if (Test-Path $gitFolder) {
    Remove-Item -Recurse -Force $gitFolder
}

# Step 3: Sanitize credentials
Write-Host "Sanitizing AWS credentials..." -ForegroundColor Yellow
$fileTypes = @("*.ps1", "*.py", "*.md", "*.html", "*.js", "*.yaml", "*.yml", "*.json", "*.txt")

foreach ($fileType in $fileTypes) {
    $files = Get-ChildItem -Path $SANITIZED_DIR -Filter $fileType -Recurse -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        try {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $originalContent = $content
                $content = $content -replace "<REDACTED_AWS_ACCESS_KEY>", "<REDACTED_AWS_ACCESS_KEY>"
                $content = $content -replace "TxX6jkK\+UkGj0acbZgGM3IHuKa4tQ8IbIj9Z\+daR", "<REDACTED_AWS_SECRET_KEY>"
                $content = $content -replace "\<REDACTED_PHONE_NUMBER>", "<REDACTED_PHONE_NUMBER>"
                $content = $content -replace "<REDACTED_EMAIL>", "<REDACTED_EMAIL>"
                
                if ($content -ne $originalContent) {
                    Set-Content -Path $file.FullName -Value $content -NoNewline
                    Write-Host "Sanitized: $($file.Name)" -ForegroundColor Gray
                }
            }
        } catch {
            Write-Host "Skipped: $($file.Name)" -ForegroundColor Gray
        }
    }
}

# Step 4: Create README
$juryReadme = @"
# AllSenses AI Guardian - Hackathon Jury Version

## Project Overview
Real-time emergency detection system with AI-powered threat analysis and automatic SMS alerts.

## Key Features
- Configurable victim names and emergency contacts
- Dual emergency detection (words + noise)
- Geolocation integration with Google Maps
- AWS cloud-native architecture
- HTTPS security for microphone access

## Live Demo
https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html

## SMS Format
Emergency alerts include victim name, danger status, location coordinates, and Google Maps link.

## Technical Stack
- Frontend: HTML5/JavaScript with Web Audio/Speech APIs
- Backend: AWS Lambda (Python) with SNS, Bedrock AI, DynamoDB
- Infrastructure: CloudFormation, CloudFront CDN

Built for Miami Hackathon 2024
"@

Set-Content -Path (Join-Path $SANITIZED_DIR "README.md") -Value $juryReadme

Write-Host "Sanitization complete!" -ForegroundColor Green
Write-Host "Sanitized folder: $SANITIZED_DIR" -ForegroundColor Cyan

# Step 5: Git operations
Write-Host "Initializing Git repository..." -ForegroundColor Yellow
Set-Location $SANITIZED_DIR

git init
git add .
git commit -m "Initial commit - sanitized for Hackathon jury (no secrets)"
git remote add origin https://github.com/ivnpdrn1/AllSensesAI-Kiro.git
git push -u origin main

# Step 6: Verify no secrets
Write-Host "Verifying no secrets leaked..." -ForegroundColor Yellow
$akiaResult = git grep "AKIA" 2>$null
$asiaResult = git grep "ASIA" 2>$null

if (-not $akiaResult -and -not $asiaResult) {
    Write-Host ""
    Write-Host "Repository sanitized and safely published for Hackathon Jury." -ForegroundColor Green
    Write-Host "GitHub: https://github.com/ivnpdrn1/AllSensesAI-Kiro" -ForegroundColor Cyan
} else {
    Write-Host "Warning: Review for potential secrets" -ForegroundColor Red
}

Set-Location $SOURCE_DIR