//
//  DIP.swift
//  SOLID
//
//  Created by 박진섭 on 2022/03/27.
//

import Foundation


//MARK: -- 의존성역전 원칙: 상위레벨 모듈은 하위레벨 모듈에 의존하면안됨. -> 추상화된 인터페이스에 의존해야한다.

class GameManger {
    private var player:Playerable
    private var playerFactory:PlayerCreator
    
    init(player:Playerable, playerFactory:PlayerCreator) {
        self.player = player
        self.playerFactory = playerFactory
    }
}

//MARK: -- Playerable
protocol Playerable {
    var name: String { get }
    func draw()
}

class Player:Playerable {
    var name: String
    
    func draw() {
        print("draw")
    }
    
    init(name:String) {
        self.name = name
    }
}

class Dealer:Playerable {
    var name: String
    
    func draw() {
        print("Dealer Draw")
    }
    
    init(name:String) {
        self.name = name
    }
}


//MARK: -- Player, Dealer Creator
protocol PlayerCreator {
    func makePlayer() -> Playerable
}

class PlayerFactory:PlayerCreator {
    func makePlayer() -> Playerable{
        return Player(name: "Player")
    }
}

class DealerFactory:PlayerCreator {
    func makePlayer() -> Playerable {
        return Dealer(name: "Dealer")
    }
}

//MARK: -- 의존성 역전
class A {
    let num:Int = 1
}

class B {
    var instanceA:A = A()
}

let b = B()
//MARK: Result -> b.instanceA.num == 1
//A의 값이 바뀐다면..??
//Class B는 A에게 의존성이 있다.

//TODO: -- 의존성 역전

protocol SomeProtocol {
    var num:Int { get set }
}

class C:SomeProtocol {
    var num:Int = 1
}

class D {
    var someNum:SomeProtocol

    init(someNum:SomeProtocol) {
        self.someNum = someNum
    }
 
}

let d = D(someNum: C())
//MARK: Result -> d.someNum == 1
//A의 값이 바뀐다면..??
//Class B는 A에게 의존성이 없어졌다.
//ClassB는 SomeProtocol이라는 추상적인 타입에 의존성이 생김.


//MARK: -- 의존성 3가지 주입방법

//Constructor injection -- init할때 넣어주기
class E {
    let a:SomeProtocol
    init(a:SomeProtocol) {
        self.a = a
    }
}

//Setter Injection -- Setter이용하기
class SomeViewController {
    var someProperty:SomeProtocol? = nil
    
    //ViewDidLoad - settingProerty(property:C() )
    
    private func settingProperty(property:SomeProtocol?) {
        self.someProperty = property
    }
}

//interface Injection -- interface 자체를 주입하기.
protocol SomeInterFace {
    func doSomething(property:SomeProtocol)
}

class F:SomeInterFace {
    var someProperty:SomeProtocol? = nil
    
    func doSomething(property: SomeProtocol) {
        self.someProperty = property
    }
}




