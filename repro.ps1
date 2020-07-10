param(
    [switch]
    $Pause
)

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
        --output "$outdir\pub" `
        "/p:BaseIntermediateOutputPath=$outdir\obj\" `
        "/p:BaseOutputPath=$outdir\bin\" `

    &"$outdir\pub\OutpathDemo.exe"

    if ($Pause) {
        $null = Read-Host "Press enter to continue"
    }
}
