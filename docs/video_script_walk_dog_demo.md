# WalkDog App 3-Minute Demo Script

## English Script

> Approx. 3 minutes. Feel free to speak naturally and adjust wording while keeping the structure and key points.

### 0:00–0:15 – App Icon & Intro
- **Screen:** Show your phone home screen with the WalkDog app icon, then tap it.
- **Narration:**  
  “In this video, I’ll give you a quick three‑minute tour of WalkDog, a step‑based virtual dog companion app that turns your real‑world walks into a game.”

### 0:15–0:35 – Splash & Loading
- **Screen:** Show the splash screen loading into the app.
- **Narration:**  
  “When you open the app, you’ll see a simple splash screen while the core services start up.  
  Behind the scenes, WalkDog initializes Firebase, loads remote configuration, connects to the local database, and sets up step tracking and daily happiness scheduling for your dog.”

### 0:35–1:15 – Home Screen Overview
- **Screen:** Land on the Home screen.
- **Narration:**  
  “This is the main Home screen.  
  At the top you can see my virtual dog, with its current accessories and basic info.  
  Right below, there’s a dialogue bubble where the dog talks to me using AI.  
  The app tracks my daily steps, weekly activity, and walking streaks, and turns them into game mechanics like treats, happiness, level, and missions.  
  At the bottom of the screen, we have the main summary widgets: today’s stats, a big walk button, mission overview, streak, weekly and monthly charts, and recent achievements.”

### 1:15–1:45 – AI Conversation Highlight
- **Screen:** Focus on the dialogue bubble and, if possible, trigger a greeting or low‑happiness dialogue.
- **Narration:**  
  “The dialogue here is powered by a cloud AI model.  
  WalkDog uses the OpenRouter API with the DeepSeek R1 model to generate short, dog‑like responses based on context, such as greeting, finishing a walk, completing a mission, feeding treats, leveling up, or when happiness is low.  
  If the network is slow or the API isn’t available, the app automatically falls back to built‑in rule‑based responses, so the dog can always say something.”

### 1:45–2:15 – Walk Screen & Sensors
- **Screen:** Switch to the Walk tab and show starting or stopping a walk.
- **Narration:**  
  “On the Walk screen, WalkDog connects to the phone’s step counter and health APIs to track my real steps throughout the day.  
  It also uses GPS to detect outdoor walks and calculate distance and average speed.  
  Based on my activity, the app automatically converts steps into treats and happiness, and uses missions and achievements to reward consistent walking.”

### 2:15–2:40 – Achievements, Stats, Customization & Language
- **Screen:** Briefly show the Achievements screen, charts, and Customize screen, then open the Settings screen and switch the app language between English and Korean.
- **Narration:**  
  “There’s an achievement system with multiple badge tiers, plus daily, weekly, and monthly statistics, including charts for steps and streaks.  
  I can also customize my dog with different accessories, and the app supports both light and dark themes.  
  Here in the Settings screen, I can change the app language between English and Korean, and the UI updates immediately using Flutter’s localization system.”

### 2:40–3:00 – Tech Stack & Closing
- **Screen:** Return to the Home screen for the closing.
- **Narration:**  
  “Technically, WalkDog is built with Flutter and uses a clean architecture with separate domain, data, service, and presentation layers.  
  It stores data locally using the Isar database, and integrates Firebase for analytics and remote config, plus OpenRouter for AI dialogue.  
  In a future update, it will also use Google’s Gemini image generation API through a Firebase Functions proxy to create personalized dog stickers.  
  That was a quick overview of WalkDog, a gamified virtual dog app that encourages you to walk more in the real world.”

---

## Korean Script (한국어 스크립트)

> 약 3분 분량입니다. 말하기 편하게 문장을 조금씩 바꿔도 되지만, 흐름과 핵심 내용은 유지해 주세요.

### 0:00–0:15 – 앱 아이콘 & 소개
- **화면:** 휴대폰 홈 화면에서 WalkDog 앱 아이콘을 보여주고, 터치해서 실행합니다.
- **나레이션:**  
  “이 영상에서는 걸음수 기반 가상 반려견 앱인 WalkDog을 3분 안에 간단하게 소개해 드리겠습니다.  
  실제로 걸은 만큼 보상이 쌓이고, 강아지를 키우면서 산책 습관을 만들어가는 앱이에요.”

### 0:15–0:35 – 스플래시 & 로딩
- **화면:** 스플래시 화면에서 앱이 로딩되는 모습을 보여줍니다.
- **나레이션:**  
  “앱을 켜면 이렇게 간단한 스플래시 화면이 나오면서 내부 초기화가 진행됩니다.  
  이때 Firebase와 원격 설정(Remote Config)을 불러오고, 로컬 데이터베이스와 연동하고, 걸음수 추적과 강아지 행복도 스케줄러 같은 핵심 서비스들이 준비돼요.”

