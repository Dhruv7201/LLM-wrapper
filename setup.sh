#!/bin/bash

# Define the project name
PROJECT_NAME=${1:-fastapi_project}

# Create the base directory
mkdir -p $PROJECT_NAME/app/{routes,models,db,utils,tests}

# Create empty Python files with initial boilerplate
touch $PROJECT_NAME/app/__init__.py
touch $PROJECT_NAME/app/routes/{__init__.py,users.py,items.py}
touch $PROJECT_NAME/app/models/{__init__.py,user.py,item.py}
touch $PROJECT_NAME/app/db/{__init__.py,session.py}
touch $PROJECT_NAME/app/utils/{__init__.py,hashing.py,dependencies.py}
touch $PROJECT_NAME/app/tests/{__init__.py,test_users.py,test_items.py}

# Create main.py
cat > $PROJECT_NAME/app/main.py << 'EOF'
from fastapi import FastAPI
from app.routes import users, items

app = FastAPI()

app.include_router(users.router, prefix="/users", tags=["Users"])
app.include_router(items.router, prefix="/items", tags=["Items"])

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="127.0.0.1", port=8000, reload=True)
EOF

# Create config.py
cat > $PROJECT_NAME/app/config.py << 'EOF'
from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "My FastAPI App"
    admin_email: str = "admin@example.com"
    database_url: str = "sqlite:///./test.db"

    class Config:
        env_file = ".env"

settings = Settings()
EOF

# Create users.py route
cat > $PROJECT_NAME/app/routes/users.py << 'EOF'
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_users():
    return [{"id": 1, "name": "John Doe"}]
EOF

# Create items.py route
cat > $PROJECT_NAME/app/routes/items.py << 'EOF'
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_items():
    return [{"id": 1, "name": "Item A"}]
EOF

# Create user model
cat > $PROJECT_NAME/app/models/user.py << 'EOF'
from sqlalchemy import Column, Integer, String
from app.db.session import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
EOF

# Create session.py
cat > $PROJECT_NAME/app/db/session.py << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

from app.config import settings

SQLALCHEMY_DATABASE_URL = settings.database_url

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
EOF

# Create hashing.py
cat > $PROJECT_NAME/app/utils/hashing.py << 'EOF'
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
EOF

# Create test for users
cat > $PROJECT_NAME/app/tests/test_users.py << 'EOF'
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_get_users():
    response = client.get("/users/")
    assert response.status_code == 200
    assert response.json() == [{"id": 1, "name": "John Doe"}]
EOF

# Create requirements.txt
cat > $PROJECT_NAME/requirements.txt << 'EOF'
fastapi
uvicorn
sqlalchemy
passlib[bcrypt]
EOF

# Create README.md
cat > $PROJECT_NAME/README.md << 'EOF'
# FastAPI Project

This is a modular FastAPI project structure.

## Setup

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
