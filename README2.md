
# Git 저장소 환경 문제 해결 가이드 (AI 어시스턴트용)

이 문서는 Windows 환경에서 Git으로 작업하고 Linux 환경으로 배포할 때 흔히 발생하는 줄바꿈(Line Ending) 및 파일 실행 권한 문제를 해결하는 방법을 안내합니다.

각 단계의 명령어는 AI 어시스턴트가 인식하고 실행할 수 있도록 셸 코드 블록으로 제공됩니다.

---

### 1단계: `.gitattributes` 파일 생성 및 수정

프로젝트의 모든 파일에 일관된 줄바꿈 규칙을 적용하기 위해 `.gitattributes` 파일을 생성하고 설정합니다.

**실행할 명령어:**
```sh
echo "* text=auto" > .gitattributes
echo "*.sh text eol=lf" >> .gitattributes
```

---

### 2단계: 로컬 Git 저장소 설정

현재 저장소에만 적용되는 로컬 Git 설정을 변경하여, Windows 환경에서 발생할 수 있는 줄바꿈 문제를 방지합니다.

**실행할 명령어:**
```sh
git config --local core.autocrlf false
git config --local core.eol lf
```

---

### 3단계: 전체 파일 줄바꿈 재정규화 및 커밋

새로운 줄바꿈 규칙을 프로젝트의 모든 기존 파일에 소급 적용하고, 변경사항을 커밋으로 기록합니다.

**실행할 명령어:**
```sh
git add --renormalize .
git commit -m "Normalize line endings to LF"
```

---

### 4단계: 배포 스크립트 실행 권한 추가 및 커밋

배포 서버(Linux)에서 실행되어야 할 셸 스크립트에 실행 권한을 부여하고, 변경사항을 커밋으로 기록합니다.

**참고:** 아래 명령어에서 스크립트 파일 경로는 실제 프로젝트에 맞게 수정해야 할 수 있습니다. (이 예시에서는 `c:\Workspaces\web_cicd_test\.platform\hooks\postdeploy\01_migrate.sh` 를 사용합니다.)

**실행할 명령어:**
```sh
git add --chmod=+x .platform/hooks/postdeploy/01_migrate.sh
git commit -m "Make postdeploy hook executable"
```

---

### 5단계: 원격 저장소에 변경사항 푸시

위 모든 변경사항을 원격 저장소에 푸시하여 최종 반영합니다.

**실행할 명령어:**
```sh
git push
```
