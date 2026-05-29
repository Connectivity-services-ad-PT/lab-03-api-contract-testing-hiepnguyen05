# Consumer–Provider Handshake

## Thông tin chung

- Lab: FIT4110 Lab 03
- Ngày: 2026-05-29
- Provider team: team-vision
- Consumer team: team-camera
- Provider service: AI Vision Service (B4)
- Consumer service: Camera Stream Service (B2)

## Contract

- Contract file: contracts/ai-vision.openapi.yaml
- Mock base URL: http://localhost:4010
- Auth method: Bearer Token
- Endpoint được test: POST /vision/detect

## Smoke test

### Request

```http
POST /vision/detect
Authorization: Bearer {{authToken}}
Content-Type: application/json
```

```json
{
  "cameraId": "CAM-001",
  "imageRef": "s3://camera-frames/gate-01/20260526-080000.jpg",
  "timestamp": "2026-05-26T08:00:00Z",
  "motionConfidence": 0.95
}
```

### Expected response

```json
{
  "detectionId": "0196fb3d-4ad7-7d1e-9f49-5d5148d2babc",
  "cameraId": "CAM-001",
  "detectionType": "OBJECT",
  "detectedObjects": [
    {
      "label": "PERSON",
      "confidence": 0.92,
      "boundingBox": {
        "x": 100,
        "y": 150,
        "width": 50,
        "height": 120
      }
    }
  ],
  "riskLevel": "LOW",
  "modelVersion": "yolov8-nano-v1.0",
  "timestamp": "2026-05-26T08:00:00Z"
}
```

## Kết quả

- [x] Consumer gọi mock thành công.
- [x] Consumer parse được field cần dùng.
- [x] Consumer hiểu lỗi 4xx/5xx provider trả về.
- [x] Có Newman report hoặc screenshot.

## Ghi chú thay đổi hợp đồng

| Nội dung | Trước | Sau | Người đồng ý |
|---|---|---|---|
| Bổ sung thuộc tính `isLive` cho FaceMatchResult | Chưa có chống giả mạo khuôn mặt | Thêm trường `isLive: boolean` | Nhóm B2 & B6 đồng ý |
| Bổ sung mã lỗi `HTTP 429` quá tải | Chưa xử lý rate limit | Thêm `HTTP 429 Too Many Requests` và cơ chế bypass mở cổng RFID | Nhóm B6 đồng ý |
| Hỗ trợ kiểu kết hợp `null` cho matchedPersonId | matchedPersonId dạng string | type: [string, "null"] để tương thích OpenAPI 3.1 | Giảng viên hướng dẫn |

## Xác nhận

- Provider representative: Nhóm B4 AI Vision (Đã ký điện tử)
- Consumer representative: Nhóm B2 Camera Stream (Đã ký điện tử)
