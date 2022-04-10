Last login: Fri Apr  8 16:35:13 on ttys000
 ~  cd ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer   master ± 
gst
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   "cpu/\352\270\260\354\226\265\355\225\230\353\212\224 \355\232\214\353\241\234.md"
# CPU 구조 - 2 -

        * 연산 등의 대상이 되는 목적물

* 레지스터
        * CPU 속에 간단한 기억 장치
                * 어큐뮬레이터(누적기)
                        * 계산해서 값을 쌓아가는 이미지
                * 범용 레지스터
                        * 널리 다양하게 쓰임
                * 명령 레지스터
                        * 메모리에서 읽은 명령을 일단 저장해두기 위한 레지스터

3. ALU 에서 덧셈을 실행


no changes added to commit (use "git add" and/or "git commit -a")
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer   master ± 
ga .
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer   master ✚ 
gcmsg "docs: something has changed"
[master d21dfe9] docs: something has changed
 1 file changed, 5 insertions(+), 6 deletions(-)
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer   master  ls

Performance   cpu           git           network
README.md     designPattern memory
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer   master  cd
 cpu
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer/cpu   master  ls
CPU 中 논리연산.md
DoubleModeAndInterrupt.md
ProcessAndThread.md
README.md
WhatDoesCPUWork.md
기억하는 회로.md
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer/cpu   master  vi HowCanCPUProcess.md
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer/cpu   master  ga .
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer/cpu   master ✚  gcmsg "docs: 명령 작동 20220410"
[master 5bd2d19] docs: 명령 작동 20220410
 1 file changed, 75 insertions(+)
 create mode 100644 cpu/HowCanCPUProcess.md
 ~/Documents/CodeSqurd/computerSienceAndDesignPatternForBegginer/cpu   master  gp
# CPU 구조 - 2 -

## 명령은 오퍼랜드와 명령 코드로 구성된다

* 메모리에 들어있는 명령
|0번 | 명령 |
|---|---|
|1번 | 명령 |
|2번 | 명령 |
...
이 명령에 대해서 알아볼 것입니다.

** 명령 **
* 정의
        * 인간이 넣어준 프로그램을 CPU가 이해하기 쉬운 형태로 만든 게 '명령'
프로그램은 명령의 연속이라고 할 수 있다.

* 구성
|2와 3을 | 더하시오 |
|---|---|
|오퍼랜드|명령코드|

* 오퍼랜드
        * 연산 등의 대상이 되는 목적물
-- INSERT --# CPU 구조 - 2 -

## 명령은 오퍼랜드와 명령 코드로 구성된다

* 메모리에 들어있는 명령
|0번 | 명령 |
|---|---|
|1번 | 명령 |
|2번 | 명령 |
...
이 명령에 대해서 알아볼 것입니다.

** 명령 **
* 정의
	* 인간이 넣어준 프로그램을 CPU가 이해하기 쉬운 형태로 만든 게 '명령'
프로그램은 명령의 연속이라고 할 수 있다. 

* 구성
|2와 3을 | 더하시오 |
|---|---|
|오퍼랜드|명령코드|

* 오퍼랜드 
	* 연산 등의 대상이 되는 목적물
	* 오퍼랜드 자체가 어드레스로 지정하는 경우가 있다.
* 명령 코드
	* 덧셈
	* 비교
	* 저장
	* 점프
	...
외에도 다양한 명령의 종류가 있다.

## 연산에는 어큐뮬레이터 등의 레지스터를 이용한다.

> 명령을 실행하기 위해서는 레지스터라는 것이 필요하다. 

* 레지스터
	* CPU 속에 간단한 기억 장치
		* 어큐뮬레이터(누적기)
			* 계산해서 값을 쌓아가는 이미지
		* 범용 레지스터 
			* 널리 다양하게 쓰임
		* 명령 레지스터
			* 메모리에서 읽은 명령을 일단 저장해두기 위한 레지스터

![image](https://user-images.githubusercontent.com/50472122/162595446-1e252407-c451-4685-bd69-e09b179466e6.png)
1. 'x 번 데이터 2' 를 어큐뮬레이터에 저장
2. 'y 번 데이터 3' 을 범용 레지스터에 저장한 후,
3. ALU 에서 덧셈을 실행
4. 연산 결과 데이터 5 는 다시 어큐뮬레이터에 저장한다.

# CPU 의 명령 처리 동작

![CPU 개념도](https://user-images.githubusercontent.com/50472122/161407774-aa4df9e4-a5b3-4663-a6fa-9ce91634c660.jpeg)

명령 처리 동작이라 적어놨지만, 순서라고 봐도 무방하다. 

* 프로그램 카운터(Program Counter)
	* 다음에 실행할 명령의 번지(어드레스)를 기억
	* 항상 한 발 앞의 일을 생각하고 있는 것과 마찬가지! 
* 어드레스 레지스터
	* PC 가 기억한 계산을 일시적으로 저장해 놓는 레지스터
	* 추후에 여기에 있는 값을 바탕으로 메모리에 전해진다.
* 명령 레지스터
	* 메모리는 어드레스가 지정된 **명령**을 CPU로 건네준다. 
	* 전달된 명령을 일단 저장해 놓는 곳이 명령 레지스터
* 명령 디코더(해독기)
	* 메모리 상에 명령의 기계어와 CPU 의 제어 신호를 조율
	* 즉, 읽힌 명령 코드를 실제로 명령으로 실행할 준비를 하는 것!

명령이 이런 순서로 해독이 되면, 오퍼랜드와, 명령 코드를 알 수 있다.
이후 부턴, ALU가 계산을 하고, 계산된 결과를 최종적으로는 **레지스터나 메모리에 저장**된다. 


