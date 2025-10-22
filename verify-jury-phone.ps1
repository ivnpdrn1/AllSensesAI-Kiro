# Verify Jury Phone Number for Demo
# Phone: <REDACTED_PHONE_NUMBER>

Write-Host "Verifying phone number for jury demo..." -ForegroundColor Green

$phoneNumber = "<REDACTED_PHONE_NUMBER>"

Write-Host "Starting verification for: $phoneNumber" -ForegroundColor Yellow

# Start verification
aws sns create-sms-sandbox-phone-number --phone-number $phoneNumber --region us-east-1

Write-Host "Verification SMS sent to $phoneNumber" -ForegroundColor Green
Write-Host "Check your phone for the verification code" -ForegroundColor Cyan
Write-Host "Then run: aws sns verify-sms-sandbox-phone-number --phone-number $phoneNumber --one-time-password YOUR_CODE --region us-east-1" -ForegroundColor Gray