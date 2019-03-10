//
//  CheckConfigCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class CheckConfigCommand: CommandProtocol {
	var name: String = "check-config"
	
	var description: String = """
Check your config file.
Add argument for checking by path.
"""
	
	func config(path: String = Constants.config) -> Result<CommitConfig, Error> {
		guard FileManager.default.fileExists(atPath: path) else {
			return Result.failure(error(errorMessage: "File \(path) does not exist."))
		}
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path))
			let decoder = JSONDecoder()
			let res = try decoder.decode(CommitConfig.self, from: data)
			return Result.success(res)
		}
		catch {
			return Result.failure(error)
		}
	}
	
	func perform(arguments: [String]) {
		let path = arguments.first ?? Constants.config
		switch self.config(path: path) {
		case .success(_):
			print("Your configuration is \("OK".color(.green))\("".color(.default)).")
		case let .failure(error):
			print(error: error)
		}
	}
}