### 0:35–1:15 – 홈 화면 전체 구조
- **화면:** 홈 화면에 머무릅니다.
- **나레이션:**  
  “여기가 WalkDog의 메인 홈 화면입니다.  
  위쪽에는 지금 키우고 있는 가상 강아지와 액세서리, 기본 정보가 보이고,  
  바로 아래에는 강아지가 말풍선으로 말을 거는 AI 대화 영역이 있습니다.  
  앱은 제 하루 걸음수와 주간 활동, 연속 산책 일수 같은 데이터를 기반으로 간식, 행복도, 레벨, 미션 같은 게임 요소로 바꿔 줍니다.  
  아래쪽에는 오늘 통계, 산책 시작 버튼, 미션 요약, 연속 산책 위젯, 주간·월간 차트, 최근 배지까지 한 화면에서 볼 수 있게 구성되어 있어요.”

### 1:15–1:45 – AI 대화 기능 강조
- **화면:** 대화 말풍선 부분을 중심으로 보여주고, 가능하면 인사나 행복도 낮음 대사를 한 번 띄워줍니다.
- **나레이션:**  
  “이 말풍선에 나오는 대사는 클라우드 AI가 만들어 줍니다.  
  WalkDog은 OpenRouter API와 DeepSeek R1 모델을 사용해서, 인사, 산책 완료, 미션 완료, 간식 주기, 레벨업, 행복도 낮음처럼 여러 상황에 맞는 강아지 말투의 짧은 대사를 생성해요.  
  만약 네트워크가 불안정하거나 API에 연결할 수 없을 때는, 앱 안에 미리 준비된 규칙 기반 폴백 응답으로 자동 전환돼서 강아지가 항상 무언가 말을 할 수 있게 되어 있습니다.”

### 1:45–2:15 – 산책 화면 & 센서 연동
- **화면:** 산책 탭으로 이동해서 산책 시작/종료 플로우를 간단히 보여줍니다.
- **나레이션:**  
  “산책 화면에서는 휴대폰의 걸음 수 센서와 건강 데이터 API와 연동해서, 제가 실제로 걸은 걸음 수를 하루 동안 계속 추적합니다.  
  GPS를 함께 사용해서 실외 산책인지 판별하고, 거리와 평균 속도도 계산해 줍니다.  
  이렇게 쌓인 활동 데이터는 자동으로 간식과 행복도로 바뀌고, 미션과 업적 시스템을 통해 꾸준히 걸을수록 더 많은 보상을 받을 수 있게 설계했어요.”

### 2:15–2:40 – 업적, 통계, 커스터마이즈, 언어 변경
- **화면:** 업적 화면, 통계 차트, 커스터마이즈 화면을 짧게 각각 보여준 뒤, 설정 화면으로 들어가서 앱 언어를 한국어와 영어 사이에서 바꾸는 모습을 보여줍니다.
- **나레이션:**  
  “여기에는 여러 티어로 구성된 배지(업적) 시스템이 있고,  
  하루·주간·월간 단위로 걸음 수와 거리, 연속 산책 일수를 차트로 한눈에 볼 수 있는 통계 화면도 있습니다.  
  강아지 액세서리를 바꿔서 꾸밀 수도 있고, 설정 화면에서는 앱 언어를 한국어와 영어 사이에서 바꾸면, 플러터 로컬라이제이션 시스템을 통해 UI 텍스트가 바로 변경되는 것도 확인할 수 있습니다.”

### 2:40–3:00 – 기술 스택 & 마무리
- **화면:** 다시 홈 화면으로 돌아와서 마무리 멘트를 합니다.
- **나레이션:**  
  “기술적으로는 Flutter로 개발된 앱이고, 도메인·데이터·서비스·UI 레이어를 분리한 클린 아키텍처 구조를 사용합니다.  
  로컬 데이터는 Isar 데이터베이스로 저장하고, Firebase를 이용해서 분석과 Remote Config를 처리하며, OpenRouter를 통해 AI 대화를 제공합니다.  
  앞으로는 Firebase Functions 프록시와 Google Gemini 이미지 생성 API를 연동해서, 내 강아지만의 맞춤형 스티커를 만드는 기능도 추가할 예정입니다.  
  지금까지 현실의 걸음을 게임처럼 만들어 주는 산책형 가상 반려견 앱, WalkDog 소개였습니다.”
