{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python environment (without specific packages - those go in requirements.txt)
    python311
    python311Packages.pip
   
    openjdk11
  ];

  shellHook = ''
    echo "🚀 Full-stack development environment loaded!"
    echo ""
    echo "📱 Flutter: $(flutter --version | head -n1)"
    echo "🐍 Python: $(python --version)"
    echo "🗄️  PostgreSQL: $(pg_config --version)"
    echo ""
    echo "💡 Quick start commands:"
    echo "  Django backend:"
    echo "    cd backend"
    echo "    python -m venv venv"
    echo "    source venv/bin/activate"
    echo "    pip install -r requirements.txt"
    echo "    python manage.py runserver"
    echo ""
    echo "  Flutter frontend:"
    echo "    cd mobile"
    echo "    flutter create . --org com.example.pyqachu"
    echo "    flutter run"
    echo ""
    echo "🔧 Available tools: git, curl, httpie"
    echo ""
    
    # Create backend directory structure if it doesn't exist
    if [ ! -f backend/manage.py ]; then
      echo "📁 Backend directory is empty. You can initialize Django with:"
      echo "    cd backend && django-admin startproject pyqachu_backend ."
    fi
    
    # Check if Flutter project exists
    if [ ! -f mobile/pubspec.yaml ]; then
      echo "📱 Mobile directory is empty. You can initialize Flutter with:"
      echo "    cd mobile && flutter create . --org com.example.pyqachu"
    fi
    
    # Check if requirements.txt exists
    if [ ! -f backend/requirements.txt ]; then
      echo "📦 Don't forget to create backend/requirements.txt with your Python dependencies!"
    fi
  '';
}