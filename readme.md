# 피움 사진 최적화

## 이게 뭐죠?

[피움](https://pium.life) 서비스에서 이미지 최적화를 위해 크기를 조정하고 확장자를 변경하는 작업에 사용하는 코드입니다.

내부적으로 Sharp 라이브러리를 사용해서 변환합니다.    
결과물은 `.png`, `.webp` 두 가지로 제공됩니다.

## 어떻게 쓰죠?

### 설치 (node.js 필요)

```bash
git clone https://github.com/pium-official/resize-image.git
cd resize-image
npm install
```

### 실행

```bash
node resize.js --input-file pium.png
```

### 커맨드라인 옵션

|이름|축약형|설명|기본값|
|:-:|:-:|:-:|:-:|
|`--input-file`|`-i`|변환을 진행할 파일 이름. <br/> 확장자를 포함하고, 디렉토리명은 포함하지 않아야 합니다.|-|
|`--dir`|`-d`|변환할 파일이 있는 디렉토리 경로. <br/> 결과물 역시 이 위치에 생성됩니다.|`.`|
|`--size`|`-s`|목표로 하는 사진 가로길이 (픽셀) <br/> 결과물의 가로 길이입니다. 세로길이는 원본의 비율에 맞춰요.|`256`|
|`--nickname`|`-n`|해당 변환의 크기에 관한 별명입니다. <br/>[피움의 '별명' 규칙](https://github.com/woowacourse-teams/2023-pium/discussions/384)|`x-small`|

### 예시

```bash
#실행
node resize.js -dir static -i pium.gif -s 512 -n small

#원본 위치
./static/pium.gif

#결과물 위치
./static/pium.small.png
./static/pium.small.webp
```
