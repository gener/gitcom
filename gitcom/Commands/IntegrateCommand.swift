//
//  IntegrateCommand.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class IntegrateCommand: CommandProtocol {
	var name: String = "integrate"
	
	var description: String = """
Add hook to current repository for checking commit messages
Add command to your system for creating beautiful commit (`gitcom`)
"""
	
	var commitMessageHook: String = """
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
message=`cat $1`
messageWithNewLines=${message//|/"\\n"}
gitcom validate "$message"
"""
	
	private func copyExecutableToBinFolder() {
		let executableURLinBin = URL(fileURLWithPath: "/usr/local/bin" + Constants.executableNamePath)
		let currentDirPath = FileManager.default.currentDirectoryPath
		let executableURL = URL(fileURLWithPath: currentDirPath + Constants.executableNamePath)
		do {
			if FileManager.default.fileExists(atPath: executableURLinBin.path) {
				try FileManager.default.removeItem(at: executableURLinBin)
			}
			try FileManager.default.copyItem(at: executableURL, to: executableURLinBin)
		}
		catch let error {
			print(error: error.localizedDescription)
			exit(1)
		}
	}
	
	private func changeCommitMessageFile() {
		let commitMessageSampleFilePath = FileManager.default.currentDirectoryPath + "/.git/hooks/" + Constants.gitCommitMsgHookSampleFileName
		let commitMessageHookFilePath = FileManager.default.currentDirectoryPath + "/.git/hooks/" + Constants.gitCommitMsgHookFileName
		do {
			if FileManager.default.fileExists(atPath: commitMessageHookFilePath) {
				print(error: "\(Constants.gitCommitMsgHookFileName) already exists.")
				exit(1)
			}
			try FileManager.default.moveItem(atPath: commitMessageSampleFilePath, toPath: commitMessageHookFilePath)
			appendValidationHook(sampleFilePath: commitMessageSampleFilePath, hookFilePath: commitMessageHookFilePath)
		}
		catch let error {
			print(error: error.localizedDescription)
			exit(1)
		}
	}
	
	private func appendValidationHook(sampleFilePath: String, hookFilePath: String) {
		guard let data = commitMessageHook.data(using: .utf8, allowLossyConversion: false) else { return }
		
		if FileManager.default.fileExists(atPath: hookFilePath) {
			if let fileHandle = FileHandle(forWritingAtPath: hookFilePath) {
				fileHandle.seekToEndOfFile()
				fileHandle.write(data)
				fileHandle.closeFile()
				print("\("Integration completed successfully.".color(.green))\("".color(.default))")
			}
			else {
				print(error: "Can't open file \(hookFilePath)")
			}
		}
	}
	
	func perform(arguments: [String]) {
		copyExecutableToBinFolder()
		changeCommitMessageFile()
	}

}
