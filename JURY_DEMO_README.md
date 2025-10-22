# AllSenses AI Guardian - Jury Demo Version

## 🏆 Hackathon Jury Demonstration

This is a simplified version of the AllSenses AI Guardian emergency detection system, specifically designed for jury evaluation with configurable victim names and emergency contact phone numbers.

## 🚨 Key Features for Jury

### ✅ Configurable Victim Information
- **Victim Name Input**: Jury can enter any victim's name
- **Emergency Contact Phone**: Jury can enter their own phone number to receive real SMS alerts
- **Clear Danger Messages**: SMS includes victim's name and explicit danger status

### ✅ Dual Emergency Detection
- **Emergency Words Detection**: Listens for "help", "emergency", "danger", "911", "fire", "police"
- **Abrupt Noise Detection**: Monitors for sudden loud sounds above threshold
- **Real-time Audio Monitoring**: Visual feedback showing active listening status

### ✅ Emergency Response
- **Immediate SMS Alerts**: Real SMS sent to configured phone number
- **Victim Name Included**: Every SMS clearly identifies the victim by name
- **Location Information**: GPS coordinates and Google Maps link included
- **Incident Tracking**: Unique incident IDs for each emergency

## 📱 Demo Instructions for Jury

### Step 1: Open the Demo
1. Open `jury-emergency-demo.html` in a web browser
2. Ensure microphone permissions are granted

### Step 2: Configure Settings
1. **Enter Victim's Name**: Type the victim's full name (e.g., "Carlos Perez")
2. **Enter Your Phone Number**: Input your phone number to receive real SMS alerts
3. Both fields are required for the demo to work

### Step 3: Start Monitoring
1. Click "🎤 Start Emergency Monitoring"
2. Grant microphone access when prompted
3. The listening indicator will show "Monitoring [Victim Name]"

### Step 4: Test Emergency Detection
Choose one of these test methods:

#### Option A: Test Emergency Words
1. Click "🗣️ Test Emergency Words" button
2. Or speak emergency words like "help", "emergency", "danger"

#### Option B: Test Abrupt Noise
1. Click "📢 Test Abrupt Noise" button
2. Or make a sudden loud noise near the microphone

### Step 5: Receive SMS Alert
You will receive an SMS like:
```
🚨 EMERGENCY ALERT: Carlos Perez is in DANGER! 
Emergency words detected: "help, emergency"

Location: Miami Convention Center, FL
View location: https://maps.google.com/?q=25.7617,-80.1918

Incident ID: JURY-A1B2C3D4
Time: 14:30:15

🏆 AllSensesAI Jury Demo - Live Emergency Detection System
```

## 🔧 Technical Implementation

### Frontend Features
- **HTML5 Audio API**: Real-time microphone access and audio analysis
- **Web Speech API**: Continuous speech recognition for emergency words
- **Responsive Design**: Professional emergency-focused UI
- **Real-time Feedback**: Visual listening indicator and volume meters

### Backend Features
- **AWS Lambda**: Serverless emergency processing
- **AWS SNS**: Real SMS delivery to configured phone numbers
- **AWS Bedrock**: AI-powered threat analysis (fallback to rule-based)
- **Incident Tracking**: Unique IDs and timestamps for each emergency

### SMS Message Format
Every emergency SMS includes:
1. **Clear Danger Alert**: "🚨 EMERGENCY ALERT: [Victim Name] is in DANGER!"
2. **Detection Details**: What triggered the alert (words or noise)
3. **Location Information**: Address and Google Maps link
4. **Incident Tracking**: Unique incident ID and timestamp
5. **System Identification**: Clear indication this is the AllSensesAI system

## 🚀 Quick Deployment (for Technical Jury)

If you need to redeploy or test the backend:

```powershell
# Deploy the jury demo version
.\deploy-jury-demo.ps1

# Test the functionality
.\test-jury-demo.ps1
```

## 📊 Demo Scenarios

### Scenario 1: Rideshare Safety
- **Victim**: "Maria Rodriguez" (passenger)
- **Trigger**: Speak "help me" or "emergency"
- **Expected**: SMS alert with Maria's name and location

### Scenario 2: Workplace Emergency
- **Victim**: "Carlos Perez" (worker)
- **Trigger**: Loud noise simulation (button or actual noise)
- **Expected**: SMS alert about sudden noise and Carlos's danger

### Scenario 3: Pedestrian Safety
- **Victim**: "Any Name" (customizable)
- **Trigger**: Any emergency word or loud sound
- **Expected**: Immediate SMS with victim identification

## 🎯 Jury Evaluation Points

### ✅ User Experience
- Simple, intuitive interface
- Clear visual feedback
- Easy configuration of victim and contact info

### ✅ Emergency Detection
- Dual detection methods (words + noise)
- Real-time audio monitoring
- Immediate response to threats

### ✅ Communication
- Real SMS delivery (not simulated)
- Clear, actionable emergency messages
- Victim identification in every alert

### ✅ Technical Implementation
- AWS cloud-native architecture
- Serverless scalability
- AI-powered threat analysis

## 📞 Support During Demo

If you encounter any issues during the demonstration:

1. **Microphone Access**: Ensure browser has microphone permissions
2. **SMS Delivery**: Check phone number format (+1XXXXXXXXXX)
3. **Audio Detection**: Speak clearly or make distinct loud sounds
4. **Network Issues**: Demo works offline for audio, requires internet for SMS

## 🏆 Why AllSenses AI Guardian?

This system demonstrates:
- **Real-world Applicability**: Actual emergency detection and response
- **User-Centric Design**: Configurable for different victims and contacts
- **Technical Excellence**: Cloud-native, AI-powered, scalable architecture
- **Immediate Value**: Working system that could save lives today

---

**Ready for Jury Evaluation!** 🚀

The system is fully functional and ready to demonstrate real emergency detection and SMS alerting capabilities with configurable victim names and contact information.