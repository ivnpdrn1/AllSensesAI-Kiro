# Setup AWS End User Messaging (EUM) 10DLC for Real SMS
# This enables real SMS sending for your hackathon demo

Write-Host "🚀 AWS End User Messaging (EUM) 10DLC Setup" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`n📋 Step 1: Register 10DLC Origination Number" -ForegroundColor Yellow
Write-Host "We'll create a 10DLC number in AWS End User Messaging for us-east-1" -ForegroundColor White

# Check if AWS CLI is available
try {
    $awsVersion = aws --version
    Write-Host "AWS CLI detected: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not found. Please install AWS CLI first." -ForegroundColor Red
    exit 1
}

Write-Host "`n🏢 Step 2: Create Company/Brand Registration" -ForegroundColor Yellow
Write-Host "Creating brand registration for AllSensesAI..." -ForegroundColor White

# Create brand registration
$brandName = "AllSensesAI"
$companyName = "AllSensesAI Emergency Systems"
$website = "https://allsensesai.com"
$supportEmail = "support@allsensesai.com"

Write-Host "`nCreating brand registration..." -ForegroundColor Cyan
try {
    $brandCommand = @"
aws pinpoint-sms-voice-v2 create-registration \
    --registration-type COMPANY \
    --registration-information '{
        "CompanyName": "$companyName",
        "Website": "$website",
        "SupportEmail": "$supportEmail",
        "BusinessType": "TECHNOLOGY",
        "CountryCode": "US"
    }' \
    --region us-east-1
"@

    Write-Host "Command to run:" -ForegroundColor Gray
    Write-Host $brandCommand -ForegroundColor Gray
    
    # Execute the command
    $brandResult = Invoke-Expression $brandCommand
    $brandJson = $brandResult | ConvertFrom-Json
    $registrationId = $brandJson.RegistrationId
    
    Write-Host "✅ Brand registration created: $registrationId" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️ Brand registration may already exist or need manual setup" -ForegroundColor Yellow
    Write-Host "Continue with manual steps below..." -ForegroundColor Yellow
}

Write-Host "`n📱 Step 3: Request 10DLC Phone Number" -ForegroundColor Yellow
Write-Host "Requesting a dedicated phone number for SMS..." -ForegroundColor White

try {
    $phoneCommand = @"
aws pinpoint-sms-voice-v2 request-phone-number \
    --iso-country-code US \
    --message-type TRANSACTIONAL \
    --number-capabilities SMS \
    --number-type LONG_CODE \
    --region us-east-1
"@

    Write-Host "Command to run:" -ForegroundColor Gray
    Write-Host $phoneCommand -ForegroundColor Gray
    
    $phoneResult = Invoke-Expression $phoneCommand
    $phoneJson = $phoneResult | ConvertFrom-Json
    $phoneNumber = $phoneJson.PhoneNumber
    $phoneNumberId = $phoneJson.PhoneNumberId
    
    Write-Host "✅ Phone number acquired: $phoneNumber" -ForegroundColor Green
    Write-Host "Phone Number ID: $phoneNumberId" -ForegroundColor Cyan
    
} catch {
    Write-Host "⚠️ Phone number request failed. Try manual setup." -ForegroundColor Yellow
}

Write-Host "`n🔗 Step 4: Link to SNS Sandbox" -ForegroundColor Yellow
Write-Host "Linking the 10DLC number to SNS for SMS sending..." -ForegroundColor White

try {
    # Set the origination number for SNS
    $snsCommand = @"
aws sns set-sms-attributes \
    --attributes DefaultSenderID=$phoneNumber \
    --region us-east-1
"@

    Write-Host "Command to run:" -ForegroundColor Gray
    Write-Host $snsCommand -ForegroundColor Gray
    
    Invoke-Expression $snsCommand
    Write-Host "✅ SNS configured with 10DLC number" -ForegroundColor Green
    
} catch {
    Write-Host "⚠️ SNS configuration may need manual setup" -ForegroundColor Yellow
}

Write-Host "`n📋 Manual Setup Instructions (if automated setup failed):" -ForegroundColor Magenta
Write-Host "=========================================================" -ForegroundColor Magenta

Write-Host "`n1. Open AWS Console → End User Messaging:" -ForegroundColor Yellow
Write-Host "   https://console.aws.amazon.com/pinpoint/home?region=us-east-1#/sms-account-settings/registrations" -ForegroundColor Cyan

Write-Host "`n2. Create Company Registration:" -ForegroundColor Yellow
Write-Host "   - Company Name: AllSensesAI Emergency Systems" -ForegroundColor White
Write-Host "   - Business Type: Technology/Software" -ForegroundColor White
Write-Host "   - Website: https://allsensesai.com (or your demo URL)" -ForegroundColor White
Write-Host "   - Support Email: your-email@domain.com" -ForegroundColor White

Write-Host "`n3. Create Campaign:" -ForegroundColor Yellow
Write-Host "   - Campaign Name: AllSensesAI Emergency Alerts" -ForegroundColor White
Write-Host "   - Campaign Type: Mixed (Emergency + Transactional)" -ForegroundColor White
Write-Host "   - Use Case: Emergency notifications and safety alerts" -ForegroundColor White

Write-Host "`n4. Request Phone Number:" -ForegroundColor Yellow
Write-Host "   - Go to Phone Numbers → Request phone number" -ForegroundColor White
Write-Host "   - Country: United States" -ForegroundColor White
Write-Host "   - Number Type: 10DLC (Long Code)" -ForegroundColor White
Write-Host "   - Capabilities: SMS" -ForegroundColor White

Write-Host "`n5. Associate with SNS:" -ForegroundColor Yellow
Write-Host "   - Go to SNS → Text messaging (SMS)" -ForegroundColor White
Write-Host "   - Set Default sender ID to your 10DLC number" -ForegroundColor White

Write-Host "`n⏱️ Timeline:" -ForegroundColor Green
Write-Host "- Company registration: 1-2 business days" -ForegroundColor White
Write-Host "- Campaign approval: 1-3 business days" -ForegroundColor White
Write-Host "- Phone number: Immediate once approved" -ForegroundColor White

Write-Host "`n🚀 Quick Alternative for Hackathon:" -ForegroundColor Cyan
Write-Host "If you need immediate SMS for demo, you can:" -ForegroundColor White
Write-Host "1. Use the simulation version (already created)" -ForegroundColor White
Write-Host "2. Verify 1-2 phone numbers in SNS sandbox" -ForegroundColor White
Write-Host "3. Show real SMS to those verified numbers" -ForegroundColor White

Write-Host "`n📱 Next: Verify Your Phone Number" -ForegroundColor Yellow
Write-Host "Run: .\scripts\verify-sandbox-numbers.ps1 -PhoneNumber '+1234567890'" -ForegroundColor Cyan