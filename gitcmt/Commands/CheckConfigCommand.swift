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
	
	func perform(arguments: [String]) {
		let path = arguments.first ?? Constants.config
		guard FileManager.default.fileExists(atPath: path) else {
			print("File \(path.color(.blue))\("".color(.default)) does not exist.")
			return
		}
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: path))
			let decoder = JSONDecoder()
			_ = try decoder.decode(CommitConfig.self, from: data)
			print("Your configuration is \("OK".color(.green))\("".color(.default)).")
		}
		catch {
			print("File \(path.color(.blue))\("".color(.default))\(error.localizedDescription)")
		}
	}
}
