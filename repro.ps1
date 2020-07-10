$outdir = "$PSScriptRoot\out"
$attempt = 0
while ($true) {

    $attempt++
    Write-Host "Attempt #$attempt"

    if (Test-Path $outdir) {
        Remove-Item -Recurse $outdir
    }

    dotnet publish `
        .\OutpathDemo.sln `
        --configuration Release `
        --output "$outdir\pub" `
        "/p:BaseIntermediateOutputPath=$outdir\obj\" `
        "/p:BaseOutputPath=$outdir\bin\" `
        -maxCpuCount:1 `
        -nodeReuse:false `
        --nologo

    if (Test-Path "$outdir\pub\OutpathDemo.exe") {
        $output = & "$outdir\pub\OutpathDemo.exe" 2>&1
        if ($output) {
            Write-Host -ForegroundColor Red $output
        }
        else {
            Write-Host -ForegroundColor Green "passed"
        }
    }
    else {
        Write-Host -ForegroundColor Red "exe not created"
    }
}
