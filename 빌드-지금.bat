@echo off
chcp 65001 >nul
echo ========================================
echo 빠른 빌드 - 완성된 EXE 파일 생성
echo ========================================
echo.

REM 현재 디렉토리 확인
cd /d "%~dp0"

REM Python 확인
python --version >nul 2>&1
if errorlevel 1 (
    echo [오류] Python이 설치되어 있지 않습니다.
    echo Python을 먼저 설치해주세요: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/3] 패키지 설치 중...
python -m pip install --upgrade pip --quiet
python -m pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo [오류] 패키지 설치 실패
    pause
    exit /b 1
)

echo [2/3] 빌드 중... (잠시만 기다려주세요)
python -m PyInstaller --onefile --console --name "UnicodeCleaner" --clean app.py
if errorlevel 1 (
    echo [오류] 빌드 실패
    pause
    exit /b 1
)

echo [3/3] 파일 이름 변경 중...
if exist "dist\UnicodeCleaner.exe" (
    copy /Y "dist\UnicodeCleaner.exe" "dist\유니코드제거기.exe" >nul
    echo ========================================
    echo 빌드 성공!
    echo ========================================
    echo.
    echo 실행 파일 위치: dist\유니코드제거기.exe
) else (
    echo [오류] 빌드된 파일을 찾을 수 없습니다.
    pause
    exit /b 1
)
echo.
echo 이 파일을 다른 사람에게 전달하시면 됩니다.
echo (Python 설치 없이도 실행 가능합니다)
echo.
pause
