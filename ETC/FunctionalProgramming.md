# FP

## 수업목표
1. 왜 FP 가 각광 받는지 
2. "재사용성 -> 동시성" 으로 패러다임의 변경 이해

## 순수 함수

### 정의
특정 input에 대해서 항상 동일한 output을 반환하는 함수, 특히 함수 수행 과정에서 외부의 값을 사용하지도 않고 변경하지도 않는다. 즉, Side-Effect 가 없습니다. 다만, 외부의 값을 사용하더라도, `let` 으로 정의되어 있어 변경이 불가능한 상수를 사용하는 것은 순수함수에 포함됩니다. 반대로 외부의 값을 사용하지 않더라도, 동일 입력값에 대해 함수의 실행시마다 다른 출력값을 내는 함수는 순수 함수가 아닙니다.

```swift
// MARK: - 순수 함수
func greeting(_ name: String) -> String {
return "Hello, \(name)"
}

// MARK: - 비순수 함수
var name = "FP"
var greeting = ""
func makeGreeting() {
greeting = "Hello, \(name)"
}

// MARK: - 외부의 상수를 사용하는 순수함수
let greet = "Hello"
func greeting(_ name: String) -> String {
return "\(greet), \(name)"
}

// MARK: - 실행시마다 값이 바뀌는 비순수 함수
func add(_ a: Int) -> Int {
return Int(arc4random()) + a // 랜덤 로직을 포함하고 있다.
}
```

## Higher-Order Function

* 함수형 프로그래밍에서는 함수를 1급 객체로 취급합니다. 여기서 1급 객체란 프로그래밍 언어에서 함수의 파라미터로 전달되거나 리턴값으로 사용될 수 있는 객체를 뜻합니다. 즉, 함수를 파라미터로 받거나 함수를 리턴하는 함수를 고차 함수라고 합니다. 

### 매개변수로 함수를 전달하는 함수
대표적으로 `filter` 가 있습니다. 

```swift
// MARK: - filter 함수의 정의
func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element]

// MARK: - filter 함수 사용
let arr = [1, 2, 3, 4, 5]
func isEven(_ i: Int) -> Bool {
return i % 2 == 0
}
let evens = arr.filter(isEven) //[2, 4] 함수의 매개변수에 또 다른 isEven 이라는 함수를 전달하였다. 

// MARK: - filter 축약형
let evens = arr.filter { $0 % 2 == 0 }
```
### 함수를 반환하는 함수
```swift
// MARK: - 함수를 반환하는 함수 1 
func multiply(_ a: Int) -> (Int) -> Int {
	func multi(_ b:Int) -> Int {
		return a * b
	}
	return multi
}

let area = multiply(10)(20) //200

// MARK: - 함수를 반환하는 함수 2
let x10 = multiply(10)
let area2 = x10(20) // area2 == 200
```
이 함수는 함수를 반환하고 있습니다. 함수의 실행결과가 함수이기 때문에, `(10)(20)` 처럼 두번 호출해서 최종값을 얻고 있습니다. 또한 반환값을 변수에 넣으면 그 변수를 함수와 동일하게 사용할 수 있습니다.

```swift
import Foundation

let f: (Int) -> Bool = { } //함수 내부를 구현하세요
let s: (Int, Int) -> Int = { } //함수 내부를 구현하세요

func solution(_ nums: [Int]) -> Int {
    return nums.filter(f).reduce(0, s)
}

---

// MARK: - 정답 
let f: (Int) -> Bool = { i in i % 2 ==0 }
let s: (Int, Int) -> Int = { a, b in a + b }
```

## 함수 합성
함수의 반환값이 다른 함수의 입력값으로 사용되는 것을 함수의 합성(Composition)이라고 합니다. 함수가 합성되기 위해서는 함수의 반환값과 이것을 입력으로 받아들이는 값은 타입이 서로 같아야 합니다.
```swift
// MARK: - 함수 합성 1
func f1(_ i: Int) -> Int {
    return i * 2
}

func f2(_ i: Int) -> String {
    return "\(i)"
}

let result = f2(f1(100))

// MARK: - 함수 합성 2
func ff(_ pf1: @escaping (Int) -> Int, _ pf2: @escaping (Int) -> String) -> (Int) -> String {
	return { i in
		return pf2(pf1(i))
	}
}
let f3 = ff(f1, f2)
let result = f3(100

// MARK: - 함수 합성 3
func comp<A, B, C>(_ pf1: @escaping (A) -> B, _ pf2: @escaping (B) -> C) -> (A) -> C {
	return { i in 
		return pf2(pf1(i))
	}
}
let f4 = comp(f1, f2)
```

## Currying
여러개의 파라미터를 받는 함수를 **하나의 파라미터를 받는** 여러 개의 함수로 쪼개는 것을 커링(Currying) 이라고 합니다. 

### why currying?
함수의 합성에서 이 함수의 output 이 저 함수의 input 으로 연결되면서 합성(Composition) 됩니다. 서로 Chain 을 이루면서 연속적으로 연결이 되려면, Output 과 Input의 타입의 개수가 같아야 합니다. 함수의 Output은 하나밖에 없으니 Input도 모두 하나씩만 갖도록 한다면 합성하기가 쉬워질 것입니다.  결국 **함수의 합성을 원활하게 하기 위해서 커링을 사용하는 것입니다.**

```swift
func f(_ a: Int, _ b: Int) -> Int // 매개변수 2개인 하나의 함수

func f1(_ a: Int) -> Int	// 매개변수 1개인 하나의 함수
func f2(_ b: Int) -> Int	// 매개변수 1개인 하나의 함수

func multiply(_ a: Int) -> (Int) -> Int {
    return { b in 
        return a * b
    }
}
let area = multiply(10)(20) //200
```

