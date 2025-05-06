#font Cascadia Mono
#oh-my-posh 
oh-my-posh init pwsh --config "C:\Users\kdukes\AppData\Local\Programs\oh-my-posh\themes\1_shell.omp.json" | Invoke-Expression

# Remove default 'ls' alias so we can override it
Remove-Item alias:ls -ErrorAction SilentlyContinue

# aliasing ls -t for searching
function ls {
    param(
        [string[]]$Args
    )

    if ($Args -contains '-t') {
        $pattern = $Args | Where-Object { $_ -notlike '-*' }
        Get-ChildItem -Path . -Filter $pattern | Sort-Object LastWriteTime -Descending
    } else {
        Get-ChildItem @Args
    }
}

#aliasing touch
function touch {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$files
    )

    foreach ($file in $files) {
        if (-not (Test-Path $file)) {
            New-Item -ItemType File -Path $file | Out-Null
        } else {
            (Get-Item $file).LastWriteTime = Get-Date
        }
    }
}
