# Script chạy kiểm thử và tự động xuất Log CLI làm bằng chứng nộp bài
# Chạy bằng cách mở PowerShell và gõ: .\scripts\run-evidence.ps1

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Khởi chạy hệ thống kiểm thử tích hợp AI Vision B4" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Tạo thư mục reports nếu chưa có
if (!(Test-Path -Path "reports")) {
    New-Item -ItemType Directory -Path "reports" -Force | Out-Null
}

# 2. Chạy Mock AI Vision và Mock IoT Ingestion trong nền
Write-Host "[1/3] Đang khởi động Prism Mock Servers..." -ForegroundColor Yellow
$VisionJob = Start-Process npx -ArgumentList "prism mock contracts/team-vision.openapi.yaml -p 4010 --host 0.0.0.0" -NoNewWindow -PassThru
$IotJob = Start-Process npx -ArgumentList "prism mock contracts/iot-ingestion.openapi.yaml -p 4011 --host 0.0.0.0" -NoNewWindow -PassThru

# Chờ 3 giây để mock server khởi động hoàn tất
Start-Sleep -Seconds 3

# 3. Chạy Newman và xuất log ra màn hình đồng thời ghi vào file text
Write-Host "[2/3] Đang tiến hành chạy Newman Contract Tests..." -ForegroundColor Yellow
Write-Host "----------------------------------------------------------" -ForegroundColor Gray

# Chạy newman và lưu toàn bộ log CLI vào file text
npx newman run postman/collections/team-vision.postman_collection.json `
  -e postman/environments/team-vision_mock.postman_environment.json `
  --reporters cli,junit,htmlextra `
  --reporter-junit-export reports/newman-report.xml `
  --reporter-htmlextra-export reports/newman-report.html `
  | Tee-Object -FilePath "reports/newman-cli-log.txt"

Write-Host "----------------------------------------------------------" -ForegroundColor Gray
Write-Host "[3/3] Đang tiến hành dọn dẹp tiến trình Prism..." -ForegroundColor Yellow

# 4. Dọn dẹp tiến trình mock
Stop-Process -Id $VisionJob.Id -Force -ErrorAction SilentlyContinue
Stop-Process -Id $IotJob.Id -Force -ErrorAction SilentlyContinue

Write-Host "==========================================================" -ForegroundColor Green
Write-Host " HOÀN THÀNH XUẤT SẮC!" -ForegroundColor Green
Write-Host " Bằng chứng HTML Report: reports/newman-report.html" -ForegroundColor Green
Write-Host " Bằng chứng CLI Log File: reports/newman-cli-log.txt" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
