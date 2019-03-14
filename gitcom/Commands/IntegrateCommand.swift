//
//  IntegrateCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class IntegrateCommand: CommandProtocol {
	var name: String = "integrate"
	
	var description: String = """
Add hook to current repository for checking commit messages
Add command to your system for creating beautiful commit (`git cmt`)
"""
	func perform(arguments: [String]) {
		print(error: "NOT READY")
	}

}
