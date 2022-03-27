//
//  ISP.swift
//  SOLID
//
//  Created by 박진섭 on 2022/03/26.
//

//MARK: ISP - 인터페이스 분리 원칙: 클라이언트 객체는(구체 타입 또는 추상화된 인터페이스든) 사용하지 않는 메서드에 의존하면(열어두면) 안된다.

//TODO: 사용하지 않는 메서드를 분리해보자.

//Good Example

class FooUser:FooAble {

    let name:String
    
    init(name:String) {
        self.name = name
    }
    
    func foo() {
        print("\(name): Foo")
    }
}

class BarUser:BarAble {

    let name:String
    
    init(name:String) {
        self.name = name
    }
        
    func bar() {
        print("\(name): Bar")
    }
    
}
class HopUser:HopAble {

    let name:String
    
    init(name:String) {
        self.name = name
    }
        
    func hop() {
        print("\(name): hop")
    }
}

protocol FooAble {
    func foo()
}

protocol BarAble {
    func bar()
}

protocol HopAble {
    func hop()
}

let fooUser = FooUser(name: "Park")
let barUser = BarUser(name: "Kim")
let hopUser = HopUser(name: "Jang")

