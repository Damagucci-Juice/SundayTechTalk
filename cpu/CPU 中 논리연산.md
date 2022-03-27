# 논리 연산이 뭐지?



## IC 에는 논리 회로가 들어 있다.

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbEkTo_ohJB2r6yFv-G5-AA_xAbs_oZsom5w&usqp=CAU" alt="집적회로" style="zoom:200%;" />



PC 안의 CPU도 **매우 복잡한 고도의 IC**라고 할 수 있다.

위 은색의 핀 하나 하나는 전기의 통로이다.

여기서 '0이나 1(L or H)'이라는 **디지털 신호(전기 신호)를 입출력** 한다.



<img src="https://t1.daumcdn.net/blogfile/fs11/22_blog_2008_04_04_14_37_47f5be85127d5?x-content-disposition=inline" alt="집적 회로 속 논리 회로" style="zoom:200%;" />

오늘은 이것들이 어떻게 자리하는지 배울것입니다.

사진에서 보면 핀 하나하나가 네모로 둘러 쌓인 숫자 하나고, 그 숫자들이 논리 회로로 연결되어 있다.

위의 사진에서 **1, 2, 3** 이 세개의 핀이 어떤식으로 연결되어 있는지 보자. 

> * 입력
>   * 1번, 2번
> * 출력
>   * 3번

즉, 1,2번에 있는 값을 이용해 논리 연산을 한 다음, 3번에 그 값을 저장하는 일을 하는 것이 **논리 회로**이다.



## 3가지 기본 회로(AND, OR, NOT)

|                             AND                              |                              OR                              |                             NoT                              |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="https://res.cloudinary.com/rsc/image/upload/b_rgb:FFFFFF,c_pad,dpr_1.0,f_auto,q_auto,w_700/c_pad,w_700/R2175566-03.jpg" alt="and" style="zoom:25%;" /> | <img src="https://image.shutterstock.com/image-vector/gate-icon-vector-image-can-260nw-2003018039.jpg" alt="or" style="zoom:25%;" /> | <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSV-Q6vp5zYNsVEPf0g0G7VC9vqQBaebjefCekVZi9PcH2VONG1HJlp96srkWX0sme-Da8&usqp=CAU" alt="NOT" style="zoom:25%;" /> |

~~표에 그림 넣는거 어렵네요~~  매달린 가닥들은 입출력 선이라고도 하고, 신호선이라고도 한다. '0이나 1'의 디지털 신호를 전하는 선이라는 뜻 !

* AND : 두개의 입력이 1이어야 출력도 1
* OR : 둘 중 하나의 입력이라도 1이면 출력도 1
* NOT: 입력이 하나인데, 그 하나의 입력에 반대 되는 출력
  * O 하나는 결과를 반전 시키는 역할을 한다.

### 진리표

**AND** : Z = A ' B

| 입력  | 출력 |
| :---: | :--: |
| A - B |  Z   |
| 0 - 0 |  0   |
| 1 - 0 |  0   |
| 0 - 1 |  0   |
| 1 - 1 |  1   |

**OR** : Z = A + B

| 입력  | 출력 |
| :---: | :--: |
| A - B |  Z   |
| 0 - 0 |  0   |
| 1 - 0 |  1   |
| 0 - 1 |  1   |
| 1 - 1 |  1   |

**NOT** 

| 입력 | 출력 |
| :--: | :--: |
|  A   |  Z   |
|  0   |  1   |
|  1   |  0   |



## 그 밖의 기본적인 회로 (NAND, NOR, EXOR)



|                             NAND                             |                             NOR                              |                             EXOR                             |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| ![NAND](data:image/png;base64,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) | ![NOR](data:image/png;base64,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) | ![XOR](data:image/png;base64,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) |

조금 더 낫네요.

> * NAND : AND 게이트에 NOT 을 붙인 모양입니다. 
> * NOR : OR 게이트에 NOT을 붙인 모양입니다.
> * EXOR: 이 모양은 좀 복잡하니까 같이 이해해보도록 하죠.

**NAND 회로 (부정 논리적 회로)**

| A    | B    | Z    |
| ---- | ---- | ---- |
| 0    | 0    | 1    |
| 0    | 1    | 1    |
| 1    | 0    | 1    |
| 1    | 1    | 0    |



**NOR 회로 (부정 논리화 회로)**

| A    | B    | Z    |
| ---- | ---- | ---- |
| 0    | 0    | 1    |
| 0    | 1    | 0    |
| 1    | 0    | 0    |
| 1    | 1    | 0    |



**EXOR 회로 (배타적 논리화 회로)** 

| A    | B    | Z    |
| ---- | ---- | ---- |
| 0    | 0    | 0    |
| 0    | 1    | 1    |
| 1    | 0    | 1    |
| 1    | 1    | 0    |

다른건 몰라도, EXOR 회로 만큼은 그림을 실제 모델로 보는 것이 좋겠다. 이해하려 노력하다 보면 왜 이렇지 하는 생각이 드는데, 정상입니다..

EX 는 Exclusive(배타적인) 의 약어입니다. 

