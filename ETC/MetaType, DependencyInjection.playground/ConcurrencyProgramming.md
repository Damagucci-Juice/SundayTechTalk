> 동시성 프로그래밍은 많은 수의 코어를 효율적으로 활용하는 데 도움을 줍니다. 
iPhone 12의 경우 6개의 코어를 장착하고 있어, 이와 같이 코어 수가 늘어 남에 따라 동시성 프로그래밍을 잘 이해하고 그 이점을 활용하는 것이 점점 더 중요해지고 있습니다.


# 스위프트 동시성의 두 축:  GCD 와 Swift Concurrency

## GCD(Grand Central Dispatch)

기존에 iOS 개발에서 주로 사용되고 있는 동시성 프로그래밍 API 입니다. Swift가 나오기 전 Object-C부터 존재하는 개념으로, 동시성 프로그래밍에 대한 높은 수준의 추상화를 제공합니다. Serial DispatchQueue는 한 번에 하나의 태스크를 순차적으로 실행하고, concurrent DispatchQueue는 많은 작업을 동시에 실행합니다. 두 경우 모두 작업 순서는 FIFO입니다.

GCD를 사용하면 async로 작업을 수행하고 나서 보통 탈출 클로저를 이용한 completion handler를 통해 해당 작업이 끝났을 때의 처리를 해주게 됩니다.

## Swift Concurrency

WWDC 2021에서 새로 소개된 동시성 프로그래밍 API 입니다. Swift Concurrency는 동시성 프로그래밍을 가독성이 좋은 깔금한 코드로 작성하고자 도입된 개념입니다. Async와 await 키워드를 이용해 비동기 태스크 종료 후 코드를 작성할 수 있습니다. Await 키워드로 인해 중지되면 이후에 사용해야하는 데이터를 힙(heap) 영역에 저장해 두고,  이후에 다시 힙 영역에서 해당 데이터를 사져와 사용합니다. 

# 기존 동시성 프로그래밍과 Swift Concurrency 비교

## 동시성프로그래밍 without Swift Concurrency

```
listPhotos(inGallery: "Summer Vacation") { photoNames in
    let sortedNames = photoNames.sorted()
    let name = sortedNames[0]
    downloadPhoto(named: name) { photo in
        show(photo)
    }
}
```

이 간단한 경우에도 completion handler가 연속해서 사용되어야 하므로 결국 중첩 클로저를 작성하게 됩니다. 이 스타일에서는 더 많이 중첩된 복잡한 코드는 잘 이해가 안될 수 있습니다. (예: 장풍)

## Swift Concurrency

```
func listPhotos(inGallery name: String) async throws -> [String] {
    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Two seconds
    return ["IMG001", "IMG99", "IMG0404"]
}

func downloadPhoto(name: String) async throws -> String {
    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)  // Two seconds
    return “IMG001”
}


let photoNames = await listPhotos(inGallery: "Summer Vacation")
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
let photo = await downloadPhoto(named: name)
print(“4초가 지났나요?”)
```

위의 코드는 갤러리에 모든 사진의 이름을 가져온 다음에 첫번째 사진을 보여줍니다.

throw와 async를 둘 다 사용해야할 때는 async가 먼저 옵니다. 

비동기 메서드를 호출할 때 해당 메서드가 반환될 때까지 실행이 일시 중단됩니다. 중단될 가능성이 있는 지점을 표시하기 위해 호출 앞에 await를 작성합니다. 이는 에러 핸들링을 위한 try 키워드와 비슷합니다. 비동기 메서드 내에서 실행 흐름은 다른 동기 메서드를 호출할 때만 일시 중단됩니다. 

listPhotos(inGallery:)와 downloadPhoto(named:) 함수 모두 네트워크 요청을 필요로 하기 때문에 완료하는데 비교적 오랜시간이 걸릴 수 있습니다. 반환 화살표 전에 async 를 작성하여 둘다 비동기 코드로 만들면 이 코드는 그림이 준비될 때까지 기다리는 동안 앱의 나머지 코드가 계속 실행될 수 있습니다. 

실행 순서

1. 코드는 첫번째 줄에서 실행을 시작하고 첫번째 await 까지 실행됩니다. listPhoto(inGallery:) 함수를 호출하고 해당 함수가 반환될 때까지 실행을 일시 중단합니다. 
2. 이 코드의 실행이 일시 중단되는 동안 같은 프로그램의 다른 동시코드가 실행됩니다. 예를 들어 오랜 시간 실행되는 백그라운드 작업이 새 사진 목록을 업데이트 할 수 있습니다. 이 코드는 await 로 표시된 다음 중단 지점 또는 완료될 때까지 실행됩니다. 
3. listPhoto(inGallery:) 가 반환된 후에 이 코드는 해당 지점에서 시작하여 계속 실행됩니다. 반환된 값을 photoNames 에 할당합니다.
4. sortedNames 와 name 을 정의하는 라인은 일반적인 동기 코드입니다. 이 라인은 await로 표시되지 않았으므로 가능한 중단 지점이 없습니다.
5. 다음 await 는 downloadPhoto(named:) 함수에 대한 호출을 표시합니다. 이 코드는 해당 함수가 반환될 때까지 실행을 다시 일시 중단하여 다른 동시 코드에 실행할 기회를 제공합니다.
6. downloadPhoto(named: ) 가 반한된 후에 값을 photo 에 할당된 다음에 show(_ : ) 를 호출할 때 인수로 전달됩니다. 

