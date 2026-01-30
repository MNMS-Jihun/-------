@echo off
chcp 65001 >nul
echo ========================================
echo Windows 실행 파일 빌드 스크립트
echo ========================================
echo.

REM Python이 설치되어 있는지 확인
python --version >nul 2>&1
if errorlevel 1 (
    echo 오류: Python이 설치되어 있지 않습니다.
    echo Python을 먼저 설치해주세요.
    pause
    exit /b 1
)

echo Python 버전 확인:
python --version
echo.

REM 필요한 패키지 설치
echo 필요한 패키지를 설치하는 중...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
echo.

REM PyInstaller로 실행 파일 생성
echo 실행 파일을 빌드하는 중...
python -m PyInstaller --onefile --console --name "유니코드제거기" --icon=NONE app.py
echo.

if exist "dist\유니코드제거기.exe" (
    echo ========================================
    echo 빌드 완료!
    echo ========================================
    echo 실행 파일 위치: dist\유니코드제거기.exe
    echo.
    echo 이 파일을 원하는 위치로 복사해서 사용하세요.
) else (
    echo ========================================
    echo 빌드 실패
    echo ========================================
    echo 오류가 발생했습니다. 위의 메시지를 확인하세요.
)

echo.
pause
