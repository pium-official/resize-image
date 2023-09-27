import { join } from 'path';
import { Command } from 'commander';
import sharp from 'sharp';

// 변환 함수
const convertImageTo = async (dir, filename, width, type, format) => {
  const filenameWithoutExt = filename.split('.')[0];
  const inputPath = join(dir, filename);
  const outputPath = join(dir, `${filenameWithoutExt}.${type}.${format.toLowerCase()}`);

  const image = sharp(inputPath);
  const { width: imageWidth } = await image.metadata();
  
  // 이미지가 목표보다 이미 작을 경우 굳이 조정하지 않음
  if (imageWidth <= width) {
    await image
      .withMetadata()
      .toFile(outputPath);

    return false;
  }

  await image
    .resize(width)
    .withMetadata()
    .toFormat(format.toLowerCase(), { quality: 100 })
    .toFile(outputPath);

  return true;
};

// 커맨드라인 옵션 읽어오기
const program = new Command();

program
  .option('-i --input-file <filename>', '대상 파일명 (확장자를 포함하고 디렉토리는 포함하지 않음)')
  .option('-d --dir <directory>', '대상 디렉토리', '.')
  .option('-s --size <pixel>', '목표로 하는 사진 크기(픽셀, 가로길이)', '256')
  .option('-n --nickname <nickname>', '파일명 중간에 들어갈 크기 별명', 'x-small');

program.parse(process.argv);

const { inputFile, dir, size, nickname } = program.opts();

// 커맨드라인 옵션 검사
if (!inputFile) {
  console.log('[오류] --input-file 옵션은 무조건 주어져야 합니다!');
  process.exit(-1);
}

// 변환
convertImageTo(dir, inputFile, Number(size), nickname, 'webp');
convertImageTo(dir, inputFile, Number(size), nickname, 'png');
