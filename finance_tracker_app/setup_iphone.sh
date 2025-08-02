#!/bin/bash

echo "🚀 Finance Tracker App - iPhone Setup Script"
echo "=============================================="

# Check if Xcode is installed
echo "📱 Checking Xcode installation..."
if [ ! -d "/Applications/Xcode.app" ]; then
    echo "❌ Xcode not found!"
    echo "📥 Please install Xcode from the App Store:"
    echo "   https://apps.apple.com/us/app/xcode/id497799835"
    echo ""
    echo "After installing Xcode, run this script again."
    exit 1
else
    echo "✅ Xcode found!"
fi

# Configure Xcode
echo "🔧 Configuring Xcode..."
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Check if CocoaPods is installed
echo "📦 Checking CocoaPods..."
if ! command -v pod &> /dev/null; then
    echo "📥 Installing CocoaPods..."
    sudo gem install cocoaPods
else
    echo "✅ CocoaPods found!"
fi

# Clean Flutter project
echo "🧹 Cleaning Flutter project..."
flutter clean
flutter pub get

# Check connected devices
echo "📱 Checking connected devices..."
flutter devices

echo ""
echo "🔗 Please connect your iPhone via USB and trust this computer."
echo "📱 Enable Developer Mode on your iPhone:"
echo "   Settings > Privacy & Security > Developer Mode"
echo ""

read -p "Press Enter when your iPhone is connected and trusted..."

# Build for iOS
echo "🔨 Building for iOS..."
flutter build ios --release

# Deploy to iPhone
echo "📱 Deploying to iPhone..."
flutter run -d ios

echo ""
echo "🎉 Setup complete!"
echo "📱 Your Finance Tracker app should now be running on your iPhone."
echo ""
echo "📋 Next steps:"
echo "1. Grant SMS permission when prompted"
echo "2. Test with sample SMS from sample_financial_sms.txt"
echo "3. Check the dashboard for transactions"
echo ""
echo "📖 For detailed instructions, see: ios_setup_guide.md" 