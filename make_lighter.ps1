$input_path = Read-Host "軽量化したい動画のパスを入力してください"

$fileName = [System.IO.Path]::GetFileNameWithoutExtension($input_path)  
$output_path = (Split-Path -Parent input_path) + $fileName + "_light.mp4"
ffmpeg -i $input_path -crf 28 $output_path