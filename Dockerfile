# Dockerfile (웹앱 전용)

# 가볍고 효율적인 slim 버전을 베이스로 사용
FROM python:3.12-slim

# 환경 변수 설정
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 작업 디렉토리 설정
WORKDIR /app

# mysqlclient 설치에 필요한 시스템 개발 도구 먼저 설치
RUN apt-get update && apt-get install -y build-essential libmysqlclient-dev && rm -rf /var/lib/apt/lists/*

# 의존성 파일 먼저 복사
COPY requirements.txt .

# 의존성 설치 (캐시 없이 깔끔하게)
RUN pip install --no-cache-dir -r requirements.txt

# 프로젝트 전체 파일 복사
COPY . .

# Gunicorn으로 Django 앱 실행
ENTRYPOINT ["gunicorn", "-c", "gunicorn.conf.py"]
EXPOSE 8000