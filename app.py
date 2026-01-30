#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
유니코드 특수 공백 문자 제거기
SMS/MMS에서 공백이 ?로 표시되는 문제를 해결합니다.
"""

import re
import sys


def remove_unicode_spaces(text):
    """
    특수 유니코드 공백 문자를 일반 공백(U+0020)으로 변환합니다.
    
    주요 변환 대상:
    - U+00A0: Non-breaking space (줄바꿈 없는 공백)
    - U+2000-U+200B: 다양한 종류의 공백들
    - U+3000: 전각 공백 (일본어/중국어)
    - U+FEFF: Zero-width no-break space
    - 기타 특수 공백 문자들
    """
    # 일반 공백(U+0020)을 제외한 모든 유니코드 공백 문자를 일반 공백으로 변환
    # 주요 유니코드 공백 문자 범위:
    # - \u00A0: Non-breaking space
    # - \u2000-\u200B: 다양한 공백들 (en space, em space, thin space 등)
    # - \u202F: Narrow no-break space
    # - \u205F: Medium mathematical space
    # - \u3000: Ideographic space (전각 공백)
    # - \uFEFF: Zero-width no-break space
    # - \u00AD: Soft hyphen (하이픈)
    
    # 정규식으로 모든 특수 공백을 일반 공백으로 변환
    text = re.sub(r'[\u00A0\u00AD\u2000-\u200B\u202F\u205F\u3000\uFEFF]', ' ', text)
    
    # 연속된 공백을 하나로 정리 (선택사항)
    text = re.sub(r' +', ' ', text)
    
    return text


def clean_text_for_sms(text):
    """
    SMS 전송을 위해 텍스트를 정리합니다.
    특수 유니코드 공백을 제거하고, 일반적으로 문제가 되는 문자들을 처리합니다.
    """
    # 특수 공백 제거
    text = remove_unicode_spaces(text)
    
    # 줄 끝의 공백 제거 (선택사항)
    lines = text.split('\n')
    lines = [line.rstrip() for line in lines]
    text = '\n'.join(lines)
    
    return text


def main():
    """메인 함수"""
    if len(sys.argv) > 1:
        # 파일 경로가 제공된 경우
        file_path = sys.argv[1]
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                text = f.read()
            
            cleaned_text = clean_text_for_sms(text)
            
            # 결과를 파일에 저장
            output_path = file_path.replace('.txt', '_cleaned.txt') if file_path.endswith('.txt') else file_path + '_cleaned'
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(cleaned_text)
            
            print(f"정리된 텍스트가 '{output_path}'에 저장되었습니다.")
            print("\n변환 결과:")
            print("-" * 50)
            print(cleaned_text)
            print("-" * 50)
            
        except FileNotFoundError:
            print(f"오류: 파일 '{file_path}'을(를) 찾을 수 없습니다.")
        except Exception as e:
            print(f"오류 발생: {e}")
    else:
        # 대화형 모드
        print("=" * 50)
        print("유니코드 특수 공백 문자 제거기")
        print("=" * 50)
        print("\n텍스트를 입력하세요 (여러 줄 입력 가능, 빈 줄 두 번 입력하면 종료):\n")
        
        lines = []
        empty_count = 0
        
        while True:
            try:
                line = input()
                if line == '':
                    empty_count += 1
                    if empty_count >= 2:
                        break
                    lines.append('')
                else:
                    empty_count = 0
                    lines.append(line)
            except EOFError:
                break
        
        text = '\n'.join(lines)
        cleaned_text = clean_text_for_sms(text)
        
        print("\n" + "=" * 50)
        print("정리된 텍스트:")
        print("=" * 50)
        print(cleaned_text)
        print("=" * 50)
        
        # 클립보드에 복사할지 물어보기 (선택사항)
        try:
            import pyperclip
            copy = input("\n클립보드에 복사하시겠습니까? (y/n): ").lower().strip()
            if copy == 'y':
                pyperclip.copy(cleaned_text)
                print("클립보드에 복사되었습니다!")
        except ImportError:
            pass


if __name__ == '__main__':
    # 예제: 현재 파일에 있는 텍스트를 직접 처리하려면 아래 주석을 해제하세요
    # sample_text = """[NAME] 고객님
    # 안녕하세요.
    # feura입니다.
    # 
    # 고객님께서 알림을 신청하신 게시글에
    # 새로운 댓글이 등록되어 안내드립니다.
    # 
    # 고객님께서 작성하신
    # [BOARD_NAME] 게시판의
    # '[SUBJECT]' 글에
    # 새로운 댓글이 등록되었습니다.
    # 
    # 해당 게시글의 댓글은
    # 이용하신 사이트를 통해
    # 확인하실 수 있습니다.
    # 
    # ※ 본 알림은
    # 고객님의 댓글 알림 신청에 의해
    # 댓글이 등록될 경우 발송됩니다.
    # 
    # 게시판 이용과 관련해
    # 궁금한 점이 있거나
    # 도움이 필요하신 경우
    # 언제든지 편하게 문의 남겨주세요.
    # 
    # 감사합니다.
    # 
    # feura드림"""
    # 
    # cleaned = clean_text_for_sms(sample_text)
    # print("정리된 텍스트:")
    # print(cleaned)
    # print("\n" + "="*50)
    
    main()
