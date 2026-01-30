#!/bin/bash
# macOS 앱 번들(.app) 빌드 스크립트

echo "========================================"
echo "macOS 앱 번들 빌드 스크립트"
echo "========================================"
echo ""

# Python이 설치되어 있는지 확인
if ! command -v python3 &> /dev/null; then
    echo "오류: Python3이 설치되어 있지 않습니다."
    exit 1
fi

echo "Python 버전 확인:"
python3 --version
echo ""

# 필요한 패키지 설치
echo "필요한 패키지를 설치하는 중..."
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt
echo ""

# 기존 빌드 파일 정리
echo "기존 빌드 파일을 정리하는 중..."
rm -rf build dist *.spec
echo ""

# PyInstaller로 앱 번들 생성
echo "앱 번들을 빌드하는 중..."
python3 -m PyInstaller --windowed --name "유니코드제거기" --icon=NONE app.py
echo ""

# 콘솔 버전도 함께 빌드 (앱 번들은 GUI용이므로 콘솔 버전도 필요)
echo "콘솔 실행 파일도 빌드하는 중..."
python3 -m PyInstaller --onefile --console --name "유니코드제거기" app.py
echo ""

if [ -d "dist/유니코드제거기.app" ]; then
    echo "========================================"
    echo "빌드 완료!"
    echo "========================================"
    echo "앱 번들 위치: dist/유니코드제거기.app"
    echo "콘솔 실행 파일 위치: dist/유니코드제거기"
    echo ""
    echo "앱 번들을 Applications 폴더로 복사하거나"
    echo "더블클릭하여 실행할 수 있습니다."
else
    echo "========================================"
    echo "빌드 실패"
    echo "========================================"
    echo "오류가 발생했습니다. 위의 메시지를 확인하세요."
    exit 1
fi