![EXOR](https://electronicsphysics.com/wp-content/uploads/2021/06/Circuit-diagram-of-XOR-gate-using-basic-logic-gates.jpg)



A에 1이 들어가고 B에 1이 들어간 상황을 봅시다. 

위에 AND gate 에는 1 - 0 이 들어가 0 이 나옵니다

아래 AND gate 에는 0 - 1 이 들어가 0 이 나옵니다. 

0 - 0 이 마지막 OR gate 에 들어가 0이 나옵니다.



## 드모르간의 정리

그림으로 봅시다. 19 세기 영국의 수학자 드모르간, 이름도 간지나는 아우구스투스 드모르간.. 그 분의 정리를 소개해 볼까 합니다.

![드모르간의정리](https://media.vlpt.us/images/tonyhan18/post/5ec2e35d-7549-49ef-9f22-1e163d6ba48c/image.png)



논리 곱을 논리 합으로 치환가능 하다. 마찬가지로 논리 합을 논리 곱으로 치환 가능하다.  이게 무슨말인지는 그림을 보면 이해가 됩니다.

![드모르간의 정리에 의한 치환](https://slidesplayer.org/slide/15757016/88/images/16/%EB%93%9C%EB%AA%A8%EB%A5%B4%EA%B0%84%EC%9D%98+%EC%A0%95%EB%A6%AC+%EB%85%BC%EB%A6%AC+%EA%B8%B0%ED%98%B8+A+B+Z%3DA%2BB+A+B+Z%3DA%E2%80%A2B+A%2BB+%3D+A%E2%80%A2B+A+B+Z%3DAB+A%E2%80%A2B+%3D+A%2BB.jpg)



---

# 연산하는 회로

## 덧셈을 하는 회로 

![반가산기](https://t1.daumcdn.net/cfile/tistory/99167E3359B47D320A)

* 반가산기
* AND 회로와 EXOR 회로를 연결해서 보여준다.
* Sum 과 Carry 를 나타낼 수 있다. 왜 이런 모습을 가지게 됬는지 표를 보자

| A    | B    | C    | S    |
| ---- | ---- | ---- | ---- |
| 0    | 0    | 0    | 0    |
| 0    | 1    | 0    | 1    |
| 1    | 0    | 0    | 1    |
| 1    | 1    | 1    | 0    |

S 가 있는 열만 보면 진리표가 무엇과 같은가? 그렇다 바로, EXOR 과 진리표가 같다. 

C 가 있는 열은 AND 와 진리표가 같다. 이 둘을 잘 연결하면 이렇게 되겠지..?

```swift
func halfAdder(_ a: Bool, _ b: Bool) -> (Bool, Bool) {
    var sum: Bool { a != b ? true : false }
    var carry: Bool { a == true && b == true ? true : false}
    return (carry, sum)
}
```

대략적으로 생각해본 반가산기의 코드는 위와 같다.

이 결과, 2가지의 출력이 가능해지는데, 하위 자리와 상위 자리가 가능해진다. 즉, **1비트 간 계산**이 가능해진다.

그런데 말입니다. 여기서 Carry는 두 입력을 계산하고 나온 **자리 올림 값의 출력**입니다. 애초에 처음부터 **자리 올림 값을 입력** 할 수는 없을까요?

이렇게 되면, Carry 를 시작부터 받을 수 있을 듯 합니다! 

**전가산기**

<img src="https://itwiki.kr/images/3/39/%EC%A0%84%EA%B0%80%EC%82%B0%EA%B8%B0.png" alt="전가산기" style="zoom:200%;" />

```swift
func fullAdder(_ a: Bool, _ b: Bool, _ CarryIn: Bool) -> (carryOut: Bool, sum: Bool) {
    var former : (carryOut: Bool, sum: Bool) { halfAdder(a, b) }
    var latter : (carryOut: Bool, sum: Bool) { halfAdder(former.sum, CarryIn) }
    var sum: Bool { latter.sum }
    var carryOut: Bool { latter.carryOut || former.carryOut }
    return (carryOut, sum)
}
```

자 보면은, 반가산기의 경우에 

**출력 값으로 나올 수 있는 경우의 수** 

* 반가산기
  * (0,0), (0,1), (1,0)
* 전가산기
  * (0,0), (0,1), (1,0), (1,1)

![연속전가산기!](https://www.circuitstoday.com/wp-content/uploads/2012/03/ripple-carry-adder.png)

![powerGap](https://blog.kakaocdn.net/dn/W0TLL/btqRx0uGeC2/KxbOgpwhzXXvwu1VtcmjNK/img.jpg)

반가산기와 전가산기를 조합하면? 여러 비트를 계산할 수 있는 계산기가 나온다는 말씀!

여기에는 한가지 아쉬운 점이 있는데, 앞자리의 숫자가 계산이 되기 전에, 뒷자리의 숫자는 가만히 기다릴 수 밖에 없다는 것이다.

그렇다면, 각 자리마다 발생할 자리 올림 입력을 미리 알 수 있다면? 모든 자리가 동시에 자기 일을 처리 할 수 있다. 

이것을 자리 올림 선견 가산기(carry look ahead adder) 라고 한다. 

나중에 **자리 올림 선견 가산기**와 **뺄셈기**를 만들어보는 코드를 짜봐도 재미있을 듯하다.