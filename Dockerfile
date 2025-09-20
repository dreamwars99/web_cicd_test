# --- 1단계: 빌드 스테이지 (무거운 라이브러리 설치) ---
FROM python:3.12 AS builder

WORKDIR /app
COPY requirements.txt .

# CPU 전용 경량화 토치 설치 (이미지 크기 줄이는 마법)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu

# --- 2단계: 최종 스테이지 (가벼운 최종 이미지) ---
FROM python:3.12-slim

WORKDIR /app

# 빌드 스테이지에서 설치된 라이브러리만 복사
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# 프로젝트 전체 코드를 복사 (이제 .dockerignore 덕분에 안전해)
COPY . .

# Gunicorn으로 Django 앱 실행 (네 프로젝트 이름에 맞게 수정)
# KB_FinAIssist 폴더 안에 wsgi.py 파일이 있으니 이게 맞아.
CMD ["gunicorn", "KB_FinAIssist.wsgi:application", "--bind", "0.0.0.0:8000"]