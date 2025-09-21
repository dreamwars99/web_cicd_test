# Dockerfile (웹앱 전용)

# 가볍고 효율적인 slim 버전을 베이스로 사용
FROM python:3.12

# 환경 변수 설정
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 파일 먼저 복사
COPY requirements.txt .

# 의존성 설치 (캐시 없이 깔끔하게)
RUN pip install --no-cache-dir -r requirements.txt

# 프로젝트 전체 파일 복사
COPY . .

RUN python manage.py collectstatic --noinput

# Gunicorn으로 Django 앱 실행
ENTRYPOINT ["gunicorn", "KB_FinAIssist.asgi:application", "-c", "gunicorn.conf.py"]
EXPOSE 8000