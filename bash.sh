#!/bin/bash

# 크기 선언
DEFAULT_SIZE=256

size=$DEFAULT_SIZE
nick_name="small"

# 변환 대상 디렉토리 설정
target_dir=""

# 도움말 메시지
help_message() {
    echo "이미지 변환 스크립트"
    echo "사용법: $0 [옵션]"
    echo "옵션:"
    echo "  -d, --dir           대상 디렉토리 (필수 입력값)"
    echo "  -s, --size SIZE     이미지 크기 (기본: $DEFAULT_SIZE)"
    echo "  -n, --name          이미지 중간이름 (기본: 이미지 크기)"
    echo "  -h, --help          도움말 메시지 출력"
    exit 1
}

# 명령행 인수 처리
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--size)
            size="$2"
            shift
            shift
            ;;
        -n|--name)
            nick_name="$2"
            shift
            shift
            ;;
        -d|--dir)
            target_dir="$2"
            shift
            shift
            ;;
        -h|--help)
            help_message
            ;;
        *)
            echo "알 수 없는 옵션: $1"
            help_message
            ;;
    esac
done

if [ -z "$target_dir" ]; then
	echo "오류: 대상 디렉토리를 지정하세요."
	help_message
fi


# 스크립트 실행 문구
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "이미지 변환을 시작합니다. [시작시간: $start_time]"
echo "사용된 크기: $size"
echo "사용된 별명: $nick_name"
echo "대상 디렉터리: $target_dir"

# 함수 정의: 이미지 변환
convert_image() {
    local count_success=0
    local count_failure=0
    local count_skip=0

    local target_dir=$1
    local size=$2
    
    local total_files=$(find "$target_dir" -type f -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" | wc -l)
    local current_file=0

    echo "$total_files 개의 파일에 대한 작업 시작"

    # 대, 소문자 구분 없이 탐색 활성화
    shopt -s nocaseglob
    for file in "$target_dir"/*.{jpeg,jpg,png,gif}; do
	    # 대, 소문자 구분 없이 탐색 비활성화
	    shopt -u nocaseglob

	    if [ -f "$file" ]; then # 파일인 경우에만 처리
		    filename_full=$(basename "$file")
		    extension="${filename##*.}" # 확장자 추출
		    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')  # 확장자 소문자로 변환
		    filename="${filename_full%.*}"

		    output_file="$target_dir/${filename}.${nick_name}.webp"
		    if [ -e "$output_file" ]; then # 이미 존재하는 파일이라면 생략
			    ((count_skip+=1))
		    else
			    # 여기에 이미지 압축!
			    node resize.js -d "$target_dir" -i "$filename_full" -s "$size" -n "$nick_name"

			    if [ $? -ne 0 ]; then
				    echo "변환 실패: $file -> $output_file" >> "$error_log"
				    ((count_failure++))
			    else
				    ((count_success++))
			    fi
		    fi
	    fi
	    
	    # 진행 바 업데이트
	    ((current_file++))
	    progress=$((current_file * 100 / total_files))
	    printf "\r진행도: [%-100s] %d%%" $(printf "%*s" "$progress" | tr ' ' '=') "$progress"
    done
    echo ""
    echo "SIZE $width 변환 실패 파일 개수: $count_failure"
    echo "SIZE $width 변환 성공 파일 개수: $count_success"
    echo "SIZE $width 변환 생략 파일 개수: $count_skip"
}

# 이미지 변환 함수 호출
convert_image "$target_dir" "$size"

echo "이미지 변환이 완료되었습니다"
