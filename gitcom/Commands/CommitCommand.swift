//
//  CommitCommand.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class CommitCommand: CommandProtocol {
	var name: String = "make"

	var description: String = """
Make beautiful commit.
Add argument -m for inline message.
'|' stand for new line symbol.
Example: gitcom make -m "Type: (Scope) Subject|Body|FooterPrefix: Footer"
"""
	
	private let git = GitProcess()

	private var hasStage: Bool {
		let res = git.run(arguments: ["status", "-uno", "-s"])
		switch res {
		case let .success(string):
			return string.count > 0
		default:
			return false
		}
	}

	private func takeType(header: Header) -> String {
		print(list: header.type.items)
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), let index = Int(input), index <= header.type.items.count, index > 0 else {
			return takeType(header: header)
		}
		let item = header.type.items[index - 1]
		return item.key
	}
	
	private func takeScope(header: Header, type: String) -> String {
		guard header.scope.enabled else {
			return ""
		}
		print(list: header.scope.items.filter({ (item) -> Bool in
			return item.types == nil || item.types!.contains(type)
		}))
		if header.customScope.enabled {
			print(item: ScopeItem(key: Constants.customScopeKey, value: header.customScope.request, types: nil), key: Constants.customScopeIndex)
		}
		if header.scope.skip {
			print(item: ScopeItem(key: Constants.skipScopeKey, value: header.scope.skiptRequest, types: nil), key: Constants.customScopeIndex)
		}
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return takeScope(header: header, type: type)
		}
		
		//check skip
		if header.scope.skip && input == Constants.skipScopeIndex {
			return ""
		}
		
		//check custom
		if header.customScope.enabled, input == Constants.customScopeIndex {
			return takeCustomScope(header: header)
		}
			
		if let index = Int(input), index > 0 {
			let item = header.scope.items[index - 1]
			return item.key
		}
		else {
			return takeScope(header: header, type: type)
		}
	}
	
	private func takeCustomScope(header: Header) -> String {
		info(message: header.customScope.request)
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return takeCustomScope(header: header)
		}
		if input == header.customScope.back {
			return take(header: header)
		}
		if let min = header.customScope.length.min, min.value > input.count {
			print(error: min.message)
			return takeCustomScope(header: header)
		}
		if let max = header.customScope.length.max, max.value < input.count {
			print(error: max.message)
			return takeCustomScope(header: header)
		}
		return input
	}
	
	private func takeSubject(header: Header) -> String {
		info(message: header.request)
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return takeSubject(header: header)
		}
		if let min = header.length.min, min.value > input.count {
			print(error: min.message)
			return takeSubject(header: header)
		}
		if let max = header.length.max, max.value < input.count {
			print(error: max.message)
			return takeSubject(header: header)
		}
		return input
	}
	
	private func take(header: Header) -> String {
		var res: String = ""
		info(message: header.type.request)
		
		//type
		let type = takeType(header: header)
		res += "\(type):"

		//scope
		let scope = takeScope(header: header, type: type)
		if scope.count > 0 {
			res += " (\(scope))"
		}
		
		//subject
		let subject = takeSubject(header: header)
		if subject.count > 0 {
			res += " \(subject)"
		}
		return res
	}
	
	private func take(body: Body) -> String? {
		info(message: body.request)
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return take(body: body)
		}
		if let min = body.length.min, min.value > input.count {
			print(error: min.message)
			return take(body: body)
		}
		if let max = body.length.max, max.value < input.count {
			print(error: max.message)
			return take(body: body)
		}
		return input.replacingOccurrences(of: body.newLineSpacer, with: "\n")
	}
	
	private func take(footer: Footer) -> String? {
		guard footer.enabled else {
			return nil
		}
		info(message: footer.request)
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return take(footer: footer)
		}
		if let min = footer.length.min, min.value > input.count {
			print(error: min.message)
			return take(footer: footer)
		}
		if let max = footer.length.max, max.value < input.count {
			print(error: max.message)
			return take(footer: footer)
		}
		return input.count > 0 ? "\(footer.prefix) \(input)" : nil
	}
	
	private func confirmCommit(message: String) -> Bool {
		info(message: "You message for commit:")
		print("")
		print(message)
		print("")
		info(message: "Does it ok?(y/n):")
		guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
			return confirmCommit(message: message)
		}
		if input == "y" {
			return true
		}
		if input == "n" {
			return false
		}
		return confirmCommit(message: message)
	}
	
	private func makeCommit(message: String) {
		if confirmCommit(message: message) {
			let res = git.run(arguments: ["commit", "-m", message])
			switch res {
			case let .success(string):
				print("RESULT: \n\(string)")
			case let .failure(error):
				print(error: error)
			}
		}
	}
	
	func perform(arguments: [String]) {
		guard git.exists else {
			print(error: "Git does not exist.")
			return
		}
		guard hasStage else {
			print(error: "Nothing to commit. Did you do `git add`?")
			return
		}
		guard let configCommand = run.command(class: CheckConfigCommand.self) else {
			print(error: "Could not find command in charge of config validation")
			return
		}
		
		switch configCommand.config() {
		case let .success(config):
			if let firstArgument = arguments.first, firstArgument == Constants.messageArgument, arguments[safe: 1] == "-m", let message = arguments[safe: 2] {
				let validationCommand = ValidateCommand()
				validationCommand.delegate = self
				validationCommand.perform(arguments: [message])
			}
			else {
				var message = ""
				message += self.take(header: config.header)
				if let body = self.take(body: config.body) {
					message.append("\n\(body)")
				}
				if let footer = self.take(footer: config.footer) {
					message.append("\n\(footer)")
				}
				makeCommit(message: message)
			}
		case let .failure(error):
			print(error: "Config file is invalid.")
			print(error: error)
			return
		}
	}
}

extension CommitCommand: ValidationResultDelegate {
	func validationSuccessful(message: String) {
		makeCommit(message: message)
	}
}
