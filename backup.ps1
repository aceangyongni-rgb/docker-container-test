# Matrix Backup Script
$backupDir = "E:\matrix-backups\$(Get-Date -Format 'yyyy-MM-dd_HH-mm')"
New-Item -ItemType Directory -Force $backupDir | Out-Null

Write-Host "Stopping containers..."
docker compose -f "E:\git repos\docker-container-test\docker-compose.yml" stop

Write-Host "Backing up data..."
Copy-Item -Recurse "E:\git repos\docker-container-test\synapse-data" "$backupDir\synapse-data"
Copy-Item -Recurse "E:\git repos\docker-container-test\mautrix-whatsapp" "$backupDir\mautrix-whatsapp"
Copy-Item -Recurse "E:\git repos\docker-container-test\mautrix-telegram" "$backupDir\mautrix-telegram"
Copy-Item -Recurse "E:\git repos\docker-container-test\mautrix-discord" "$backupDir\mautrix-discord"
Copy-Item "E:\git repos\docker-container-test\docker-compose.yml" "$backupDir"
Copy-Item "E:\git repos\docker-container-test\element-config.json" "$backupDir"
Copy-Item "E:\git repos\docker-container-test\synapse-start.sh" "$backupDir"
Copy-Item "E:\git repos\docker-container-test\matrix_key.pem" "$backupDir"
Copy-Item "E:\git repos\docker-container-test\nginx.conf" "$backupDir" -ErrorAction SilentlyContinue

Write-Host "Restarting containers..."
docker compose -f "E:\git repos\docker-container-test\docker-compose.yml" start

Write-Host "Cleaning old backups (older than 7 days)..."
Get-ChildItem "E:\matrix-backups" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Recurse -Force

Write-Host "Backup complete! Saved to $backupDir"
