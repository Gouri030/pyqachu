# PyQachu

CPYQ Bank project with Django backend and Flutter mobile app.

## Setup

### Backend (Django)
```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

## What it does

- Django REST API backend
- Flutter mobile app frontend

## Tech Stack

- **Backend:** Django, SQLite
- **Mobile:** Flutter (Android)