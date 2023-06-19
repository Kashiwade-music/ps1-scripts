# CQ = x12.8
# CRF = x10.2

foreach($files in $(Get-ChildItem -Recurse)) {
    if (-not ($files.BaseName -match "^CRF_28_")) {
        if (-not ($files.BaseName -match "^CQ_35_")){
            if (($($files.Extension) -eq ".mkv") -or ($($files.Extension) -eq ".mp4")) {
                Write-Host $files.FullName
                $sum=$sum+$files.Length
            }
        }
        
    }
}

#選択肢の作成
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","実行する")
$no  = new-object $typename("&No","実行しない")

#選択肢コレクションの作成
$assembly= $yes.getType().AssemblyQualifiedName
$choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$choice.add($yes)
$choice.add($no)

#選択プロンプトの表示
$answer = $host.ui.PromptForChoice("<実行確認>","実行しますか？",$choice,0)

if ($answer -eq 0){
    foreach($files in $(Get-ChildItem -Recurse)){
        if (-not ($files.BaseName -match "^CRF_28_")) {
            if (-not ($files.BaseName -match "^CQ_35_")){
                if ($($files.Extension) -eq ".mkv" -or $($files.Extension) -eq ".mp4") {
                    $newName = "CQ_35_" + $files.BaseName + ".mp4"
                    # Write-Host $newName
                    ffmpeg -i $files.FullName -c:v h264_nvenc -cq 35 $newName
                }
            }
        }
    }
    Write-Host "completed"
    Pause
}else{
    Write-Host "cancel"
    Pause
}
