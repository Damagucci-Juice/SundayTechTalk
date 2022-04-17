
## 팩토리 메서드 패턴

### Class의 인스턴스를 만들 때 어떤 인스턴스를 만들 것인지는 하위객체가 처리하도록 하라!
   
   ![스크린샷 2022-03-06 오후 5 26 41](https://user-images.githubusercontent.com/80263729/156915244-63d42d8d-3941-401b-a33c-3b35207f06d1.png)

   - **Product(프로토콜)**
        - Creator와 하위 클래스가 생성할 수 있는 동일한 인터페이스
        
   - **Concreate Product(클래스)**
        - Product가 선언한 인터페이스로 만든 실제 클래스들.
        
   - **Creator(프로토콜)**
        - 새로운 객체를 반환하는 팩토리 메서드를 선언합니다.
        - 여기서 반환하는 객체는 Product 인터페이스를 준수하고 있어야 해요.
        
   - Concrete Creator(클래스)
        - 기본 팩토리 메서드를 override 하여 서로 다른 Product 객체를 만듭니다.
    
   ### 팩토리 패턴은 언제 사용하는가?
    
   - 예시로 간단하게 두개의 Player클래스를 만들어보았다.
        
       ~~~swift
        
        //MARK: -- Concrete Product
        class MusicPlayer  {
            var content: String
            
            required init(content: String) {
                self.content = content
                
            }
            
            func play() {  print("MusicPlayer Play")  }
            
            func pause() { print("MusicPlayer Pause") }
            
            func changeContent(name: String) {
                print("\(self.content)에서 \(name)로 음악 변경")
                self.content = name }
            
        }
        
        //MARK: -- Concrete Product
         class VideoPlayer {
            var content: String
            
            required init(content: String) {
                self.content = content
            }
            
            func play() {
                print("VideoPlayer Play")
            }
            
            func pause() {
                print("VideoPlayer Pause")
                
            }
            
            func changeContent(name: String) {
                print("\(self.content)에서 \(name)로 비디오 변경")
                self.content = name
            }
        }
        
        let musicPlayer = MusicPlayer(content: "구찌갱갱")
        let videoPlayer = VideoPlayer(content: "Pigbag의 팩토리 메서드 패턴 강의")
        
        musicPlayer.play()
        musicPlayer.changeContent(name: "샤넬 갱갱")
        
        print("------------------------------------")
        
        videoPlayer.play()
        videoPlayer.changeContent(name: "구찌의 CS강의")
        ~~~
        
    
   - 이를 그림으로 표현하면?  
     ![스크린샷 2022-03-06 오후 5 27 19](https://user-images.githubusercontent.com/80263729/156915267-d781704d-2288-45c3-ab65-7ba68d15cd52.png)
   
   
        
    
   - 이때 새로운 Player를 추가하고싶으면 또다른 Player를 만들고 프로퍼티와 인터페이스를 정의해주어야 할 것이다.
        
        이럴 경우 `수정과 추가에 용이하게 하기위해` Factory패턴을 사용한다!
        
    
   - 위 코드를 팩토리 패턴으로 바꾸어보았다.
       
        ~~~swift
        
        //MARK: -- Product Interface
        protocol Player {
            var content: String { get set }
            init(content: String)
            func play()
            func pause()
            func changeContent(name: String)
            
        }
        
        //MARK: -- Concrete Product
        class MusicPlayer: Player {
            var content: String
            
            required init(content: String) {
                self.content = content
                
            }
            func play() { print("MusicPlayer Play") }
            
            func pause() { print("MusicPlayer Pause") }
            
            func changeContent(name: String) {
                print("\(self.content)에서 \(name)로 음악 변경 \n")
                self.content = name }
            
        }
        
        //MARK: -- Concrete Product
         class VideoPlayer: Player {
            var content: String
            
            required init(content: String) {
                self.content = content
            }
            
            func play() {
                print("VideoPlayer Play")
            }
            
            func pause() {
                print("VideoPlayer Pause")
                
            }
            
            func changeContent(name: String) {
                print("\(self.content)에서 \(name)로 비디오 변경 \n")
                self.content = name
            }
        }
        //MARK: -- Creator
        protocol PlayerCreator {
             func createPlayer(content: String, contentType: ContentType) -> Player
         }
        
        enum ContentType {
            case music
            case video
        }
        
        //MARK: -- Factory(Concrete Creator)
         class PlayerFactory: PlayerCreator {
             func createPlayer(content: String, contentType: ContentType) -> Player {
                 switch contentType {
                     case .music:
                     return MusicPlayer(content: content)
                     case .video:
                     return VideoPlayer(content: content)
                 }
             }
         }
        
        let factory = PlayerFactory()
        let musicPlayer = factory.createPlayer(content: "구찌갱갱", contentType: .music)
        let videoPlayer = factory.createPlayer(content: "Pigbag의 팩토리 메서드 패턴 강의", contentType: .video)
        
        musicPlayer.play()
        musicPlayer.changeContent(name: "샤넬 갱갱")
        
        print("------------------------------------ \n")
        
        videoPlayer.play()
        videoPlayer.changeContent(name: "구찌의 CS강의")
        ~~~
        
    
   - 그림으로 나타낸 모습  
![스크린샷 2022-03-06 오후 5 27 59](https://user-images.githubusercontent.com/80263729/156915288-d17afb78-5e82-40eb-8679-b827e2929295.png)


    
   - 결론.
        
        물론 매우 복잡해진? 모습이지만 한번 만들때 잘만들어 놓으면 새로운 Player를 추가할때 
        
        Factory쪽만 수정하면 되며 Player들에게 동일한 인터페이스를 Protocol로 줌으로써 
        
        새로운 player만들때의 번거러움도 어느정도 줄인 모습을 볼 수 있다.
        
    
   [출처]:([https://icksw.tistory.com/237](https://icksw.tistory.com/237), [http://coldwm.github.io/blog/designpattern/java/2015/05/24/Factory-Method-Pattern.html)(http://coldwm.github.io/blog/designpattern/java/2015/05/24/Factory-Method-Pattern.html)
   
   - - -
   ## MVVM 디자인 패턴 연습
   MVVM을 이해하기 위해 영상과 글을 참고해서 예제 앱을 만들어보았다.  
   참고: [https://beomy.tistory.com/43](https://beomy.tistory.com/43)

[https://eeyatho.tistory.com/77](https://eeyatho.tistory.com/77) MVVM 탄생 이유

[https://www.youtube.com/watch?v=M58LqynqQHc](https://www.youtube.com/watch?v=M58LqynqQHc)  MVVM 예제
   
