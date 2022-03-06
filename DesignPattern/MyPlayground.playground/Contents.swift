//
//  Player.swift
//  FactoryMethodPattern
//
//  Created by 박진섭 on 2022/03/06.
//

import Foundation

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

//main class viewController
let factory = PlayerFactory()
let musicPlayer = factory.createPlayer(content: "구찌갱갱", contentType: .music)
let videoPlayer = factory.createPlayer(content: "Pigbag의 팩토리 메서드 패턴 강의", contentType: .video)

musicPlayer.play()
musicPlayer.changeContent(name: "샤넬 갱갱")

print("------------------------------------ \n")


videoPlayer.play()
videoPlayer.changeContent(name: "구찌의 CS강의")


    

