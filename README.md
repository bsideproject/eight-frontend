# B-Side 12기 8팀 에잇
<p align="left">
<img src="https://img.shields.io/badge/swift-5.7-blue.svg" />
<img src="https://img.shields.io/badge/xcode-14.0-green.svg" />
<img src="https://img.shields.io/badge/ios-16.0-yellow.svg" />
<img src="https://img.shields.io/badge/licence-MIT-lightgrey.svg" /> 
</p>
<br>

### ✍️ 아키텍처 패턴
- **MVVM**

### ▶️ Branch Naming Rule
- **main** : 개발이 완료된 산출물이 저장될 공간
- **feature** : 기능을 개발하는 브랜치, 이슈별/작업별로 브랜치를 생성하여 기능을 개발한다
- **hotfix** : 버그를 수정하는 브랜치
- **develop** `default` : feature 브랜치에서 구현된 기능들이 merge될 브랜치

### ✏️Commit Message
- **feature** : git Issue 생성한 경우
- **Refactoring** : refactoring으로 변경한경우
- **Fix** :  Bug report 받아 수정인경우
- **Crash**: crash Log를 통해 발견하여 수정한경우
- **Etc**: 위 4가지 경우가 아닌경우

### 🤝 코드 리뷰 방식
- **P1: 꼭 반영해주세요 (Request changes)**
  - 리뷰어는 PR의 내용이 서비스에 중대한 오류를 발생할 수 있는 가능성을 잠재하고 있는 등 중대한 코드 수정이 반드시 필요하다고 판단되는 경우, P1 태그를 통해 리뷰 요청자에게 수정을 요청합니다. 리뷰 요청자는 p1 태그에 대해 리뷰어의 요청을 반영하거나, 반영할 수 없는 합리적인 의견을 통해 리뷰어를 설득할 수 있어야 합니다.
- **P2: 적극적으로 고려해주세요 (Request changes)**
  - 작성자는 P2에 대해 수용하거나 만약 수용할 수 없는 상황이라면 적합한 의견을 들어 토론할 것을 권장합니다.
- **P3: 웬만하면 반영해 주세요 (Comment)**
  - 작성자는 P3에 대해 수용하거나 만약 수용할 수 없는 상황이라면 반영할 수 없는 이유를 들어 설명하거나 다음에 반영할 계획을 명시적으로(JIRA 티켓 등으로) 표현할 것을 권장합니다. Request changes 가 아닌 Comment 와 함께 사용됩니다.
- **P4: 반영해도 좋고 넘어가도 좋습니다 (Approve)**
  - 작성자는 P4에 대해서는 아무런 의견을 달지 않고 무시해도 괜찮습니다. 해당 의견을 반영하는 게 좋을지 고민해 보는 정도면 충분합니다.
- **P5: 그냥 사소한 의견입니다 (Approve)**
  - 작성자는 P5에 대해 아무런 의견을 달지 않고 무시해도 괜찮습니다.
