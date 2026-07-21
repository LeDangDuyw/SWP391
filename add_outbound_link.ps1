$files = Get-ChildItem -Path "c:\Users\huy\Downloads\lll\SWP391\web\staff" -Recurse -Filter "*.jsp" | Where-Object { $_.FullName -notlike "*outbound*" }

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match "staff/outbound") {
        Write-Host "SKIP: $($file.FullName)"
        continue
    }
    
    $ticketPattern = 'Tickets</a>'
    $idx = $content.IndexOf($ticketPattern)
    if ($idx -ge 0) {
        $insertPos = $idx + $ticketPattern.Length
        $newLine = [char]13 + [char]10 + '            <a href="${pageContext.request.contextPath}/staff/outbound/list"><span>' + [char]0x1F4E6 + '</span>Outbound</a>'
        $content = $content.Insert($insertPos, $newLine)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "UPDATED: $($file.FullName)"
    } else {
        Write-Host "NOT FOUND: $($file.FullName)"
    }
}
