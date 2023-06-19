# Prompt the user for the input file path
$inputFilePath = Read-Host "トリムする動画のファイルパスを入力してください"

# if $inputFilePath has double quotes, remove them
$inputFilePath = $inputFilePath -replace '"', ''
Write-Host "入力ファイルパス: $inputFilePath"

# check if the file exists
if (!(Test-Path $inputFilePath)) {
    Write-Host "ファイルが存在しません。"
    exit
}

# convert to absolute path, if necessary
if (!(Test-Path -PathType Leaf $inputFilePath)) {
    $inputFilePath = Resolve-Path $inputFilePath
}

# function which converts HH:MM:SS to seconds
function ConvertToSeconds($time) {
    # Split the time into hours, minutes, and seconds
    $timeParts = $time -split ':'

    # Convert the time parts to integers
    $hours = [int]$timeParts[0]
    $minutes = [int]$timeParts[1]
    $seconds = [int]$timeParts[2]

    # Calculate the total number of seconds
    $totalSeconds = $hours * 3600 + $minutes * 60 + $seconds

    # Return the total number of seconds
    return $totalSeconds
}

# Prompt the user for the start time of the portion to extract
Write-Host ""
$startTime = Read-Host "トリム開始時刻(HH:MM:SS)を入力してください"
# convert HH:MM:SS to seconds
$startTime = ConvertToSeconds($startTime)
Write-Host "トリム開始時刻(秒): $startTime"

# Prompt the user for the end time of the portion to extract
Write-Host ""
$endTime = Read-Host "トリム修了時刻(HH:MM:SS)を入力してください"
# convert HH:MM:SS to seconds
$endTime = ConvertToSeconds($endTime)
Write-Host "トリム修了時刻(秒): $endTime"

# generate output file name
# get the file name without extension and append "_trimmed" to it
# extension is the same as the input file
$outputFile = $inputFilePath -replace "\.[^.]+$", "_trimmed$&"

# write out final command to be executed and ask for confirmation
Write-Host ""
Write-Host "ffmpeg -i $inputFilePath -ss $startTime -to $endTime -c:v copy -c:a copy $outputFile"
$confirm = Read-Host "上記のコマンドを実行しますか？(y/n)"
if ($confirm -ne "y") {
    exit
}


# Extract the specified portion of the video without loss of quality
ffmpeg -i $inputFilePath -ss $startTime -to $endTime -c:v copy -c:a copy $outputFile
