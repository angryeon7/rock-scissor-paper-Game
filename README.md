# 묵찌빠 프로그램

## 구조 설명

- Enum
    - GameResult
    - MukchippaResult
    - RockPaperScissorsResult
- RockPaperScissorsManager
- main

## Step 1. 가위바위보 게임

> 콘솔을 통해 게임을 진행합니다.    
> 최초 실행 시 출력    
> `가위(1), 바위(2), 보(3)! <종료 : 0> :`    
> 사용자에게 `0`, `1`, `2`, `3` 중 한 가지를 입력받아 결과를 출력합니다.        
> 컴퓨터의 패는 임의의 패를 정하여 냅니다.    

> - 비긴 경우 : `“비겼습니다!”` 출력 후 다시 최초 실행 상태로 복귀    
> - 이긴 경우 : `“이겼습니다!”` 출력 후 게임 종료    
> - 진 경우 : `“졌습니다!”` 출력 후 게임 종료    
> - `0`을 입력받은 경우 : 게임 종료    
> - `0`~`3`이 아닌 값을 입력받은 경우 : `“잘못된 입력입니다. 다시 시도해주세요.”` 출력 후 최초 실행 상태로 복귀     

- `play()` : 가위바위보 게임 구동 함수
    - 유저의 입력값을 `readLine()`으로 받음.
    - 사용자 입력값이 Optional 타입이므로 guard let 구문 이용하여 옵셔널 값 제거
    - while문을 사용하여 비긴 경우 다시 최초 실행 상태로 복귀
    - switch문을 이용하여 0을 택한경우,1과 3을 택한 경우, 이 외 입력을 택한 경우로 나누어 처리
      
- `getResult`
    - 컴퓨터의 값을 랜덤하게 추출(Range: 1...3)
    - user값과 computer값을 빼서 3을 더하고 3을 나눈 후 나머지값을 계산하였다.
    - (입력받은 숫자 + 1) = 입력값을 이김 `ex. 1(가위) + 1 = 2(바위)`
        - 따라서 `user값 - computer값` 에서 이기는 경우는 1, -2 / 지는 경우는 -1, 2 이기때문에
        - 3더하고 3을 나눈 후 나머지값을 계산하여 0,1,2로 단순화 하였다.

### 트러블슈팅

readLine()의 값이 nil일때 오류가 발생

```swift
if let input = readLine() {}
```

```swift
guard let input = readLine() else { return }
```

코드의 직관성 문제

```swift
switch resultValue {
            case 0:
                print(Case.draw.rawValue)
            case 1, -2:
                print(Case.win.rawValue)
                status = false
            case -1, 2:
                print(Case.lose.rawValue)
                status = false
            default:
                break
```

```swift
mutating func getResult(userValue: Int) {
        randomValue = Int.random(in: 1...3)
        
        guard let computerValue = randomValue else { return }
        resultValue = (userValue - computerValue + 3) % 3
        guard let gameValue = resultValue else { return }
        
        switch ResultType(rawValue: gameValue) {
        case .draw:
            print(GameResult.draw.rawValue)
        case .userWin:
            print(GameResult.win.rawValue)
            status = false
        case .userLose:
            print(GameResult.lose.rawValue)
            status = false
        case .none:
            break
        }
    }
```

### **개선한 내용**

- 가위바위보의 승패를 계산하는 식의 2가지의 case가 조건을 만족하기 때문에 열거형을 사용하여 직관성을 높혔다.
- guard 구문을 사용해서 들여쓰기를 줄임
- readLine()의 nil 값 오류 수정

## Step 2. 묵찌빠 게임

> - Step 1의 게임 중 가위, 바위, 보 후에 결과에 따라 게임을 이어갑니다.    
>    - 가위, 바위, 보를 비긴 경우 : 다시 가위, 바위, 보 게임 진행      
    - 가위, 바위, 보 게임에서 승패가 갈린 경우 : 묵찌빠로 이어서 게임 진행    
