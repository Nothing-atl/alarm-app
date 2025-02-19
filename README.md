

### **📜 Alarm App (iOS)**
Here’s a structured **README** for your **iOS Alarm App** using SwiftUI and `UserNotifications`.  

---

# **⏰ Alarm App**
A **fully customizable alarm app** built with SwiftUI. It supports **scheduling alarms**, **custom sounds**, **dark mode**, **repeat settings**, and **real-time alarm management**.  

## **🚀 Features**
✅ **Set Multiple Alarms** – Users can create, edit, and delete alarms.  
✅ **Custom Alarm Sounds** – Choose from built-in sounds.  
✅ **Dark Mode Support** – Auto-adapts to light and dark themes.  
✅ **Repeat Alarms** – Daily or specific days of the week.  
✅ **Swipe Actions** – Quickly **edit or delete** alarms.  
✅ **Snooze Feature (Planned)** – Coming soon!  

---

## **📌 How It Works**
1. **Set an Alarm** – Choose time, reason, repeat days, and sound.  
2. **Save the Alarm** – It is stored in `UserDefaults` and scheduled using `UserNotifications`.  
3. **Receive Notifications** – A notification appears at the scheduled time with sound.  
4. **Manage Alarms** – Edit or delete alarms directly from the app.  

---

## **🛠️ Technologies Used**
- **SwiftUI** – UI Framework  
- **UserNotifications** – Local notifications for alarms  
- **AppStorage (UserDefaults)** – Stores alarms persistently  
- **DispatchQueue** – Ensures smooth UI updates  
- **NavigationView & Toolbar** – For app navigation and dark mode toggle  

---

## **🔧 Installation**
### **📲 Requirements**
- **Xcode 15+**  
- **iOS 16+**  trying to make it 11+
- **Swift 5.7+**  

### **🚀 Steps to Run**
1️⃣ Clone the repository:
```sh
git clone https://github.com/your-repo/alarm-app.git
```
2️⃣ Open the project in Xcode:
```sh
cd alarm-app
open AlarmApp.xcodeproj
```
3️⃣ Run the app on an **iPhone simulator** or **real device**.  

---

## **📂 Project Structure**
```
📦 AlarmApp
 ┣ 📂 Models
 ┃ ┗ 📄 Alarm.swift       // Alarm model
 ┣ 📂 Views
 ┃ ┣ 📄 ContentView.swift // Main UI
 ┃ ┗ 📄 AlarmRow.swift    // UI for displaying alarms
 ┣ 📂 Utils
 ┃ ┗ 📄 AlarmManager.swift // Handles scheduling & notifications
 ┣ 📄 AlarmApp.swift      // Entry point of the app
 ┗ 📄 README.md           // Project documentation
```

---

## **🔔 Managing Alarms**
### **🔹 Creating an Alarm**
1. Select time using **DatePicker**.  
2. Add an optional **reason**.  
3. Choose **repeat days** or **one-time alarm**.  
4. Select an **alarm sound**.  
5. Tap **"Save Alarm"** – It will be stored & scheduled.  

### **📝 Editing an Alarm**
- Swipe **left** on an alarm → Tap **Edit**.  
- Modify settings → Tap **Update Alarm**.  

### **🗑️ Deleting an Alarm**
- Swipe **left** on an alarm → Tap **Delete**.  
- Alarm will be removed from **storage & notifications**.  

---

## **🛠️ Troubleshooting**
### **1️⃣ Alarm Doesn't Ring?**
- Ensure **notification permissions** are granted:  
  👉 Go to **Settings > Notifications > Alarm App > Allow Notifications**.  

### **2️⃣ Alarm Still Rings After Deleting?**
- App now **removes scheduled notifications** when deleting an alarm.  
- Restart the app if the issue persists.  

### **3️⃣ Dark Mode Toggle Not Showing?**
- Toggle is in the **top-right corner (Toolbar)**.  
- Ensure `NavigationView` is used.  

---

## **🚀 Future Improvements**
- **Snooze Functionality**  
- **Custom Alarm Sounds from User Library**  
- **Vibration & Silent Mode Options**  
- **Widgets & Lock Screen Integration**  

---

## **📜 License**
This project is **open-source** and available under the MIT License.  

---

## **📩 Contributing**
Contributions are welcome! Fork the repo, create a branch, and submit a **pull request**.  

---

### **💡 Need Help?**
📧 Contact: **aleenatreezleejoy@gmail.com**  
🐦 Twitter: 

---

### **🚀 Enjoy Using Alarm App!**
Let me know if you want to customize anything! 🚀🔔📲
