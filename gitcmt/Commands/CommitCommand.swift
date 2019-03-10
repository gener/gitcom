//
//  CommitCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class CommitCommand: CommandProtocol {
	var name: String = "make"

	var description: String = """
Make beautiful commit.
"""
	
	private let gitURL = URL(fileURLWithPath: "/usr/bin/git")
	
	private var hasGit: Bool {
		let res = gitBash(arguments: ["rev-parse", "--is-inside-work-tree"])
		switch res {
		case let .success(string):
			return string == "true"
		default:
			return false
		}
	}
	
	private var hasStage: Bool {
		let res = gitBash(arguments: ["status", "-uno", "-s"])
		switch res {
		case let .success(string):
			return string.count > 0
		default:
			return false
		}
	}
	
	private func gitBash(arguments: [String]) -> Result<String, Error> {
		let process = Process()
		process.executableURL = gitURL
		process.arguments = arguments
		let outputPipe = Pipe()
		let errorPipe = Pipe()
		process.standardOutput = outputPipe
		process.standardError = errorPipe
		do {
			try process.run()
			let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
			let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
			let output = String(decoding: outputData, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
			let errorMsg = String(decoding: errorData, as: UTF8.self)
			if errorMsg.count > 0 {
				return Result.failure(error(errorMessage: errorMsg))
			}
			return Result.success(output)
		}
		catch {
			return Result.failure(error)
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
			let item = header.type.items[index - 1]
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
		if let min = header.customScope.lenght.min, min.value > input.count {
			print(error: min.message)
			return takeCustomScope(header: header)
		}
		if let max = header.customScope.lenght.max, max.value < input.count {
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
		if let min = header.lenght.min, min.value > input.count {
			print(error: min.message)
			return takeSubject(header: header)
		}
		if let max = header.lenght.max, max.value < input.count {
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
		if let min = body.lenght.min, min.value > input.count {
			print(error: min.message)
			return take(body: body)
		}
		if let max = body.lenght.max, max.value < input.count {
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
		if let min = footer.lenght.min, min.value > input.count {
			print(error: min.message)
			return take(footer: footer)
		}
		if let max = footer.lenght.max, max.value < input.count {
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
	
	func perform(arguments: [String]) {
		guard hasGit else {
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
			var message = ""
			message += self.take(header: config.header)
			if let body = self.take(body: config.body) {
				message.append("\n\(body)")
			}
			if let footer = self.take(footer: config.footer) {
				message.append("\n\(footer)")
			}
			if confirmCommit(message: message) {
				let res = gitBash(arguments: ["commit", "-m", message])
				switch res {
				case let .success(string):
					print("RESULT: \n\(string)")
				case let .failure(error):
					print(error: error)
				}
			}
			
		case let .failure(error):
			print(error: error)
			return
		}
	}
	
}
