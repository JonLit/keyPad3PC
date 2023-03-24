# keyPad3PC
KeyPad (PC Companion Program)


# Usage
1. Install APK on Android Phone (https://github.com/jonlit/keypad3)
2. Install Companion Program on PC
3. Install ADB
4. Connect Phone with USB Cable
5. Run `adb forward tcp:8025 tcp:8025` on PC (on windows with CMD, on Linux in your preferred Terminal)
6. Start App on Phone
7. Start Companion Program on PC

To see if it works:
Try tapping on your phone, you should see the small window on the Companion Program flash Black/White accordingly.

# LICENSES

Ketai (for getting IP Address): https://github.com/ketai/ketai/blob/master/LICENSE.txt  
websockets (for communication to/from PC): https://github.com/alexandrainst/processing_websockets/blob/master/LICENSE
