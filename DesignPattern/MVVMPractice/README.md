## MVVM 디자인 패턴 연습

   MVVM을 이해하기 위해 참고글을 보고 이해한뒤 이해를 돕기위해, 곰튀김님의 유튜브 영상으로 클론코딩을 해보았다.
   
   영상에서는 우리가 흔히 사용하는 MVC패턴을 이용해서 날짜를 보여주는 간단한 앱을 만든다
   - - -
   
   ![스크린샷 2022-04-17 오후 8 48 48](https://user-images.githubusercontent.com/80263729/163713090-7553e27f-60a7-4acd-b6d7-4a0e16c9aef4.png)
   
   ### 실행 순서.
   > 실행 과정을 내 기준에서 봤을때 어떤 요소들이 맡고 있는지를 나누어 보았다.
   1. 버튼을 클릭한다.`(View)`
   2. 날짜를 가져오는 API를 이용해 현재 날짜를 가져온다.`(Controller)`
   3. 가져온 날짜 데이터(JSON)을 우리가 mapping한 모델(Struct)로 전환한다.`(Controller -> Model)`
   4. Struct에서 다시 실제 Swift의 날짜 타입(Date)으로 바꾼다.`(Controller)`
   5. Date타입을 화면에 보여주기 위해 String타입으로 바꾸어 준 뒤 화면에 보여준다.`(Controller -> View)`
   
   ---
   
   ### Model의 변천사
   JSON -> UTcTimeModel -> String -> Date -> String
   
   `3가지 형태의 모델`  
   serverModel(Entity) = UTcTimeModel    
   Model = Date  
   View Model = String
   
   - - -
   
   ### Refactoring to MVVM Pattern
   
   ### 실행 순서.
   1. 버튼을 클릭한다.`(View)`
   2. 날짜를 가져오는 API를 이용해 현재 날짜를 가져온다.`(Repository,Entity)`
   3. 가져온 날짜 데이터(JSON)을 우리가 mapping한 모델(Struct)로 전환한다.`(Repository,Entity)`
   4. Struct에서 다시 실제 Swift의 날짜 타입(Date)으로 바꾼다.`(Service,model)`
   5. Date타입을 화면에 보여주기 위해 String타입으로 바꾸어 준 뒤 화면에 보여준다.`(ViewModel -> View)`
   
    Repository -> Entity -> Mapper -> Model -> Logic -> ViewModel -> View
   
   `Repositroy` : Data를 Entity로 바꾸어서 전달하는 역할  
   `Service` : Repository에서 받은 Entity를 우리가 원하는 모델(Date)로 바꾸고 로직을 처리하는 역할  
   `ViewModel`: Service가 처리한 Model(Date)를 화면에 보여줄 모델(String)으로 바꾸어 주는 역할  
   `View`: ViewModel을 보고있다가 변화가 생기면 View를 업데이트 시키는 역할  
   
   
   - - -
   결론: 
   1. MVC 패턴에서의 큰 단점이었던 ViewController의 거대함을 줄일 수 있다.
   2. ViewController가 맡았던 일을 구분하고 나눔으로써 테스트하기에도 용이해졌다.
   3. 어떤 View이던 ViewModel을 구독하고 있으면 되기 때문에 1대 다의 관계가 가능하다.(코드의 재사용성이 높아진다)
   4. 간단한 앱인데도 구분을 하려고 하면 여러개의 파일이 나오므로 설계가 쉽지는 않다.
   
   
   참고: 
   [https://beomy.tistory.com/43](https://beomy.tistory.com/43)  MVC vs MVP vs MVVM  
[https://eeyatho.tistory.com/77](https://eeyatho.tistory.com/77) MVVM 탄생 이유     
[https://www.youtube.com/watch?v=M58LqynqQHc](https://www.youtube.com/watch?v=M58LqynqQHc)  MVVM 예제  
