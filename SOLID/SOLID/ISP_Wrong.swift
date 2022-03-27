//
//  ISP.swift
//  SOLID
//
//  Created by 박진섭 on 2022/03/26.
//

//MARK: ISP - 인터페이스 분리 원칙: 클라이언트 객체는(구체 타입 또는 추상화된 인터페이스든) 사용하지 않는 메서드에 의존하면(열어두면) 안된다.

//BAD Example

class User:UserAble {

    let name:String
    
    init(name:String) {
        self.name = name
    }
    
    func foo() {
        print("\(name): Foo")
    }
    
    func bar() {
        print("\(name): Bar")
    }
    
    func hop() {
        print("\(name): hop")
    }
}

protocol UserAble {
    func foo()
    func bar()
    func hop()
}

let user1 = User(name: "Park")
let user2 = User(name: "Kim")
let user3 = User(name: "Jang")




