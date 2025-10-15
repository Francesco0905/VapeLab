#!/bin/bash

# VapeLab Setup Script
# This script helps you set up the VapeLab development environment

set -e

echo "🚀 VapeLab Setup Script"
echo "======================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"
flutter --version
echo ""

# Check Flutter doctor
echo "🔍 Running Flutter doctor..."
flutter doctor
echo ""

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
echo ""

# Check for environment variables
echo "🔐 Checking environment variables..."
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "⚠️  Environment variables not set"
    echo ""
    echo "Please set the following environment variables:"
    echo "  export SUPABASE_URL=your_supabase_url"
    echo "  export SUPABASE_ANON_KEY=your_supabase_anon_key"
    echo ""
    echo "Or copy .env.example to .env and fill in your values"
    echo ""
else
    echo "✅ Environment variables are set"
    echo ""
fi

# Run tests
echo "🧪 Running tests..."
flutter test || echo "⚠️  Some tests failed or no tests found"
echo ""

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze || echo "⚠️  Code analysis found issues"
echo ""

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Make sure Supabase is configured (see DEPLOYMENT.md)"
echo "2. Run the app with: flutter run -d chrome --dart-define=SUPABASE_URL=\$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=\$SUPABASE_ANON_KEY"
echo "3. Build for production: flutter build web --release --dart-define=SUPABASE_URL=\$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=\$SUPABASE_ANON_KEY"
echo ""
echo "📚 Read the documentation:"
echo "  - README.md - Getting started"
echo "  - ARCHITECTURE.md - Technical details"
echo "  - DEPLOYMENT.md - Deployment guide"
echo "  - CONTRIBUTING.md - Contributing guidelines"
