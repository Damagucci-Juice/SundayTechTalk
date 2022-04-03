import UIKit

/*
  self
  Self
 .self
 .Type
 .Protocol
 
 */

//self 자기 자신.
//Self 자기 자신 클래스.
class ABC {
    let a:String = "Park"
    static let b: String = "Kim"
}


//MetaType?
class A {  }

let a = A()
let b = A()

//Object(객체,Type) 자체의 고유한 값(identifier)
print(ObjectIdentifier(a))   //ObjectIdentifier(0x0000600002884140)
print(ObjectIdentifier(b))   //ObjectIdentifier(0x000060000289c0c0)


//Type proerty & instance Method
class Gucci {
    static let price = "expensive"
    
    func howMuch(bagName:String,pirce:Int) {
        print("\(bagName)")
    }
}

//Type Method
let price = Gucci.price

//instance Method
let gucciStore = Gucci()
let buyBag = gucciStore.howMuch(bagName: "Somthing", pirce: 200000000)

//type of
let price0 = type(of: gucciStore)   //메타타입!!


//MARK: -- Using Enum
//MARK: -- 뭔가를 print하는 프로토콜.
protocol SomeProtocol {
    func printSomething()
}


//MARK: -- 프로토콜을 따르는 구체 타입
class SomeClass:SomeProtocol {
    func printSomething() {
        print("Some!!")
    }
}

class AnotherClass:SomeProtocol {
    func printSomething() {
        print("Another!!")
    }
}

enum ClassName:String {
    case some = "SomeClass"
    case another = "AnotherClass"
}

//MARK: -- 매개 변수에 따라서 필요한 클래스를 만듬.
class Factory {
    func makeClass(className:ClassName) ->SomeProtocol? {
        switch className {
        case .some:
            return SomeClass()
        case .another:
            return AnotherClass()
        }
    }
}

//MARK: -- 실행부
let factory = Factory()

let someClass = factory.makeClass(className: .some)
let anotherClass = factory.makeClass(className: .another)

someClass?.printSomething()
anotherClass?.printSomething()


//MARK: -- Using MetaType

//MARK: -- Protocol
protocol SomeProtocol0{
    func printSomething()
}

//MARK: -- Concrete Type
class SomeClass0:SomeProtocol0 {

    
    func printSomething() {
        print("Some!!!")
    }
}

class AnotherClass0:SomeProtocol0 {

    func printSomething() {
        print("Another!!!")
    }
}

//MARK: -- Factory
class Factory0 {
    func makeFactory(type:AnyObject.Type) -> AnyObject? {
        switch type {
        case is SomeClass0.Type:
            return SomeClass0()
        case is AnotherClass0.Type:
            return AnotherClass0()
        default:
            return nil
        }
    }
}

let factory0 = Factory0()

let someClass0 = factory0.makeFactory(type: SomeClass0.self) as? SomeClass0
let anotherClass0 = factory0.makeFactory(type: AnotherClass0.self) as? AnotherClass0

someClass0?.printSomething()
anotherClass0?.printSomething()


//MARK: -- Factory(regist, make)
class Factory1 {
    
    private var map: [
        ObjectIdentifier:AnyObject
    ] = [:]
    
    func regist(aClass:AnyObject) {
        let id = ObjectIdentifier(type(of: aClass))
        map[id] = aClass
    }
    
    //Class자체를 넣어줘야함.
    func makeClass<T>(type:T.Type) -> T? {
        let id = ObjectIdentifier(type)
        guard let result = map[id] as? T else { return nil }
        
        return result
    }
}

let factory1 = Factory1()

factory1.regist(aClass: SomeClass0())
factory1.regist(aClass: AnotherClass0())

let concreateClass = factory1.makeClass(type: SomeClass0.self)      //SomeClass0 클래스 자체의 값,.을 가지고와야함.
let concreateClass2 = factory1.makeClass(type: AnotherClass0.self)


concreateClass!.printSomething()
concreateClass2!.printSomething()


//MARK: -- 실제상황.

protocol APIProviding {
    func fetchData() -> String
}

//NetWork Libary
class APIProvider: APIProviding {
    
    //singleton
    static let shared = APIProvider()
    
    private init() {  }
    
    func fetchData() -> String {
        return "Some Data"
    }
}

//service

//API

// Caller
class Service {
    let provider: APIProviding
    
    init(provider: APIProviding) {
        self.provider = provider
    }
}

//Dendency Injection (construct injection)
class Resolver {
    
    private var map: [
        ObjectIdentifier:AnyObject
    ] = [:]
    
    //ObjectIdentifer를 이용해서 map을 만든다.
    func register(_ aClass:AnyObject) {
        let id = ObjectIdentifier(type(of: aClass))
        
        //overrittien을 막기위해 nil일 경우에만 넣는다.
        guard map[id] == nil else { return }
        
        map[id] = aClass
    }
    
    
    func resolve<T>(type:T.Type) -> T? {
        let id = ObjectIdentifier(type)    //type의 identifier를 id로 받고
        return map[id] as? T               //ID를 이용해서 넣어준 제네릭 타입 T를 리턴함.
    }
}


let resolver = Resolver()
resolver.register(APIProvider.shared)

if let instance = resolver.resolve(type: APIProvider.self) {
    let service = Service(provider: instance)
    print(service.provider.fetchData())
}

