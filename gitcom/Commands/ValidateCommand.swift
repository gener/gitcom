//
//  ValidateCommand.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

protocol ValidationResultDelegate: class {
	func validationSuccessful(message: String)
}

class ValidateCommand: CommandProtocol {
	var name: String = "validate"
	
	var description: String = """
Validate message for commit.
Add message as parameter.
"""

	public weak var delegate: ValidationResultDelegate?
	
	private func checkType(header: Header, subject: String) -> Result<String, String> {
		//get type
		guard let type = subject.split(separator: ":").first else {
			return Result.failure("Could not find type in subject commit.")
		}
		//check type
		guard let _ = header.type.items.first(where: { row in
			return row.key == type
		}) else {
			return Result.failure("Type \(type) is unavaliable.")
		}
		return Result.success(String(type))
	}
	
	private func checkScope(header: Header, subject: String, type: String) -> Result<String, String> {
		let pattern = "(?:\(type):\\s)(?:\\(([^\\)]+)\\))"
		let scope = subject.capturedGroups(withRegex: pattern).first
		//scope disabled but exists
		if scope != nil && !header.scope.enabled {
			return Result.failure("Scope is not avaliable for using.")
		}
		//scope enabled
		guard header.scope.enabled else {
			return Result.success("")
		}

		//scope empty but not allowed to skip
		if scope == nil && !header.scope.skip {
			return Result.failure("Scope does not exist.")
		}
		//allowed to skip and empty
		if scope == nil && header.scope.skip {
			return Result.success("")
		}
		
		let sScope = scope!
		let isAvaliableScope = header.scope.items.first(where: { item in
			return (item.types == nil || item.types!.contains(type)) && item.key == sScope
		}) != nil
		
		
		//not avaliable scope for this type
		if !isAvaliableScope && header.scope.items.contains(where: { (row) -> Bool in
			return row.key == sScope
		}) {
			return Result.failure("Scope `\(sScope)` is not avaliable for this type `\(type)`.")
		}
		if !isAvaliableScope && header.customScope.enabled {
			if let min = header.customScope.length.min, min.value > sScope.count {
				return Result.failure("Scope `\(sScope)` has small length.")
			}
			if let max = header.customScope.length.max, max.value < sScope.count {
				return Result.failure("Scope `\(sScope)` has big length.")
			}
		}
		else if !isAvaliableScope && !header.customScope.enabled {
			return Result.failure("Custom scope `\(sScope)` is not avaliable.")
		}
	
		return Result.success(sScope)
	}
	
	private func checkHeaderLength(header: Header, subject: String, scope: String) -> Bool {
		guard let subjectString = subject.split(separator: ")")[safe: 1] else {
			print(error: "Commit subject must not be empty.")
			return false
		}
		if let min = header.length.min, min.value > subjectString.count {
			print(error: min.message)
			return false
		}
		if let max = header.length.max, max.value < subjectString.count {
			print(error: max.message)
			return false
		}
		return true
	}
	
	private func validateHeader(header: Header, subject: String) -> Bool {
		switch checkType(header: header, subject: subject) {
		case let .success(type):
			switch checkScope(header: header, subject: subject, type: type) {
			case .success(let scope):
				return checkHeaderLength(header: header, subject: subject, scope: scope)
			case let .failure(message):
				print(error: message)
			}
		case let .failure(message):
			print(error: message)
		}
		
		return false
	}
	
	private func validateBody(bodySettings: Body, body: String?/*, footerSettings: Footer*/) -> Bool {
		guard let bodyString = body, !bodyString.isEmpty else {
			print(error: "Commit message must not be empty.")
			return false
		}
		if let min = bodySettings.length.min, min.value > bodyString.count {
			print(error: min.message)
			return false
		}
		if let max = bodySettings.length.max, max.value < bodyString.count {
			print(error: max.message)
			return false

		}
		return true
	}
	
	private func validateFooter(footerSettings: Footer, footer: String?) -> Bool {
		guard var footerString = footer, !footerString.isEmpty else {
			if footerSettings.enabled {
				print(error: "Footer is enabled but empty.")
			}
			return footerSettings.enabled ? false : true
		}

		if !footerString.hasPrefix(footerSettings.prefix) {
			print(error: "Footer has wrong prefix.")
			return false
		}
		
		footerString = String(footerString.dropFirst(footerSettings.prefix.count))
		
		if footerString.isEmpty && footerSettings.enabled {
			print(error: "Footer is enabled but empty.")
			return false
		}
		else if !footerString.isEmpty && !footerSettings.enabled {
			print(error: "Footer is disabled but not empty.")
			return false
		}
		
		if let min = footerSettings.length.min, min.value > footerString.count {
			print(error: min.message)
			return false
		}
		else if let max = footerSettings.length.max, max.value < footerString.count {
			print(error: max.message)
			return false
		}
		
		return true
	}
	
	private func validate(config: CommitConfig, parts: [String.SubSequence]) -> Bool {
		var commitParts = parts.map { String($0) }
		guard validateHeader(header: config.header, subject: String(parts.first!)) else { return false }
		commitParts.removeFirst()
		var body: String = ""
		var footer: String  = ""
		commitParts.forEach { part in
			if !part.hasPrefix(config.footer.prefix) {
				body += part
				body += "\n"
			}
			else {
				footer += part
			}
		}
		guard validateBody(bodySettings: config.body, body: body),
			  validateFooter(footerSettings: config.footer, footer: footer)
		else {
			return false
		}
		
		return true
	}
	
	private func processCommitParts(parts: [String.SubSequence]) {
		guard let configCommand = run.command(class: CheckConfigCommand.self) else {
			print(error: "Could not find command in charge of config validation")
			return
		}
		
		switch configCommand.config() {
		case let .success(config):
			guard validate(config: config, parts: parts) else {
				exit(1)
			}
			delegate?.validationSuccessful(message: parts.joined(separator: "\n"))
		case let .failure(error):
			print(error: error)
			exit(1)
		}
	}
	
	func perform(arguments: [String]) {
//		let isSilent = arguments.contains("--silent")
		var parts = arguments.first?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "|")
		if let commitParts = parts, commitParts.count > 1 {
			processCommitParts(parts: commitParts)
		}
		else {
			parts = arguments.first?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
			if let commitParts = parts, commitParts.count > 1 {
				processCommitParts(parts: commitParts)
			}
			else {
				print(error(errorMessage: "Commit message does not exist"))
				exit(1)
			}
		}
	}
}
