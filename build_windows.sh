#!/bin/bash
# macOS/Linux에서 Windows 실행 파일을 빌드하는 스크립트 (Wine 필요)

echo "========================================"
echo "Windows 실행 파일 빌드 스크립트"
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

# PyInstaller로 실행 파일 생성 (Windows용으로 빌드하려면 Wine이 필요하지만,
# 일반적으로는 Windows에서 직접 빌드하는 것이 좋습니다)
echo "실행 파일을 빌드하는 중..."
python3 -m PyInstaller --onefile --console --name "유니코드제거기" app.py
echo ""

if [ -f "dist/유니코드제거기" ]; then
    echo "========================================"
    echo "빌드 완료!"
    echo "========================================"
    echo "실행 파일 위치: dist/유니코드제거기"
    echo ""
    echo "참고: Windows .exe 파일을 만들려면 Windows에서 build_windows.bat를 실행하세요."
else
    echo "========================================"
    echo "빌드 실패"
    echo "========================================"
    echo "오류가 발생했습니다."
fi
