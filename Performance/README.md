### 스위프트의 성능 이해하기

[출처:유용하님의 스위프트 성능 이해하기](https://www.youtube.com/watch?v=z1Gf6EosaUQ) 를 시청하면서 키워드들을 살펴보자

- (Semantics? -> 프로그램이 무엇을 어떻게 수행할지를 나타내며, 특정 기능의 의미가 다른 부분의 상호연관에 의해서 설명되는 경우가 많다.  
[Semntics vs Syntax](https://leadbiz.tistory.com/377)
- Value Type의 특징
  - 변수 할당시 Stack에 값 전체가 저장됨
  - 다른 변수에 할당될 때 전체가 값이 복사됨(copy by value)
  - Heap을 안쓰기 때문에 Reference Counting도 필요 없음  
`'값'에 의해 구분된다`
- Value semantics에서는 Identity가 아니라 Value가 중요하다
- 각 변수는 Value에 의해 구분이 되어야 한다.
- 따라서,, 동치관계여야한다 -> Equatable을 구현해보면 확인이된다.
- Thread간 의도하지 않은 공유로부터 안전하다!(왜냐하면 값이 복사가 되기 떄문!)
![스크린샷 2022-02-22 오후 2 25 01](https://user-images.githubusercontent.com/80263729/155068428-946e5893-a538-4b9c-b3cc-75f0125de301.png)  


- 값을 모조리 카피해버리면 성능에 문제가 생기지 않을까? 🤔  
`Copy는 빠르다` 
- 컴퓨팅 성능의 상승으로 Copy자체는 매우 빠른 속도로 해결이 가능하다
- 기본타입들(enum,typle,struct)은 엄청나게 큰 데이터가 아닌 이상은 정해진 시간(constant time)안에 끝난다.

- 내부데이터가 Heap과 혼용하는 struct의 경우
  - 정해진 시간 + referenct copy등의 시간
  - String,Array,set,Dictionary등
  - 쓰기 시 Copy-on-write로 속도 저하 보완

- immutable(불변)을 사용하면 되지 않나? 🤔 
왜냐하면 참조형이어도 값이 붋변하면 Thread간에 문제가 생길일이 없다.
실제로 immutable은 cocoa에서도 꽤 써왔다. 
하지만 계속 개체를 생성하고 합치는 과정은 비효율적임

<img src = "https://user-images.githubusercontent.com/80263729/155069852-b92f9ce6-2a34-49c6-a6e1-be418273ade4.png" width="40%"/> <img src = "https://user-images.githubusercontent.com/80263729/155070945-7c5a325c-8680-42ab-9b78-7007f5acbff1.png" width="40%" height="250"/>

- 그럼 대체 class는 언제 사용하나? 🤔 
  - value보다 identity가 중요한 경우
    - UIView 같이 모든 변수에서 단 하나의 state를 갖는 개체
  - OOP 모델
  - Objective-C 연동
  - indirect storage

- - - 

### 성능에 영향을 미치는 3가지
- Memory Allocation: Stack or Heap -> **메모리를 어디다가 할당할것인가**
- Reference Counting: No or Yes -> **Referenc Count를 사용하나 안하나**
- Method dispatch: Static or Dynamic -> **Method를 호출 할때 컴파일 타임에 할지 런타임에 할지**

`Heap 할당,Stack 할당`
- Heap 메모리에 할당시 빈곳을 찾고 관리하는 것은 복잡한 과정을 수반한다.
  - 따라서, 크기가 큰 Loop를 돌면서 Heap메모리에 할당하는 작업은 성능을 크게 떨어뜨릴 수 있다.
- 그 과정이 thread safe해야 한다는 점이 가장 큰 문제
  - lock 등의 synchronization동작은 큰 성능 저하 요소
- Stack 할당은 단순히 스택 포인터 변수값만 바꾸면 되기 때문에 `Heap할당보다는 간편한? 과정을 가진다.`

`Reference Counting`
- 정말 자주 실행된다 Ex) 변수가 Copy될 때마다
- `thread safety문제가 발생할 수 있다.`
  - 카운트를 Atomic하게 늘리고 줄여주는 것이 필요하다.

`Method Dispatch(Static)`
- 컴파일 시점에 메소드 실제 코드 위치를 안다면 실행중(runtime) 찾는 과정 없이 해당 코드 주소로 점프 할 수 있다.
- 컴파일러의 최적화, `메소드 인라이닝(inlining)가능`
  - 메소드 인라이닝?: 컴파일 시점에 메소드 호출부분에 메소드 내용을 inline하게(한줄로 그냥 쭈욱) 붙여넣는다. -필요한 경우에만
  - **장점**
  - 일반적인 함수들은 런타임에 호출 하여 그 주소로 점프해서 넘어간다음 다시 원래 주소로 돌아오는데 이런 오버헤드를 줄일 수 있게 된다.
  - Call Stack 오버헤드를 줄인다
    - CPU icache나 레지스터를 효율적으로 쓸 가능성이 높아진다
  - 컴파일러의 추가 최적화 가능
    - 최근 메서드들이 작으므로 기회가 많다
    - 루프 안에서 불리는 경우 큰 효과를 본다
    - 개념적인 과정

<img width="45%" alt="스크린샷 2022-02-22 오후 3 14 58" src="https://user-images.githubusercontent.com/80263729/155073702-afe28889-569c-48e4-be5b-1118270f7d36.png"><img width="45%" alt="스크린샷 2022-02-22 오후 3 15 21" src="https://user-images.githubusercontent.com/80263729/155073749-1a2e67e5-5271-4161-811d-67d8c64ecbe7.png">

`Method Dispatch(Dynamic)`
- 컴파일 시점에 실제 Type을 알 수 없다, 때문에 코드 수조를 runtime에 알아야한다.

<img width="45%" alt="스크린샷 2022-02-22 오후 3 19 07" src="https://user-images.githubusercontent.com/80263729/155074205-74a03dd9-5542-4cc5-ba61-f6f2f4ce97ba.png"><img width="45%" alt="스크린샷 2022-02-22 오후 3 19 12" src="https://user-images.githubusercontent.com/80263729/155074217-e2f9a137-0640-429e-8e69-823ed118056b.png">

- Static에 비해 이것이 문제이다. 사실 Thread saftety도 문제가 없다.
- 하지만 `컴파일러가 최적화를 못하는 것` 이 문제
- 특히 `Objective-C` 가 이 방식을 택하기 때문에 문제가 생길 수 있다.

<img width="60%" alt="스크린샷 2022-02-22 오후 3 43 55" src="https://user-images.githubusercontent.com/80263729/155077186-6e431d1e-4096-43f9-86cb-e8d50186729c.png">

- Static Dispatch로 강제할 수 있는 방법이 있다.
  - final, private등을 쓰는 버릇
    - 해당 메소드,프로퍼티는 상속되지 않기 때문에 static하게 처리한다.
  - dynamic 쓰지 않기
  - objc연동 최소화
  - WMO(whole module optimization)활용
    - 빌드시에 모든 파일을 한번에 분석하여, Static dispatch로 변환 가능한지 등을 판단하여 최적화 한다.

- 정리
  - Memory Allocation: `Stack or Heap`
  - Reference Counting: `NO or Yes`
  - Method Dispatch: `Static or Dynamic` 


- 추상화 기법에 따라 앞서 나온 성능들을 어떻게 활요하고 있는가?
- `class`  
- 단, `final class`는 Method Dispatch를 Static으로 바꿀 수 있다.

<img width="70%" alt="스크린샷 2022-02-22 오후 3 50 22" src="https://user-images.githubusercontent.com/80263729/155077987-4f602a1b-73ca-4c30-9bf5-e93ef9a037af.png">

- `Struct`  
  - 참조 타입이 없는 Struct
 <img width="70%" alt="스크린샷 2022-02-22 오후 3 51 48" src="https://user-images.githubusercontent.com/80263729/155078182-24b2f270-b3f9-4729-970f-951ff8fb2530.png">
 
  - 참조 타입이 있는 Struct  
  중요한 것은 `Reference Count가 struct안에 참조 타입의 property수만큼 많아진다는 것!`   
    
  <img width="45%" alt="스크린샷 2022-02-22 오후 3 54 07" src="https://user-images.githubusercontent.com/80263729/155078487-ed7495dd-ac38-40ce-9aca-b48b232eed15.png"><img width="45%" alt="스크린샷 2022-02-22 오후 3 54 37" src="https://user-images.githubusercontent.com/80263729/155078569-5d1ed6a9-fb51-4eca-af33-ff88fb9ab23c.png">
  
<img width="70%" alt="스크린샷 2022-02-22 오후 4 00 32" src="https://user-images.githubusercontent.com/80263729/155079337-7f52d7b2-09c3-45a4-9671-b976b6db04b6.png">

- Struct내에 참조 타입을 줄일 수는 없을까? 🤔 
  - 값의 제한이 가능하면 enum등의 Value type으로 변경하기
  - 다수의  class들을 하나으 class로 묶기.

- `Protocol Type`
  - 코드 없이 API만 정의함
  - 상속 없는 다형성 (Polymorphism) 구현 가능
  - `Value 타입인 struct에도 적용가능`
    - Value semantics에서의 다형성  
    <img width="70%" alt="스크린샷 2022-02-22 오후 4 06 00" src="https://user-images.githubusercontent.com/80263729/155080083-3c44f23f-9d88-48a4-b13e-26d818ba93ee.png">
- class는 주소값이라 모두 같은 사이즈라 하지만 Struct는 사이즈가 다다를텐데 어떻게 메모리를 할당하고 저장할까? 🤔 

<img width="70%" alt="스크린샷 2022-02-22 오후 4 14 52" src="https://user-images.githubusercontent.com/80263729/155081272-2a9971ee-7ffa-4170-ae9d-677e67b7ec94.png">

- `Existential Container`

<img width="70%" alt="스크린샷 2022-02-22 오후 4 16 40" src="https://user-images.githubusercontent.com/80263729/155081546-d356110d-6168-4e1d-a8d3-e4c4ca065369.png">

  - 위와 같은 문제점을 해결하기 위해 만들었따. 
  - 3 words에 해당하는 Buffer를 넣고 fixed Size라는 메타데이터로 구성된 고정된 사이즈로 구성되어 있음
  - 위 그림에서 배열안에 이런 Container들이 들어가 있는것임

- Struct가 3 words이하인 경우
  - Existential container안에 값이 모두 저장됨
  - 만약 값이 2word크기라면 1word는 낭비될 것 임 
  
- Struct가 3 words 초과 인 경우
  - Heap에 할당해서 저장하게 된다
  - 해당 참조를 Existential container에 저장하게 된다.
<img width="70%" alt="스크린샷 2022-02-22 오후 4 21 00" src="https://user-images.githubusercontent.com/80263729/155082178-f490b35a-7e0b-4940-bd70-604b8604ea48.png">

- 3 word크기인지 아닌지 어떻게 구분하고 할당하고 복사하는가? 🤔 

- `Value Witness Table(VWT)
  - Existential container의 생성/해제를 담당하는 인터페이스 
<img width="40%" alt="스크린샷 2022-02-22 오후 4 23 06" src="https://user-images.githubusercontent.com/80263729/155082508-cb80b6e3-7730-45cc-abd4-058bfbc07103.png">

1. allocate한다 (3word보다 크면 ref가 작으면 값이 할당됨)
2. copy한다 (3word보다 클때 발생하며 Heap에 데이터를 copy하게 됨)
3. destruct (메모리에 올라와있는 것을 지운다. 3word보다 크면 Heap에 있는 데이터가 작으면 stack에 있는 데이터가 삭제됨)
4. deallocate (Stack에 있는 참조 주소를 지운다)
VWT는 fix size안에 포함이 되어있기 때문에 Copy가 되더라도 계속 가지고 있게 된다.

- Dynamic Dispatch는 어떻게 함?
- PWT라는 포인터를 이용해서 찾게됨(fixed size안에 있음)
<img width="70%" alt="스크린샷 2022-02-22 오후 4 30 29" src="https://user-images.githubusercontent.com/80263729/155083548-f5515c21-c1d6-446a-a61a-d6ce52b3515f.png">

- 만약 큰 사이즈 Protocol 타입의 Copy가 일어나면 어떻게 될까? 🤔 
  - 값이 복사가 된다!!
  - Heap은 쓰지만 Reference Count가 없는 신기한 구조가 생긴다. 
  - Copy마다 Heap을 복사하므로 엄청난 성능 저하가 생긴다.

<img width="70%" alt="스크린샷 2022-02-22 오후 4 33 33" src="https://user-images.githubusercontent.com/80263729/155083986-c3ef91a2-124f-4018-9bfb-9078715e4760.png">

- 성능 저하 해결하기(indirect Storage)
  - 성능 저하가가 야기 되는 부분은 var x1,y1...과 같은 사이즈가 큰 프로퍼티들이다 따라서 이들을 담을 storage클래스를 만들고 실제 line에서는 reference만 가지게 한다.
  - reference만 복사가 되기 때문에 값을 복사하는것에 비해 상당한 성능 이점을 가질 수 있다.
  - 하지만.. 만약 값이 바뀐다면 모든 인스턴스들의 값이 바뀐다.
  - 값타입의 장점이 사라지므로 이를 해결해야한다.

<img width="70%" alt="스크린샷 2022-02-22 오후 4 35 38" src="https://user-images.githubusercontent.com/80263729/155084303-788acf5b-be79-4948-b431-f816ab4c4d55.png">

- Copy-on-Write
  - 값을 Write할때만 Copy를 하자
  - 값에 변화가 있을때만 Copy를 하는 방법으로 이방법을 이용하면 값을 바꾸더라도 똑같이 reference Count가 1인 line이 복사가된다.
  - 따라서, 값을 바꾸더라도 서로 영향이 없는 독립적인 값타입의 장점을 살릴 수 있다.
  
<img width="70%" alt="스크린샷 2022-02-22 오후 4 39 49" src="https://user-images.githubusercontent.com/80263729/155084908-3b1752f7-f6f4-4f7b-a2f4-9289c7ce3f6f.png">

- 정리
  - 변수가 Protocol Type으로 사용된 경우 쓰인다
  - 프로토콜을 이용한 다형성 구현이 목적이다
  - Class와 비슷하다
    - 초기화시 Heap사용
    - Dynamic Dispatch( class -> V-Table, protocol -> PWT) 
  
  - Indirect Storage
    - Copy시 Heap할당 대신 Reference counting으로 대체 
  
  - Copy-on-Write
    - Indirect Storage 값이 변경될 시점에 Heap에 할당하여 복사
    - 성능 저하를 최소화함(변경 동작에만)
  
  - String, Array, Dictionary도 비슷한 개념으로 Value semantics 구현  
<img width="30%" alt="스크린샷 2022-02-22 오후 4 48 21" src="https://user-images.githubusercontent.com/80263729/155086218-db602e04-fca7-41a4-a4a4-0c6578914be6.png"><img width="30%" alt="스크린샷 2022-02-22 오후 4 49 26" src="https://user-images.githubusercontent.com/80263729/155086386-1adbb230-1c6d-4e55-bfbd-cb668ee1b06b.png">

- `Generics Type`
  - Protocol Type과 비슷하다
  - Dynamic Method Dispatch를 개선할 수 없을까? 🤔 
    
<img width="50%" alt="스크린샷 2022-02-22 오후 4 57 03" src="https://user-images.githubusercontent.com/80263729/155087477-3746ec90-72ce-435d-ab08-02deb41a52d5.png"><img width="50%" alt="스크린샷 2022-02-22 오후 4 58 07" src="https://user-images.githubusercontent.com/80263729/155087658-d187f622-3dc8-4620-b467-3927fe723069.png">

  - 정적 다형성: 메서드 내에서는 Drawable의 실제 실제 타입이 변하지 않음을 않음을 이용하자
  - 각 타입에 맞게 메서드를 추가로 구현해주는 것이다.

<img width="50%" alt="스크린샷 2022-02-22 오후 4 58 58" src="https://user-images.githubusercontent.com/80263729/155087822-e118f83e-6264-4d8b-ae86-3116f948d357.png">

  - Generics 특수화

<img width="50%" alt="스크린샷 2022-02-22 오후 5 44 22" src="https://user-images.githubusercontent.com/80263729/155095214-d94ba47e-cfd1-495b-bddc-2e0332108cef.png">

  - 장점
    - 복잡한 Existential Container 안써도 된다.
    - 함수 호출시 Heap할당을 없앨 수 있다.
    - Static Method Dispatch로 변해서 컴파일러 최적화가 가능하게 됨. 
  
  - 단점
    - 너무 귀찮다 So..  `컴파일러가 해준다😀`

- 정리
  - 컴파일 시점에 부르는 곳마다 타입이 정해져 있다
  - 런타임에 바뀌지 않는다
  - 그렇기에 특수화가 가능하다.
  
  before
<img width="40%" alt="스크린샷 2022-02-22 오후 5 49 24" src="https://user-images.githubusercontent.com/80263729/155096061-97944293-35af-4252-9958-decf6a352a67.png">

  after  
<img width="40%" alt="스크린샷 2022-02-22 오후 5 50 28" src="https://user-images.githubusercontent.com/80263729/155096254-644757ba-06cc-4a65-baab-7bd921fef30a.png">


<img width="40%" alt="스크린샷 2022-02-22 오후 5 51 20" src="https://user-images.githubusercontent.com/80263729/155096405-dff42a07-d0d5-4bb1-9ae7-3589995a50c3.png">

**추상화 기법의 선택**
- Struct: Value semantics가 맞는 부분
- class: Identity가 필용한 부분, 상속등의 OOP, Objective-C
- Generics: 정적 다형성으로 가능한 경우
- Protocol: 동적 다형성이 필요한 경우

**고려 할 수 있는 성능 최적화 기법**
- Struct에 클래스 타입의 Property가 많으면 값 타입으로 대체해서 Reference Counting을 줄이자
- Mutable해야 한다면 Copy-on-Write를 구현해보자.
