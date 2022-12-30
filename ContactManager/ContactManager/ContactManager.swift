//
//  ContactManager.swift
//  ContactManager
//
//  Created by 박재우 on 2022/12/29.
//

import Foundation

enum Command: String {
    case addContact = "1"
    case showContacts = "2"
    case searchContact = "3"
    case quit = "x"
}

enum State {
    case continued
    case quit
}

struct ContactManager {
    private var contacts: Set<Contact> = []
    private var state: State = .continued

    private mutating func execute(command: Command) throws {
        switch command {
        case .addContact:
            try addContact()
        case .showContacts:
            showContact()
        case .searchContact:
            try searchContact()
        case .quit:
            self.state = .quit
        }
    }

    mutating func runProgram() {
        while self.state == .continued {
            defer {
                print()
            }
            do {
                guard let command = try createCommand() else {
                    continue
                }
                try execute(command: command)
            } catch {
                print(error.localizedDescription)
            }
        }
        Message.quit.printSelf()
    }

    private mutating func addContact() throws {
        guard let contact = try createContact() else {
            return
        }
        Message.inputContact(contact: contact).printSelf()
        self.contacts.insert(contact)
    }

    private func showContact() {
        let contacts = self.contacts.sorted {
            ($0.name, $1.age) > ($1.name, $0.age)
        }
        for contact in contacts {
            Message.getContact(contact: contact).printSelf()
        }
    }

    private func searchContact() throws {
        Message.searchContact.printSelf()
        guard let name = try getLine() else {
            return
        }
        let contacts = self.contacts.filter { contact in
            contact.name == name
        }
        guard contacts.isEmpty == false else {
            print(ContactManagerError.excludeContact(name: name).localizedDescription)
            return
        }
        for contact in contacts {
            Message.getContact(contact: contact).printSelf()
        }
    }

    func getLine() throws -> String? {
        guard let input = readLine() else {
            return nil
        }
        guard input.isEmpty == false else {
            throw ContactManagerError.emptyInput
        }
        return input
    }

    private func createCommand() throws -> Command? {
        Message.pleaseInputMenu.printSelf()
        guard let input = try getLine() else {
            return Command.quit
        }
        guard let command = Command(rawValue: input) else {
            throw ContactManagerError.invalidCommand
        }
        return command
    }
}
