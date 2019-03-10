//
//  main.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 09/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class Run {
	var commands: [CommandProtocol] = []
	func perform(arguments: [String]) {
		guard arguments.count > 0, let commandName = arguments.first, let command = commands.first(where: { (row) -> Bool in
			return row.name == commandName
		}) else {
			showHelp()
			return
		}
		var args = arguments
		args.removeFirst()
		command.perform(arguments: args)
	}
	
	private func showHelp() {
		for command in commands {
			var desc = ""
			for (index, key) in command.description.split(separator: "\n").enumerated() {
				desc.append(String(format: index == 0 ? "%s%@\n" : "%-16s%@\n", ("" as NSString).utf8String!, String(key)))
			}
			let str = String(format:"%-22s\("".color(.default)) - %@", (command.name.color(.green) as NSString).utf8String!, desc)
			print(str)
		}
	}
	
	func command<T>(class: T.Type) -> T? {
		return commands.first(where: { command in
			return command is T
		}) as? T
	}
}

let run = Run()
run.commands.append(MakeConfigCommand())
run.commands.append(CheckConfigCommand())
run.commands.append(CommitCommand())
run.commands.append(IntegrateCommand())


var arguments = CommandLine.arguments
arguments.removeFirst()

//arguments.append("check-config")

run.perform(arguments: arguments)

