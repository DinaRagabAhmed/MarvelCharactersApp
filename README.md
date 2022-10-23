# Marvel Characters App
## by Dina Ragab

### Technologies and patterns
- Architecture
  - MVVM with RxSwift, router and coordinator.

- Dependency management
  - CocoaPods.
  
- Network layer
  - Moya.
 
- Design 
  - UIKit(XIBs).
  
- Decisions
  - If there are empty media items(Events - Comics - Series - Stories), these sections will be removed.



### Regarding Search Screen
 I found that "name" parameter in Marvel API returns only characters that its names match exactly
 the text in search bar(== not contains) so i sent email asking about that and i used
 "nameStartsWith" to workaround this issue