> - 묵, 찌, 빠 실행 시 출력     
    - `[*** 턴] 묵(1), 찌(2), 빠(3)! <종료 : 0> :`    
        - `[*** 턴]` 위치에는 현재 누구의 턴인지 표시합니다.    
        - 가위, 바위, 보 게임 혹은 지난 턴에서 이긴 사람이 턴을 쥡니다.    
        - 잘못된 입력을 한 경우 컴퓨터에게 턴을 넘깁니다.    
> - 사용자에게 `0`, `1`, `2`, `3` 중 한 가지를 입력받아 결과를 출력합니다.     
    - 사용자의 패와 컴퓨터의 패가 동일한 경우 : 턴을 쥐고 있는 쪽이 승리합니다.     
        - `“***의 승리!”` 출력 후 게임 종료     
    - 사용자의 패와 컴퓨터의 패가 다른 경우 : 이긴 쪽이 턴을 쥡니다.    
        - `“***의 턴입니다”` 출력 후 묵, 찌, 빠 계속 실행    
    - `0`을 입력받은 경우 : 게임 종료 

- 코드 중복 최소화를 위해 메서드 분리를 통해 묵찌빠 게임에 사용
- 게임의 승패 상태를 저장
    - 열거형 타입에서 메시지를 분리하여 명시성 추가
- `getRockPaperScissorsResult()` : STEP1에 게임 방식에 따라 사용자의 승패 판정 결과를 출력
    - 비긴 경우, 메시지 출력 후 처음으로 돌아가게 함
    - 나머지 경우, 메시지 출력 후 `nextRound()`값을 변경하여 다음 라운드 진행을 가능케 함
- `getMukchippaResult` : 묵찌빠 게임에 따라 사용자의 승패 판정 결과를 출력
    - 비기는 경우, 해당 턴인 사람을 승자로 게임을 종료
    - 나머지의 경우, 해당 턴인 사람을 저장하고 출력후 계속 게임을 진행함
- `stepCheck()` `stepType()`
    - `nextRound` 값에 따라 해당 라운드를 출력 / 진행
- `calculateValue()` : 결과값을 구하기 위한 계산함수
    - 사용자 입력값과 컴퓨터 입력값의 차를 통해 승자 결정
        - 가위(1), 바위(2), 보(3) : 0 비김 1 이김 2 짐
        - 묵(1), 찌(2), 빠(3) : 0 비김 1 짐 2 이김

### **개선한 내용**

- `private` 접근제어자를 통해 은닉화
    - 객체지향 프로그래밍 관점에서 **객체 외부에서 객체 내부로 직접 데이터나 연산에 접근하면 안되기 때문에** (캡슐화, 은닉화)
    - private를 사용하는 이유는 **다른 사람이 코드 읽었을 때 해당 메서드나 프로퍼티가 private 인지 아닌지를 파악해서 외부에서 호출하는 건지 해당 클래스 내에서 쓰는건지 확실하게 구분**을 하기 위해서 쓰는 것이라고 생각
- 메소드 분리
    - 묵찌빠와 가위바위보의 계산값이 같기 때문에 `calculateValue()` 메소드를 분리하여 재사용
- 가독성 향상
    - switch를 사용하여 가독성 향상
    - 기능적으로는 문제가 없지만 가독성 향상을 위해 변경
    
    ```swift
    enum MukchippaResult: Int {
        case draw = 0
        case computer = 1
        case user = 2
    
        var turnMessage: String {
            return self == .user ? "[사용자 턴]" : "[컴퓨터 턴]"
        }
    
        var winMessage: String {
            return self == .user ? "사용자의 승리" : "컴퓨터의 승리"
        }
    
        var turnStartMessage: String {
            return self == .computer ? "컴퓨터의 턴입니다." : "사용자의 턴입니다"
        }
    }
    ```
    
    ```swift
    var winMessage: String? {
                switch self {
                case .user:
                    return "사용자의 승리"
                case .computer:
                    return "컴퓨터의 승리"
                case .draw:
                    return nil
                }
      }
    ```

    ### 실행 이미지
  <p align="center">
  <img width="492" alt="스크린샷 2023-12-03 오후 7 33 16" src="https://github.com/angryeon7/TIL/assets/87401351/5ca94cf5-b739-4d99-ba64-7bf4f59c0f44">
