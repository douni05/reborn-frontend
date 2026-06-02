# ♻️ Re:Born (리본)
> **"지구를 위해 다시 태어나다"**
> AI 기반 스마트 업사이클링 & 전문가 연결 플랫폼

---

## 📌 프로젝트 소개

**Re:Born**은 버려지는 물건에 새로운 가치를 부여하는 **업사이클링(Upcycling)** 플랫폼입니다.
사진 한 장으로 AI가 재질을 분석하고 맞춤형 리폼 디자인 시안을 제안하며,
가까운 전문 공방과 연결하여 직접 제작까지 이어지는 서비스입니다.
활동할수록 XP와 레벨이 올라가는 게이미피케이션 시스템으로 환경 실천을 재미있게 만들어줍니다.

---

## ✨ 주요 기능

### 🔍 1. AI 멀티 비전 분석
- 카메라 촬영 또는 갤러리 사진으로 **의류·목재·금속·플라스틱 등 재질 자동 판별**
- 업사이클링 가능 여부 판단 및 오염도/파손 진단
- 분석 결과를 이력으로 저장하여 언제든 재확인 가능

### 🎨 2. 생성형 AI 리폼 솔루션
- Gemini 2.5 Flash 기반 **맞춤형 리폼 디자인 시안** 제안
- 제목·설명·난이도·예상 소요시간·예상 비용 포함
- 리폼 등록 시 XP +100 획득

### 👨‍🔧 3. 전문가 연결
- 카테고리·지역·공방명으로 주변 **리폼 전문 공방 검색 및 필터링**
- AI 분석 시안을 전문가에게 공유하여 리폼 요청 의뢰
- 요청 수락/거절/완료 시 **FCM 푸시 알림** 발송

### ♻️ 4. 스마트 분리배출 가이드
- 리폼이 불가능한 물건에 대한 **재질별 올바른 분리배출 방법** 안내
- 폐기물 처리 등록 시 XP +50 획득

### 🎮 5. 에코 게이미피케이션
- AI 분석·리폼 등록·전문가 매칭 등 활동에 따른 **XP 적립 및 Lv.1~50 레벨링**
- 레벨별 고유 **캐릭터 이미지** 변화 (새싹 → 주니어 → 프로 → 마스터 → 수호자)
- 단계별 칭호 및 조건부 특별 업적 시스템

---

## 🛠 기술 스택

| 구분 | 기술 |
| :--- | :--- |
| **Frontend** | Flutter 3 (Dart), Firebase Messaging |
| **Backend** | Spring Boot 3.5, Java 21, Spring Data JPA, JWT |
| **AI Server** | FastAPI (Python), Gemini 2.5 Flash API |
| **Database** | Supabase (PostgreSQL) |
| **Push Notification** | Firebase Cloud Messaging (FCM) |
| **Social Login** | Kakao SDK, Naver Login SDK |
| **API Docs** | SpringDoc OpenAPI (Swagger UI) |

---

## 🏗 시스템 아키텍처

```
Flutter App
    │
    ├──▶ Spring Boot API Server (port 8080)
    │         ├── JWT 인증
    │         ├── Member / Expert / ReformRequest API
    │         ├── FCM 푸시 알림 (Firebase Admin SDK)
    │         └── Supabase PostgreSQL
    │
    └──▶ FastAPI AI Server (port 8000)
              └── Gemini 2.5 Flash (재질 분석 + 리폼 시안 생성)
```

---

## 🎮 레벨 & 칭호 시스템

| 레벨 | 칭호 | 캐릭터 |
| :--- | :--- | :--- |
| Lv. 1 ~ 5 | 🌱 새싹 지구 지킴이 | ch_1 |
| Lv. 6 ~ 15 | ♻️ 주니어 리포머 | ch_2 |
| Lv. 16 ~ 30 | 🌿 프로 환경러 | ch_3 |
| Lv. 31 ~ 49 | 🌍 에코 마스터 | ch_4 |
| Lv. 50+ | 🏆 지구 수호자 | ch_5 |

**XP 획득 방법**

| 활동 | XP |
| :--- | :--- |
| AI 분석 | +10 XP (첫 분석 +50 XP) |
| 리폼 등록 | +100 XP |
| 폐기물 처리 | +50 XP |
| 전문가 매칭 완료 | +150 XP |

---

## 📁 프론트엔드 폴더 구조

```
lib/
├── main.dart                  # 앱 진입점, Firebase 초기화
├── core/
│   ├── constants/
│   │   └── level_constants.dart   # 레벨 임계값, 칭호 계산
│   ├── network/
│   │   └── api_client.dart        # Dio HTTP 클라이언트
│   └── storage/
│       └── auth_storage.dart      # 로컬 세션 저장
├── models/
│   ├── member_model.dart
│   └── analysis_model.dart
├── screens/
│   ├── Splash.dart
│   ├── Login.dart                 # 카카오/네이버/구글 소셜 로그인
│   ├── Signup.dart
│   ├── Main_page.dart             # 홈 (캐릭터, XP 바, 오늘의 팁)
│   ├── camera_screen.dart         # AI 분석 카메라
│   ├── AI_camera_result.dart      # 분석 결과
│   ├── Reform_solution.dart       # 리폼 시안 상세
│   ├── Reform_history.dart        # 분석 이력
│   ├── smart_disposal_solution.dart
│   ├── Expert_connect.dart        # 전문가 목록 & 요청
│   ├── Expert_dashboard.dart      # 전문가 요청 관리
│   ├── Expert_register1~3.dart    # 전문가 등록 단계
│   ├── Expert_edit.dart
│   ├── My_requests.dart           # 나의 요청 현황
│   └── My_page.dart               # 마이페이지
├── services/
│   ├── member_service.dart
│   ├── analysis_service.dart
│   ├── expert_service.dart
│   ├── reform_request_service.dart
│   └── action_service.dart
└── widgets/
    ├── app_shell.dart             # 바텀 탭 내비게이션 쉘
    └── bottom_nav_bar.dart
```

---

## 🚀 개발 환경 설정

### 1. Flutter 환경 구축

```bash
# Flutter SDK 설치 후
flutter doctor       # 환경 점검
flutter pub get      # 패키지 설치
```

- Android Studio에서 **Flutter / Dart 플러그인** 설치
- `pubspec.yaml` 에서 Pub get 실행

### 2. Firebase 설정

- `android/app/google-services.json` 파일을 Firebase Console에서 다운로드하여 배치
  - Firebase Console → 프로젝트 설정 → Android 앱 → google-services.json

### 3. API 서버 주소 설정

`lib/core/network/api_client.dart` 에서 백엔드 주소 설정:
```dart
// 에뮬레이터: 10.0.2.2:8080
// 실기기: 백엔드 서버 IP
```

---

## 👥 팀 - Jimmy (지구야미안해)

| 이름 | 역할 | 주요 담당 |
| :--- | :--- | :--- |
| **김도윤** | Project Leader / Full-stack | 프로젝트 총괄, DB 스키마 설계, 게이미피케이션 로직, 백엔드 API, FCM 알림 |
| **서지유** | Frontend Lead / Full-stack | UI/UX 디자인(Figma), Flutter 앱 개발, AI 카메라 인터페이스 |
| **손혜지** | Backend Lead / Full-stack | FastAPI AI 서버, Gemini API 연동, 리폼 가이드 알고리즘 |
