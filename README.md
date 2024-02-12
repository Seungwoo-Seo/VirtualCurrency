# VitEx

> 실시간 가상화폐 상태를 관측할 수 있는 서비스

<p align="center">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/bffa2475-cabc-418d-9cbd-4572322c36a8" width="130">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/3ec298c1-8b0c-40de-8492-656549fa7552" width="130">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/e8e6c7d6-f369-4f81-ab67-3e850236439a" width="130">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/e3d03ffa-b76a-403e-b28b-246236c6d7f0" width="130">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/3021911c-1aa1-4a8e-81d2-5576fea03c5d" width="130">
  <img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/87f7392f-8650-4052-b612-f7477f453a1b" width="130">
</p>

|현재가|실시간 캔들|체결|호가|차트 페이지네이션|
|:---:|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/67b4b6eb-8c90-4e42-b499-98bbbc32d85f" width="150">|<img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/c6727d61-f45f-4f83-93ee-c538b5fb980d" width="150">|<img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/a57a7526-3fa5-429c-ac0e-a4be6fe27259" width="150">|<img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/d72dcda0-8a45-4b69-be7b-17e68912fa23" width="150">|<img src="https://github.com/Seungwoo-Seo/VirtualCurrency/assets/72753868/2ebc6961-b3ba-4d19-88ce-7de1542058ab" width="150">|

## 📱 서비스

- 최소 버전 : iOS 16.2
- 개발 인원 : 1인
- 개발 기간 : 2024.01.30 ~ 2024.02.12 (2주)


## 🚀 서비스 기능

- 업비트 WebSocket 기반 실시간 가상화폐 정보 제공
- 일(Day) 단위 시세 캔들(봉)과 거래량 조회 및 일(Day) 단위 이동평균선(5, 10, 20, 60, 120일) 제공
- 현재가/체결/매도(호가)/매수(호가) 정보 제공


## 🛠 사용 기술

- Swift
- Foundation, SwiftUI, Combine, Charts 
- Clean Architecture, MVVM, Action/State Pattern, Repository Pattern, Router Pattern, Singleton
- Moya
- Async/await, Continuation, URLSessionWebSocketTask

## 💻 핵심 설명

- 관심사의 분리(SoC)를 통해 layer 분리, layer 간의 의존성 규칙(Dependency Rule) 준수
- SwiftUI + MVVM 구조 기반 Action/State Pattern 적용
- cursor 기반 페이지네이션 을 통해 이전 캔들(봉), 거래량, 체결 정보 표현
- Combine 을 사용해 View 비동기 이벤트, UseCase 결과 비동기 처리
- Moya 기반 Generic request 메소드 구현, MoyaProvider request 를 Continuation 으로 랩핑해 async/await 적용
- URLSessionWebSocketTask 기반  WebSocket 프로토콜 통신 으로 실시간 데이터 조회
- 캔들(봉), 거래량, 이동평균선 Charts 활용 구현
- ScrollViewReader, GeometryReader, PreferenceKey를 활용한 Reverse Horizontal Scrollable Chart 구현
- ScrollView + HStack + LazyVStack 를 통한 호가 화면 구현


## 🚨 트러블 슈팅

<!-- 프로젝트 중 발생한 문제와 그 해결 방법에 대한 내용을 기록한다. -->

