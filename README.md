# 연락처 관리 프로그램 (console) 📞

> 2022.12.19 ~ 2012.12.30

이름, 나이, 연락처를 저장할 수 있는 연락처 관리 프로그램 📞
수정과 삭제는 안돼요 추가만 가능해요

---
## 👀 Preview

전체 흐름 사진

## Step 1 - 사용자 입력 및 검증 구현

`[이름]/[나이]/[연락처]` 혹은 `[이름] / [나이] / [연락처]`의 형태로 사용자 정보를 입력받아 검증하여 문제가 없을 경우 사용자 정보를 출력합니다.

### 플로우차트

<img width="50%" src="https://i.imgur.com/0xE0PuZ.png">

<br><br>

> [문자열 검증] 입력받은 문자열이 "/"로 인해 각각 [이름], [나이], [연락처]로 나눠지는지 확인합니다.
> 
> [이름 확인] 이름은 한글이 아닌 영어로만 입력이 가능하며 알파벳 사이에 공백은 제거한다.
> 
> [나이 확인] 나이는 숫자로만 입력해야하며 세 자리수이하여야 합니다.
>
> [연락처 확인] 연락처는 '-'로 구분하며, 두 개 존재해야 합니다. 숫자는 9개 이상이어야 합니다.

<img width="100%" src="https://i.imgur.com/FRZxSXO.png">

### 테스트코드

문자열 검증, 이름 확인, 나이 확인, 연락처 확인을 위한 테스트 코드를 작성했습니다

```swift
func testSplit() throws {
    var splitted: (name: String, age: String, phoneNumber: String) = try split(input: "james/30/123-1234-1234")
    XCTAssertEqual(splitted.name, "james")
    XCTAssertEqual(splitted.age, "30")
    XCTAssertEqual(splitted.phoneNumber, "123-1234-1234")

    splitted = try split(input: "james / 30 / 123-1234-1234")
    XCTAssertEqual(splitted.name, "james")
    XCTAssertEqual(splitted.age, "30")
    XCTAssertEqual(splitted.phoneNumber, "123-1234-1234")

    splitted = try split(input: "james / 30 / ")
    XCTAssertEqual(splitted.name, "james")
    XCTAssertEqual(splitted.age, "30")
    XCTAssertEqual(splitted.phoneNumber, "")

    splitted = try split(input: "james/30/")
    XCTAssertEqual(splitted.name, "james")
    XCTAssertEqual(splitted.age, "30")
    XCTAssertEqual(splitted.phoneNumber, "")

    XCTAssertThrowsError(try split(input: ""))
    XCTAssertThrowsError(try split(input: "james/30"))
    XCTAssertThrowsError(try split(input: "james / 30 / 123-1234-1234 / 40"))
    XCTAssertThrowsError(try split(input: "james/30/123-1234-1234/40"))
}

func test이름() {
    XCTAssertEqual(try getName(input: "james"), "james")
    XCTAssertEqual(try getName(input: "jam  es"), "james")
    XCTAssertThrowsError(try getName(input: "한글의이름"))
    XCTAssertThrowsError(try getName(input: ""))
    XCTAssertThrowsError(try getName(input: " james "))
    XCTAssertThrowsError(try getName(input: " james"))
    XCTAssertThrowsError(try getName(input: "james "))
}

func test나이() {
    XCTAssertEqual(try getAge(input: "23"), 23)
    XCTAssertEqual(try getAge(input: "999"), 999)
    XCTAssertEqual(try getAge(input: "0"), 0)
    XCTAssertThrowsError(try getAge(input: "000"))
    XCTAssertThrowsError(try getAge(input: "1234"))
    XCTAssertThrowsError(try getAge(input: "-3"))
    XCTAssertThrowsError(try getAge(input: "010"))
    XCTAssertThrowsError(try getAge(input: " 10 "))
    XCTAssertThrowsError(try getAge(input: " 10"))
    XCTAssertThrowsError(try getAge(input: "10 "))
}

func test전화번호() {
    XCTAssertNoThrow(try isValidPhoneNumber("05-434-2334"))
    XCTAssertThrowsError(try isValidPhoneNumber("054342334"))
    XCTAssertThrowsError(try isValidPhoneNumber("05-4342334"))
    XCTAssertThrowsError(try isValidPhoneNumber("05-4342334-"))
    XCTAssertThrowsError(try isValidPhoneNumber("-05434-2334"))
    XCTAssertThrowsError(try isValidPhoneNumber("05434--2334"))
    XCTAssertThrowsError(try isValidPhoneNumber("05-434-23-34"))
    XCTAssertThrowsError(try isValidPhoneNumber("05-434-234"))
    XCTAssertThrowsError(try isValidPhoneNumber("05 434 2334"))
    XCTAssertThrowsError(try isValidPhoneNumber("james"))
    XCTAssertThrowsError(try isValidPhoneNumber("전화번호부"))
    XCTAssertThrowsError(try isValidPhoneNumber(""))
    XCTAssertThrowsError(try isValidPhoneNumber(" 05-434-2334"))
    XCTAssertThrowsError(try isValidPhoneNumber("05-434-2334 "))
    XCTAssertThrowsError(try isValidPhoneNumber(" 05-434-2334 "))
}
```

## Step 2 - 사용자 메뉴 표기 구현
프로그램은 아래와 같은 동작을 하고 다시 메뉴를 출력합니다
- 1 입력 : `Step 1` 수행
- 2 입력 : 수행하지 않음
- 3 입력 : 수행하지 않음
- x 입력 : 프로그램 종료
- 그 외 입력 : 오류 출력
<br>
### 프로그램 동작

<img width="90%" src="https://i.imgur.com/dxrVKQo.png">

<br>
<br>


반복적인 메뉴 출력을 하기 위해서 `while true`를 생각했으나 ContactManager에서 State의 `.continued` 와 `.quit` 의 값을 확인해서 반복문을 실행하도록 하는 방법을 알았습니다


## Step 3 - 목록/검색 기능 
### 목록 기능
추가된 연락처를 아래와 같은 양식으로 출력합니다

<img width="80%" src="https://i.imgur.com/5if1QBQ.png">
<br>

### 검색 기능
이름을 입력받아 아래와 같은 양식으로 출력합니다

<img width="80%" src="https://i.imgur.com/v1Uwjlg.png">

<br>
<br>

동일한 연락처는 제외시키기 위해 Set를 채택하여 `Set<Contact>` 타입의 `contacts`를 추가하였습니다. . `연락처 목록보기` 메뉴 실행시 contacts를 출력 하였고 `연락처 검색` 메뉴 실행시 입력받은 이름과 동일한 연락처를 출력합니다.

## 피드백을 통해 배운 점
- enum을 통해서 에러 출력만을 사용했었는데, error 타입에 대해서 배우고 do-catch를 사용하는 것까지 배웠습니다.
- 메서드마다 에러를 던지고 최상위 메서드에서 do-catch 사용으로 에러를 파악하는 방법을 통해 좀 더 보기좋은 코드가 된 거 같습니다
- 하나의 메서드당 하나의 기능을 하는 게 이름을 정하는 것과 읽기 쉬운 코드가 되는 것을 배웠습니다.
