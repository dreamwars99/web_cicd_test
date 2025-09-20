# # Dockerfile

# # Python 3.12 이미지를 기반으로 사용
# FROM python:3.12

# # 환경 변수 설정
# # .pyc 파일 생성 방지
# ENV PYTHONDONTWRITEBYTECODE=1

# # Python 출력 버퍼링 방지
# ENV PYTHONUNBUFFERED=1

# # 작업 디렉토리 생성 및 설정 (그냥 app 으로 작성해도 돰) !!!!
# WORKDIR /app

# # 의존성 파일 복사 및 설치
# COPY requirements.txt .
# RUN pip install --upgrade pip && pip install -r requirements.txt

# # 프로젝트 파일을 image 내부 WORKDIR로 복사
# COPY . .

# # Gunicorn으로 Django 실행
# ENTRYPOINT ["gunicorn", "-c", "gunicorn.conf.py"]
# EXPOSE 8000

# --- 1단계: 빌드 스테이지 (무거운 라이브러리 설치) ---
FROM python:3.12 AS builder

WORKDIR /app
COPY requirements.txt .

# CPU 전용 경량화 토치 설치 (이미지 크기 줄이는 마법!)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu

# --- 2단계: 최종 스테이지 (가벼운 최종 이미지) ---
FROM python:3.12-slim 
WORKDIR /app

# 빌드 스테이지에서 설치된 라이브러리만 쏙 빼서 복사
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# 프로젝트 전체 코드를 복사
COPY . .

# Gunicorn으로 Django 앱 실행
CMD ["gunicorn", "KB_FinAIssist.wsgi:application", "--bind", "0.0.0.0:8000"]