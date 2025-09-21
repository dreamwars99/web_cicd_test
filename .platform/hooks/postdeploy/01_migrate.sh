# set -e: 에러시 중단, -u: 정의 안 된 변수 에러, -o pipefail: 파이프라인 에러 전파
set -euo pipefail

# 현재 실행 중인 앱 컨테이너 ID 하나 가져오기(단일 컨테이너 전제)
CID=$(/usr/bin/docker ps --filter "name=eb" --format "{{.ID}}")

# 마이그레이션 실행
/usr/bin/docker exec "$CID" python manage.py migrate --noinput

# 정적파일 수집(이미 Dockerfile에서 했다면 생략 가능)
# /usr/bin/docker exec "$CID" python manage.py collectstatic --noinput
