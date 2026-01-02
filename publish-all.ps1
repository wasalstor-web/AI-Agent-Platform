# Publish All - استدعاء وظيفة نشر الكل
# Execute publish all functionality from command center

$API_URL = "https://onlainee.space/command-center.php"
$TOKEN = "KHALID_MASTER_2025_AGENT"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Publish All - نشر الكل" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Prepare request
$headers = @{
    "Content-Type" = "application/json"
    "X-Command-Token" = $TOKEN
}

$body = @{
    command = "publish_all"
    params = @{}
} | ConvertTo-Json

Write-Host "Publishing... Please wait..." -ForegroundColor Yellow
Write-Host ""

try {
    # Ignore SSL certificate errors for testing
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls
    
    $response = Invoke-RestMethod -Uri $API_URL -Method POST -Headers $headers -Body $body -ErrorAction Stop
    
    Write-Host "Deployment Complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Result:" -ForegroundColor Cyan
    Write-Host "Status: $($response.status)" -ForegroundColor Green
    Write-Host "Message: $($response.message)" -ForegroundColor White
    Write-Host ""
    
    if ($response.deployment_steps) {
        Write-Host "Steps Executed:" -ForegroundColor Cyan
        Write-Host "----------------------------------------" -ForegroundColor Gray
        
        foreach ($step in $response.deployment_steps) {
            $icon = if ($step.status -eq 'success') { '[OK]' } elseif ($step.status -eq 'skipped') { '[SKIP]' } else { '[WARN]' }
            $color = if ($step.status -eq 'success') { 'Green' } elseif ($step.status -eq 'skipped') { 'Yellow' } else { 'Red' }
            Write-Host "$icon $($step.step). $($step.name) ($($step.status))" -ForegroundColor $color
            
            if ($step.output -and $step.output.Length -gt 0 -and $step.output -ne 'Script not found' -and $step.output -ne 'No changes to commit') {
                $outputPreview = if ($step.output.Length -gt 100) { $step.output.Substring(0, 100) + "..." } else { $step.output }
                Write-Host "   $outputPreview" -ForegroundColor Gray
            }
            Write-Host ""
        }
        
        Write-Host "----------------------------------------" -ForegroundColor Gray
        Write-Host "Total Steps: $($response.total_steps)" -ForegroundColor Cyan
        Write-Host "Time: $($response.timestamp)" -ForegroundColor Cyan
    }
    
} catch {
    Write-Host "Deployment Error" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response: $responseBody" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
