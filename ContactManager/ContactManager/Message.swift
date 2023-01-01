//
//  Message.swift
//  ContactManager
//
//  Created by 박재우 on 2022/12/21.
//

import Foundation

enum Message {
    case pleaseInputContactData
    case pleaseInputMenu
    case searchContact
    case quit
    case inputContact(contact: Contact)
    case getContact(contact: Contact)
}

extension Message {
    func printSelf() {
        switch self {
        case .pleaseInputContactData:
            print("연락처 정보를 입력해주세요 : ", terminator: "")
        case .pleaseInputMenu:
            print("1) 연락처 추가 2) 연락처 목록보기 3) 연락처 검색 x) 종료\n메뉴를 선택해주세요 : ", terminator: "")
        case .searchContact:
            print("연락처에서 찾을 이름을 입력해주세요 : ", terminator: "")
        case .quit:
            print("[프로그램 종료]")
        case .inputContact(let contact):
            print("입력한 정보는 \(contact.age)세 \(contact.name)(\(contact.phoneNumber))입니다.")
        case .getContact(let contact):
            print("- \(contact.name) / \(contact.age) / \(contact.phoneNumber)")
        }
    }
}
