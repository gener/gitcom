//
//  ValidateCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class ValidateCommand: CommandProtocol {
	var name: String = "validate"
	
	var description: String = """
Validate message for commit.
Add message as parameter.
"""

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
		let pattern = "(?:build:\\s)(?:\\(([^\\)]+)\\))"
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
			if let min = header.customScope.lenght.min, min.value > sScope.count {
				return Result.failure("Scope `\(sScope)` has small lenght.")
			}
			if let max = header.customScope.lenght.max, max.value < sScope.count {
				return Result.failure("Scope `\(sScope)` has big lenght.")
			}
		}
		else if !isAvaliableScope && !header.customScope.enabled {
			return Result.failure("Custom scope `\(sScope)` is not avaliable.")
		}
	
		return Result.success(sScope)
	}
	
	private func validate(header: Header, subject: String) -> Bool {
		switch checkType(header: header, subject: subject) {
		case let .success(type):
			switch checkScope(header: header, subject: subject, type: type) {
			case .success(_):
				print("1")
			case let .failure(message):
				print(error: message)
			}
		case let .failure(message):
			print(error: message)
			return false
		}
		
		return true
	}
	
	func perform(arguments: [String]) {
//		let isSilent = arguments.contains("--silent")
		guard let parts = arguments.first?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n"), parts.count > 0 else {
			print(error(errorMessage: "Commit message does not exist"))
			exit(1)
		}
		
		guard let configCommand = run.command(class: CheckConfigCommand.self) else {
			print(error: "Could not find command in charge of config validation")
			return
		}
		
		switch configCommand.config() {
		case let .success(config):
			validate(header: config.header, subject: String(parts.first!))
		case let .failure(error):
			print(error: error)
			exit(1)
		}
	}
	
}
