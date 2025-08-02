#!/bin/bash

# 🚀 Finance Tracker PWA Deployment Script
# This script automates the deployment of your PWA to various platforms

echo "🚀 Starting Finance Tracker PWA Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter first."
        exit 1
    fi
    print_success "Flutter is installed"
}

# Clean and build the PWA
build_pwa() {
    print_status "Cleaning previous build..."
    flutter clean
    
    print_status "Getting dependencies..."
    flutter pub get
    
    print_status "Building PWA for production..."
    flutter build web --release
    
    if [ $? -eq 0 ]; then
        print_success "PWA built successfully!"
    else
        print_error "Failed to build PWA"
        exit 1
    fi
}

# Check if build was successful
check_build() {
    print_status "Verifying build files..."
    
    if [ ! -f "build/web/index.html" ]; then
        print_error "index.html not found. Build may have failed."
        exit 1
    fi
    
    if [ ! -f "build/web/manifest.json" ]; then
        print_error "manifest.json not found. PWA may not work correctly."
        exit 1
    fi
    
    if [ ! -f "build/web/main.dart.js" ]; then
        print_error "main.dart.js not found. App may not load."
        exit 1
    fi
    
    print_success "All build files verified!"
}

# Deploy to local server for testing
deploy_local() {
    print_status "Starting local server for testing..."
    
    cd build/web
    
    # Check if port 8000 is available
    if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
        print_warning "Port 8000 is already in use. Using port 8001..."
        PORT=8001
    else
        PORT=8000
    fi
    
    print_success "PWA is running at: http://localhost:$PORT"
    print_status "Press Ctrl+C to stop the server"
    
    python3 -m http.server $PORT
}

# Deploy to GitHub Pages
deploy_github() {
    print_status "Setting up GitHub Pages deployment..."
    
    if [ -z "$1" ]; then
        print_error "Please provide your GitHub username: ./deploy_pwa.sh github YOUR_USERNAME"
        exit 1
    fi
    
    GITHUB_USERNAME=$1
    REPO_NAME="finance-tracker-pwa"
    
    cd build/web
    
    print_status "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial PWA deployment"
    
    print_status "Setting up remote repository..."
    git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
    git branch -M main
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        print_success "PWA deployed to GitHub!"
        print_success "Your app will be available at: https://$GITHUB_USERNAME.github.io/$REPO_NAME"
        print_warning "Don't forget to enable GitHub Pages in your repository settings!"
    else
        print_error "Failed to deploy to GitHub. Please check your repository setup."
        exit 1
    fi
}

# Show deployment options
show_options() {
    echo ""
    echo "🎯 Available Deployment Options:"
    echo ""
    echo "1. Local Testing:"
    echo "   ./deploy_pwa.sh local"
    echo ""
    echo "2. GitHub Pages:"
    echo "   ./deploy_pwa.sh github YOUR_USERNAME"
    echo ""
    echo "3. Manual Deployment:"
    echo "   ./deploy_pwa.sh manual"
    echo ""
    echo "4. Build Only:"
    echo "   ./deploy_pwa.sh build"
    echo ""
}

# Manual deployment instructions
manual_deployment() {
    echo ""
    echo "📋 Manual Deployment Instructions:"
    echo ""
    echo "Your PWA files are ready in: build/web/"
    echo ""
    echo "🌐 Deploy to Netlify (Free):"
    echo "1. Go to https://netlify.com"
    echo "2. Sign up for free account"
    echo "3. Click 'Deploy manually'"
    echo "4. Drag and drop the build/web folder"
    echo "5. Get instant URL"
    echo ""
    echo "🚀 Deploy to Vercel (Free):"
    echo "1. Go to https://vercel.com"
    echo "2. Sign up for free account"
    echo "3. Click 'New Project'"
    echo "4. Import your GitHub repository"
    echo "5. Auto-deploy"
    echo ""
    echo "📱 Install on iPhone:"
    echo "1. Open Safari on iPhone"
    echo "2. Go to your deployed URL"
    echo "3. Tap 'Share' button"
    echo "4. Tap 'Add to Home Screen'"
    echo "5. Use like native app!"
    echo ""
}

# Main script logic
case "$1" in
    "local")
        check_flutter
        build_pwa
        check_build
        deploy_local
        ;;
    "github")
        check_flutter
        build_pwa
        check_build
        deploy_github $2
        ;;
    "manual")
        check_flutter
        build_pwa
        check_build
        manual_deployment
        ;;
    "build")
        check_flutter
        build_pwa
        check_build
        print_success "PWA built successfully! Files are in build/web/"
        ;;
    *)
        print_status "Finance Tracker PWA Deployment Script"
        show_options
        ;;
esac 