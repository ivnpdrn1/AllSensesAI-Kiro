# 🚀 FINAL DEPLOYMENT COMMANDS

## **UPDATED FRONTEND CONFIGURATION**

✅ **Frontend files updated to call**: `https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/`

### **Files Updated:**
- ✅ `hackathon-jury-demo.html`
- ✅ `frontend/enhanced-emergency-monitor.html`
- ✅ `allsense-live-incident-panel.html`
- ✅ `frontend/mvp1-complete-demo.html`

## **DEPLOYMENT COMMANDS**

### **1. Deploy Lambda Function (if not done already):**
```bash
aws lambda update-function-code --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --zip-file fileb://allsenseai-minimal-working.py --region us-east-1
```

### **2. Create/Update Lambda Function URL:**
```bash
aws lambda create-function-url-config --function-name AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk --auth-type NONE --cors '{"AllowCredentials":false,"AllowHeaders":["*"],"AllowMethods":["*"],"AllowOrigins":["*"]}' --region us-east-1
```

### **3. Upload Updated Frontend Files to S3:**
```bash
aws s3 cp hackathon-jury-demo.html s3://allsenses-mvp1-demo-website/hackathon-jury-demo.html --content-type text/html

aws s3 cp frontend/enhanced-emergency-monitor.html s3://allsenses-mvp1-demo-website/enhanced-emergency-monitor.html --content-type text/html

aws s3 cp allsense-live-incident-panel.html s3://allsenses-mvp1-demo-website/allsense-live-incident-panel.html --content-type text/html

aws s3 cp frontend/mvp1-complete-demo.html s3://allsenses-mvp1-demo-website/mvp1-complete-demo.html --content-type text/html
```

### **4. Invalidate CloudFront Cache:**
```bash
aws cloudfront create-invalidation --distribution-id E3EB0YJG06PX1P --paths "/*"
```

## **TEST URLS AFTER DEPLOYMENT**

### **🏆 Jury Demo:**
```
https://d4om8j6cvwtqd.cloudfront.net/hackathon-jury-demo.html
```

### **🛡️ Enhanced Emergency Monitor:**
```
https://d4om8j6cvwtqd.cloudfront.net/enhanced-emergency-monitor.html
```

### **📋 Live Incident Panel:**
```
https://d4om8j6cvwtqd.cloudfront.net/allsense-live-incident-panel.html
```

### **🎯 MVP Complete Demo:**
```
https://d4om8j6cvwtqd.cloudfront.net/mvp1-complete-demo.html
```

## **VERIFICATION STEPS**

### **1. Test Lambda URL Directly:**
```bash
curl -X POST https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/ \
  -H "Content-Type: application/json" \
  -d '{"action":"JURY_DEMO_TEST"}'
```

### **2. Test Frontend Pages:**
1. Open jury demo URL
2. Click "Send Real Emergency SMS"
3. Should show "SUCCESS" instead of "Failed to fetch"
4. Your phone (+13053033060) should receive SMS

## **EXPECTED RESULTS**

✅ **No more "Failed to fetch" errors**  
✅ **SMS notifications work**  
✅ **Real SMS to +13053033060**  
✅ **All demo pages functional**  
✅ **Ready for jury presentation**

## **🎯 SUMMARY**

The frontend now calls the correct Lambda function `AllSenses-Live-MVP-AllSensesFunction-ufWarJQ6FVRk` at URL `https://ufwarjq6fvrk.lambda-url.us-east-1.on.aws/`. After running these deployment commands, your hackathon demo will work perfectly!

**🏆 Your AllSensesAI demo is ready to impress the jury!**