Await로 표시된 코드의 중단이 가능한 지점을 쓰레드 양보(yielding the thread)라고도 부릅니다. 코드의 실행 부분이 일시적으로 중단되고, 대신 해당 쓰레드에서 다른 코드를 실행하기 때문에 이것을 쓰레드 양보라고 하는 것입니다. 


# 비동기 함수 병렬로 호출

await를 사용하여 비동기 함수를 호출하면 한번에 코드의 한 부분만 실행됩니다. 비동기 코드가 실행되는 동안 호출자는 코드의 다음 라인을 실행하기 위해 이동하기 전에 해당 코드가 완료 될 때까지 기다립니다. 예를들어 갤러리에서 처음 세장의 사진을 가져오려면 다음과 같이 downloadPhoto(named: ) 함수에 대한 세 번의 호출을 기다릴 수 있습니다.

```
let firstPhoto = await downloadPhoto(named: photoNames[0])
let secondPhoto = await downloadPhoto(named: photoNames[1])
let thirdPhoto = await downloadPhoto(named: photoNames[2])

let photos = [firstPhoto, secondPhoto, thirdPhoto]
show(photos)
```

여기서 중요한 단점이 있습니다. 다운로드가 비동기이고 진행되는 동안 다른 작업을 수행할 수 있지만 downloadPhoto(named: ) 에 대한 호출은 한 번에 하나만 실행됩니다. 각 사진은 다음 사진이 다운로드를 시작하기 전에 완료됩니다. 그러나 이런 작업을 기다릴 필요가 없습니다. - 각 사진은 개별적으로 또는 동시에 다운로드 할 수 있습니다.

비동기 함수를 호출하고 주변의 코드와 병렬로 실행하려면 상수를 정의할 때 let 앞에 async 를 작성하고 상수를 사용할 때마다 await 를 작성합니다. 

```
async let firstPhoto = downloadPhoto(named: photoNames[0])
async let secondPhoto = downloadPhoto(named: photoNames[1])
async let thirdPhoto = downloadPhoto(named: photoNames[2])

let photos = await [firstPhoto, secondPhoto, thirdPhoto]
show(photos)
```

이 예제에서 세번의 다운로드는 각 다운로드를 기다리지 않고 실행됩니다. 시스템 자원이 충분하다면 동시에 실행할 수 있습니다. 다운로드를 기다리지 않는 대신 photos 가 정의된 라인에서 await로 표시하고 각각의 다운로드가 완료될 때까지 기다립니다.

## 비동기 직렬처리와 병렬처리 비교

* 다음 줄의 코드가 해당 함수의 결과에 따라 달라지면 await 를 사용하여 비동기 함수를 호출합니다. 이것은 순차적으로 실행되는 작업을 생성합니다. 
* 나중에 코드에서 결과가 필요하지 않을 때 async - let 을 사용하여 비동기 함수를 호출합니다. 이렇게 하면 병렬로 수행할 수 있는 작업이 생성됩니다.
* Await 와 async - let 은 모두 일시 중단되는 동안 다른 코드를 실행할 수 있도록 합니다. 
* 두 경우 모두 비동기 함수가 반환될 때 까지 필요한 경우 실행이 일시 중단됨을 나타내기 위해 가능한 일시 중단 지점을 await 로 표시합니다.

하나의 소스에서 이 두가지 접근 방식을 혼합할 수도 있습니다.

# 참조 

* [Line_기술블로그](https://engineering.linecorp.com/ko/blog/about-swift-concurrency/)
* [swift_docs_한국어(ver)](https://bbiguduk.gitbook.io/swift/language-guide-1/concurrency#tasks-and-task-groups)
* [JK_mediem](https://medium.com/@jungkim/%EC%8A%A4%EC%9C%84%ED%94%84%ED%8A%B8-%EB%8F%99%EC%8B%9C%EC%84%B1-%EB%A1%9C%EB%93%9C%EB%A7%B5%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC-about-swift-concurrency-roadmap-ccf651c09c4c)
* [블로그](https://sujinnaljin.medium.com/swift-async-await-concurrency-bd7bcf34e26f)
