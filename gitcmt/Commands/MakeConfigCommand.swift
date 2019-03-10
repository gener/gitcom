//
//  MakeConfigCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class MakeConfigCommand: CommandProtocol {
	var name: String = "make-config"
	
	var description: String = """
Generate default config file.
Add argument to save config file by path.
"""
	
	func perform(arguments: [String]) {
		let path = arguments.first ?? Constants.config
		if FileManager.default.fileExists(atPath: path) {
			print("\(path.color(.blue))\("".color(.default)) already exists. Do you want replace this file? (y/n)")
			let val = readLine()
			if val?.lowercased() == "y" {
				generateFile(path: path)
			}
		}
		else {
			generateFile(path: path)
		}
	}
	
	private func generateFile(path: String) {
		let model = CommitConfig()
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		do {
			let data = try encoder.encode(model)
			try data.write(to: URL(fileURLWithPath: path))
			print("\(path.color(.blue)) \("".color(.default))successfully generated.")
		}
		catch {
			print(error: error)
		}
	}
}
