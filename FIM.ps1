

Function Calculate-File-Hash($filepath) {
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}
Function Erase-Baseline-If-Already-Exists() {
    $baselineExists = Test-Path -Path C:\Users\henri\Documents\repos\FIM\baseline.txt

    if ($baselineExists) {
        # Delete it
        Remove-Item -Path C:\Users\henri\Documents\repos\FIM\baseline.txt
    }
}


Write-Host ""
Write-Host "What would you like to do?"
Write-Host ""
Write-Host "    A) Collect new Baseline?"
Write-Host "    B) Begin monitoring files with saved Baseline?"
Write-Host ""
$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

if ($response -eq "A".ToUpper()) {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate Hash from the target files and store in baseline.txt
    # Collect all files in the target folder
    $files = Get-ChildItem -Path C:\Users\henri\Documents\FimTest

    # For each file, calculate the hash, and write to baseline.txt
    foreach ($f in $files){
        $hash = Calculate-File-Hash $f.FullName
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath C:\Users\henri\Documents\repos\FIM\baseline.txt -Append
        }
    } elseif($response -eq "B".ToUpper()){
         $fileHashDictionary =@{}
        
         #Load current list of hashes and store them in a dictionary
         $filePathesAndHashes = Get-Content -Path C:\Users\henri\Documents\repos\FIM\baseline.txt
         $filePathesAndHashes
        
         foreach($f in $filePathesAndHashes){
        
            $f.Split("|")[1]
             $fileHashDictionary.add($f.Split("|")[0], $f.Split("|")[1])
        
         }
        
            $fileHashDictionary
        
            while($true){
        
            Start-Sleep -Seconds 1

            $files = Get-ChildItem -Path C:\Users\henri\Documents\FimTest
        
            #Notify if a new file has been created
            foreach ($f in $files) {
                $hash = Calculate-File-Hash $f.FullName

                if($fileHashDictionary[$hash.Path] -eq $null){
                    Write-Host "$($hash.Path) has been created!" -ForegroundColor Green

                    #30:00 up to
                }
        
            }
                
        }
        
         
 }





