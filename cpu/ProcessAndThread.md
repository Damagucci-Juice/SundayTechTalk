# 프로세스와 스레드
2022.01.27

## 1. 프로세스
> cpu가 메모리등 자원을 할당하여 작업을 처리하는 단위이다.

<img width="609" alt="Screen Shot 2022-01-27 at 3 03 27 PM" src="https://user-images.githubusercontent.com/50472122/151301377-ca2298e8-0c42-4721-bfb5-90492e1cbd7a.png">

### 1.1. 정의
 * 프로그램이 메모리 적재된 상태를 말한다.
 * 디스크에 잠들어 있을 땐 프로세스가 아니다.

### 1.2. 특징

* 동시성
 : 일부분씩 순차적으로 작업하는데 이게 매우 빨라 동시에 일어나는 것처럼 보인다.
```
작업순서
1 - 2 - 3 - 4
사람 눈에 보이는 작업 순서
4 
```

* 병렬성 : 프로세서 하나에 코어가 여러개로 동시에 작업

## 2. 스레드
> 한 프로세스 안에서 실질적인 작업 단위의 갈래 (실타래, Thread)

<img width="618" alt="Screen Shot 2022-01-27 at 3 03 37 PM" src="https://user-images.githubusercontent.com/50472122/151301330-b6cd9d9f-4bd6-4fd9-b259-721e44247300.png">


### 2.1. 정의
* 프로세스가 할당받은 자원을 이용하는 실행 단위
* 프로세스 내에서 실행되는 여러 흐름의 단위
* 프로세스 마다 최초의 스레드가 반드시 있는데 이를 메인 스레드라고 한다.

### 2.2. 특징
* 프로세스의 메모리 주소 공간을 공유하지만 스택 영역은 스레드마다 독자적으로 갖는다.
* 즉, code, data, heap 영역을 공유한다.
* 메모리를 공유하기에 한 스레드가 프로세스 자원을 변경하면 다른 이웃 스레드(Sibling Thread)도 즉시 결과를 볼 수 있다. 
* 동기화, 데드락 등의 문제가 발생 가능하다.

### 2.3. 프로세스와 스레드의 차이

<img width="624" alt="Screen Shot 2022-01-27 at 3 03 03 PM" src="https://user-images.githubusercontent.com/50472122/151301350-3bfe5db7-6acb-452a-bbb8-4adc9fa80ac9.png">


> "만약 프로세스가 최소 작업단위라면 ?"

    * 여러 프로세스는 동작하기 위해 프로세스마다 시스템 콜을 수행한다.
    * 전체 시스템 적으로 자원 손실이 발생한다.

> "만약 스레드가 최소 작업 단위라면?"

    * 여러 스레드는 동작하기위해 프로세스가 요청한 한번의 시스템콜만 있으면 충분하다.
    * 자원 효율성을 기대할 수 있다.

> "서로 어떻게 통신할까?"
 (프로세스 - 프로세스 / 스레드 - 스레드)

    * 프로세스간 통신: IPC(Inter-Process Communication)
    * 스레드간 통신: 이벤트 모듈이나 객체간 메시징
    * IPC 보다는 스레드간 통신이 덜 복잡하고 시스템적으로 자원 사용이 더 적어 통신 부담이 덜하다.

## 3. 멀티 프로세스
> 하나의 응용프로그램을 여러 프로세스로 구성(각 프세스가 하나의 task를 처리)




### 3.1. 장점
* 프로세스 중에 하나에 문제가 발생하여도 그 자식 프로세스만 죽임으로써 영향이 나머지 프로세스에 미치지 않는다.
### 3.2. 단점
* 문맥 교환시 캐시 메모리 초기화 등의 오버헤드가 발생한다.
* 프로세스 각각은 독립된 메모리 주소를 할당받고 그 사이 통신은 IPC를 사용하기에 프로세스간 변수 공유가 어렵다.

## 4. 멀티 스레딩
> 하나의 응용프로그램을 여러개의 스레드로 구성하고 스레드가 최소 작업 단위이다.

### 4.1. 장점
* 시스템 자원 절약: 자원 할당 요청 시스템 콜이 단 한번이면 된다. 
* 시스템 처리량 증가: 스레드 마다 작업량(스택)이 작아 context switching이 빠르다. 
* 응답시간 단축: 간단한 통신방법으로 프로세스 내에 스택을 제외한 전 영역을 공유하여 통신 부담이 적다.

### 4.2. 단점
* 설계 및 디버깅이 까다롭다.
* 단일 프로세스 시스템은 멀티 스레딩을 적용해도 효과를 기대하기 어렵다.
* 다른 프로세스에서 스레드 제어가 안된다.
* 멀티 스레드에서 자원 공유 문제가 발생한다(동기화 문제). 스레드가 프로세스 내 자원 변경 -> 동시에 다른 스레드가 똑같은 자원을 변경하면 원하는 작업결과를 얻을 수 없다.
* 하나의 스레드에서 문제가 발생하면 전체 프로세스가 영향을 받는다.

## 5. 결론: 멀티 프로세스 대신 멀티 스레드를 사용하는 이유
> 프로그램 여러 개를 키는 것보다 하나의 프로그램 안에서 여러 작업을 해결하는 것이 낫다.

<img width="622" alt="Screen Shot 2022-01-27 at 3 03 10 PM" src="https://user-images.githubusercontent.com/50472122/151301271-a44a1b16-f518-4754-8a66-3bd60d3268fb.png">

### 자원의 효율성 증대
> 
    1. 멀티 프로세스로 작업하던 걸 멀티 스레드로 변경한다면 시스템 콜이 줄어들어 자원을 효율적으로 관리할 것이다.
    2. 스레드는 프로세스 내의 메모리를 공유하기 때문에 독립적인 프로세스와는 달리 스레드 간 데이터를 주고 받는 것이 간단해지고 시스템 자원 소모가 줄어들게 된다.
    3. Context Switching 시에 스레드는 스택 영역만 처리하기 때문에 프로세스간 전환 속도 보다 스레드 간 전환 속도가 빠르다.


---
### 참조
* [gparkkii.log](https://velog.io/@gparkkii/ProgramProcessThread?utm_source=pocket_mylist)