# --- 1단계: 빌드 스테이지 (무거운 것들 설치하는 작업장) ---
# 여기서 모든 라이브러리를 설치할 거야.
FROM python:3.12 AS builder

WORKDIR /app

# requirements.txt 복사
COPY requirements.txt .

# 라이브러리 설치 (이 과정이 무거움)
RUN pip install --upgrade pip && pip install -r requirements.txt


# --- 2단계: 최종 스테이지 (깨끗하고 가벼운 최종 이미지) ---
# 완전히 새로운, 깨끗한 파이썬 이미지에서 시작
FROM python:3.12

WORKDIR /app

# 중요! 1단계(builder)에서 설치한 라이브러리 파일들만 쏙 빼서 복사해오는 마법 같은 명령어
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# 이제 네 소스 코드를 복사
COPY . .

# 서버 실행
CMD ["gunicorn", "--config", "gunicorn.conf.py", "config.wsgi:application"]