# ♻️ Re:Born (리본)
> **"지구를 위해 다시 태어나다"** > AI 기반 스마트 업사이클링 & 올바른 분리배출 가이드 컨시어지 서비스

---

## 📌 Project Overview
**Re:Born**은 버려지는 물건에 새로운 가치를 부여하는 **업사이클링(Upcycling)** 플랫폼입니다. 사용자가 촬영한 사진 한 장으로 재질을 분석하고, AI가 맞춤형 리폼 시안을 제안하며, 실천을 통해 지구를 지키는 재미(게이미피케이션)를 선사합니다.

---

## ✨ Key Features

### 🔍 1. AI 멀티 비전 분석
* 카메라 촬영 시 의류, 목재, 금속, 플라스틱 등 **4대 재질 실시간 판별**.
* 물건의 오염도 및 파손 부위를 진단하여 업사이클링 가능 여부 판단.

### 🎨 2. 생성형 AI 리폼 솔루션 (Gemini 1.5 Flash)
* 사용자의 물건을 기반으로 한 **비주얼 리폼 시안(After 이미지)** 생성.
* 초보자도 따라 할 수 있는 단계별 맞춤 제작 가이드 및 난이도 정보 제공.

### 📍 3. 로컬 전문가 및 수선집 연결
* 직접 리폼하기 어려운 사용자를 위해 인근 **공방 및 수선집 매칭**.
* AI 제안 시안을 전문가에게 공유하여 상담 및 의뢰 진행.

### ♻️ 4. 스마트 배출 가이드
* 리폼이 불가능한 물건에 대해 정확한 **재질별 분리배출 방법** 안내.
* Google Maps API 연동을 통한 인근 특수 수거함 위치 길 안내.

### 🎮 5. 에코 게이미피케이션
* 활동(분석, 리폼, 배출)에 따른 **경험치(XP) 및 레벨링 시스템** (Lv.1~50).
* 단계별 칭호 및 배지 수집.

---

## 🛠 Tech Stack

| 구분 | 기술 스택                                  |
| :--- | :--- |
| **Frontend** | Flutter (Dart), Android Studio         |
| **Backend** | Spring Boot, Java 21, Spring Data JPA  |
| **AI Engine** | FastAPI (Python), Gemini 1.5 Flash API |
| **Database** | MySQL 8.0                              |
| **Infrastructure** | AWS S3 (Image Storage)                 |

---

## 👥 Team - Jimmy (지구야미안해)

| 이름 | 역할 (Role) | 주요 책임 및 담당 업무 (Responsibilities) |
| :--- | :--- | :--- |
| **김도윤** | **Project Leader / Full-stack** | - **팀 총책임 및 PM**: 전체 프로젝트 일정 및 아키텍처 관리<br>- **시스템 로직 설계**: 핵심 DB 스키마 설계 및 게이미피케이션(XP/레벨링) 로직 구현 |
| **서지유** | **Frontend Lead / Full-stack** | - **UI/UX 디자인**: 사용자 경험 중심의 앱 화면 설계 (Figma)<br>- **클라이언트 구현**: Flutter 기반 프론트엔드 개발 및 AI 카메라 비전 인터페이스 연동 |
| **손혜지** | **Backend Lead / Full-stack** | - **AI 인프라 구축**: FastAPI를 활용한 AI 엔진 서버 구축 및 Gemini API 연동<br>- **최적화**: 맞춤형 리폼 가이드 생성 알고리즘 및 데이터 처리 최적화 |

---
## 📱 1단계: 프론트엔드 (Flutter) 환경 구축

### **① Flutter SDK 설치**

1. [Flutter 공식 사이트](https://docs.flutter.dev/get-started/install)에서 OS에 맞는 SDK 다운로드.
2. `C:\flutter` 폴더에 압축 해제.
3. **환경 변수 설정**: 내 PC 우클릭 > 속성 > 고급 시스템 설정 > 환경 변수 > `Path` 편집 > `C:\flutter\bin` 추가.
4. 터미널에서 `flutter doctor` 입력 후 모든 항목에 체크(`v`)가 뜨는지 확인.

### **② IDE(Android Studio) 설정**

1. **Android Studio** 설치 및 실행.
2. `Settings` > `Plugins` > **'Flutter'** 및 **'Dart'** 플러그인 설치.
3. `reborn-frontend` 프로젝트 열기.
4. `pubspec.yaml` 파일 상단의 **[Pub get]** 버튼 클릭.

### **③ 에뮬레이터(Pixel 9) 생성**

1. `Device Manager` 실행 > `Create Device`.
2. **Phone - Pixel 9** 선택 > `Next`.
3. **System Image**: `VanillaIceCream` (API 34 이상) 다운로드 및 선택.
4. 실행 버튼을 눌러 가상 디바이스 구동 확인.

### **📂 프론트엔드 표준 폴더 구조**

- **`lib/`**
    - `core/`: 공통 설정 (네트워크 클라이언트, 상수, 테마 컬러 `#81A176`)
    - `models/`: 서버 응답 데이터를 담는 클래스
    - `providers/`: 전역 상태 관리 (유저 정보, 현재 XP 등)
    - `screens/`: 각 페이지 단위 UI (예: `home_screen.dart`, `camera_screen.dart`)
    - `services/`: API 통신 및 비즈니스 로직 처리 (예: `auth_service.dart`)
    - `widgets/`: 공통 UI 컴포넌트 (커스텀 버튼, 로딩 바 등)
- **`assets/`**: 이미지, 아이콘, 폰트 파일 저장