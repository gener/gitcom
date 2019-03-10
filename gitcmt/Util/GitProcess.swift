//
//  GitProcess.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class GitProcess {
	private let gitURL = URL(fileURLWithPath: "/usr/bin/git")
	
	func run(arguments: [String]) -> Result<String, Error> {
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
	
	var exists: Bool {
		let res = run(arguments: ["rev-parse", "--is-inside-work-tree"])
		switch res {
		case let .success(string):
			return string == "true"
		default:
			return false
		}
	}
	
}