## Async Result
연산 과정이 시간이 걸리는 경우라면 프로그램의 수행이 멈추게 됩니다. 이러한 방식을 동기식(Sync) 이라고 합니다. 또 다른 비동기식(Async) 방식이 있는데, 결과는 나중에 생길 때 전달받기로 하고, 프로그램의 수행을 멈추지 않는 방식입니다. 연산의 실행이 오래걸리거나, 네트워크를 통해서 결과를 얻거나, 딜레이가 포함되는 내용같은 경우 비동기 방식으로 함수를 구현하는 것이 좋습니다. 

```swift
// MARK: - SYNC
func f(_ nums: [Int]) -> Int {
    sleep(1)
    let sum = nums.reduce(0, +)
    return sum
}

// MARK: - ASYNC
func af(_ nums: [Int], _ result: @escaping (Int) -> Void) {
	DispatchQueue.main.async {
		sleep(1)
		let sum = nums.reduce(0, +)
		result(sum)
	}
	print("right NOW")
}

let nums = [1,2,3,4,5,6,7]
// NARK: - 사용하는 방법
af(nums) { result in			
	print("--------------------")
	print(" After 1 second ")
	print("--------------------")
	print(result)
}


```
여기서 주목할 부분은 결과가 리턴값으로 전달되는 것이 아니라, 전달받은 함수(result)를 호출함으로써 전달된다는 것입니다.  바로 "right NOW" 라는 프린트 문을 찍고, 1초 후에 비동기 부분을 실행하는 함수입니다. 

## 예제 코드
```swift
import Foundation

let answer = Int(arc4random() % 100) + 1
var count = 0

while true {

    let userInput = readLine()

    guard let unwrappedInput = userInput, let inputNumber = Int(unwrappedInput) else {
        print("Wrong")
        continue
    }

    if inputNumber == answer {
        print("Correct! : \(count)")
        break
    }

    if inputNumber > answer {
        print("High")
    }

    if inputNumber < answer {
        print("Low")
    }

    count += 1
}
```
이 코드를 함수형으로 작성해 봅시다!

### step 1
1. 큰부분으로 나누기 while loop 부터 벗기기
2. 밖에 있는 `count` 값을 내부로 옮겨 Side Effect 제거
3. 종료 조건 제공

```swift
func countingLoop(_ needContinue: () -> Bool) {
	var count = 0
	while true {
		if !needContinue { break }
		count += 1
	}
}
```

### step 2
1. 조건 판단하는 부분을 다른 함수로 따로 작성
2. 카운트하는 함수를 재귀 함수로 선언해서 while 문을 사용하지 않도록 작성
3. 결과 출력 부분을 따로 함수로 빼서 작성 
```swift
func inputAndCheck() -> Bool {	// 진행 할 때는 true, 멈춰야 할 때는 false 를 리턴
	let userInput = readLine()
	guard let unwrappedInput = userInput, let inputNumber = Int(unwrappedInput) else {
        print("Wrong")
        return true
        // continue
    }
    if inputNumber == answer {
        return false
    }
    if inputNumber > answer {
        print("High")
    }
    if inputNumber < answer {
        print("Low")
    }
    return true
}

func corrected(_ count: Int) -> Void {
	print("Correct!: \(count)")
}

func countingLoop(_ needContinue: @escaping () -> Bool, _ finished: (Int) -> Void) {

	func counter(_ c: Int) -> Int {
		if !needContinue() { return c }		// 내부에서 한 번 더 호출하기 때문에 escape 로 선언
		return counter(c + 1)		
	}
	finished(counter(0))
}

countingLoop(inputAndCheck, corrected)
```

### step3 
1. inputAndCheck 는 결과를 프린트하는 행동과 결과를 판단하는 행동 두가지를 하고 있으니 이것을 분리
2. 결과 값을 enum 으로 분류
```swift
enum Result: String { 
	case wrong = "Wrong"
	case correct = "Correct!"
	case high = "High"
	case low = "Low"
}

func evaluateInput() -> Result {
	guard let inputNumber = Int(readLine() ?? "") else { return .wrong }
	if inputNumber > answer { return .high }
	if inputNumber < answer { return .low }
	return .correct
}

func printResult(_ r: Result) -> Bool {
	if case .correct = r { return false }
	print(r.rawValue)
	return true
}

// 따라서

func inputAndCheck() -> Bool {
	return printResult(evaluateInput())
}
```

### 외부 변수 제거 
처음 프로그램이 작동하면 랜덤값을 가지고 시작하는데 이를 내부 프로그램이 가지고 시작하게끔 하는 작업
```swift
// 기존
countingLoop(inputAndCheck, corrected)

// 변경후 
countingLoop(inputAndCheck(generateAnswer(1,100)), corrected)

// 변경점 inputAndCheck 함수, 
// func countingLoop(_ needContinue: @escaping () -> Bool, _ finished: (Int) -> Void) 이 부분에 needContinue 매개변수와 맞춰주기 위해서 이렇게 작성
func inputAndCheck(_ answer: Int) -> () -> Bool {
	return { printResult(evaluateInput(answer)) } 
}

// 변경점 evaluateInput
func evaluateInput(_ answer: Int) -> Result {
	guard let inputNumber = Int(readLine() ?? "") else { return .wrong }
	if inputNumber > answer { return .high }
	if inputNumber < answer { return .low }
	return .correct
}

// 추가 되는 함수
func generateAnswer(_ min: Int, _ max: Int) -> Int {
	return Int(arc4random()) % (max - min) + min	// 잘 이해가 안되는 부분
}
```
