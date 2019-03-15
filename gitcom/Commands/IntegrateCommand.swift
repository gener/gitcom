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
Integrate utility to your system:
`hook` Add hook to current repository for checking commit messages.
`git` Add command `gitcom` to run this utility and creates git command `git cm` for creating beautiful commit.
`all` Full integrate gitcmt in your system.
"""

	private func addUtility() {
		let executableURLinBin = URL(fileURLWithPath: Constants.binPath + Constants.executableNamePath)
		let currentDirPath = FileManager.default.currentDirectoryPath
		let executableURL = URL(fileURLWithPath: currentDirPath + Constants.executableNamePath)
		do {
			if FileManager.default.fileExists(atPath: executableURLinBin.path) {
				try FileManager.default.removeItem(at: executableURLinBin)
			}
			try FileManager.default.copyItem(at: executableURL, to: executableURLinBin)
			print("\("Utility integration.".color(.blue))\("".color(.default))")
			createGitCommand()
		}
		catch let error {
			print(error: error.localizedDescription)
		}
		print("\("Use `git cm` for making commit.".color(.blue))\("".color(.default))")
	}

	private func createGitCommand() {
		let gitPath = Constants.binPath + Constants.gitCommandNamePath
		do {
			if FileManager.default.fileExists(atPath: gitPath) {
				try FileManager.default.removeItem(atPath: gitPath)
			}
			FileManager.default.createFile(atPath: gitPath,
										   contents: Constants.gitCommandContent.data(using: .utf8, allowLossyConversion: false),
										   attributes: nil
			)
			try setRunPermission(path: gitPath)
		}
		catch let error {
			print(error: error.localizedDescription)
		}
		print("\("Git command integration.".color(.blue))\("".color(.default))")
	}
	
	private func addCommitHookToGit() {
		guard GitProcess().exists else {
			print(error: "git not found in current directory. Run hook initialization in git project")
			return
		}
		
		let hookFilePath = FileManager.default.currentDirectoryPath + Constants.gitHookPath + Constants.gitCommitMsgHookFileName

		func success() {
			print("\("Integration completed successfully.".color(.green))\("".color(.default))")
		}

		do {
			if !FileManager.default.fileExists(atPath: hookFilePath) {
				FileManager.default.createFile(atPath: hookFilePath,
														 contents: hookFilePath.data(using: .utf8, allowLossyConversion: false),
														 attributes: nil
				)
			}
			let fileContent = try String(contentsOfFile: hookFilePath)
			guard !fileContent.contains(Constants.commitMessageHook) else {
				success()
				return
			}
			guard let data = Constants.commitMessageHook.data(using: .utf8, allowLossyConversion: false) else { return }
			if let fileHandle = FileHandle(forWritingAtPath: hookFilePath) {
				fileHandle.seekToEndOfFile()
				fileHandle.write(data)
				fileHandle.closeFile()
				try setRunPermission(path: hookFilePath)
				success()
			}
			else {
				print(error: "Can't open file \(hookFilePath)")
			}
		}
		catch let error {
			print(error: error.localizedDescription)
		}
	}
	
	func setRunPermission(path: String) throws {
		try FileManager.default.setAttributes([FileAttributeKey.posixPermissions : 0o755], ofItemAtPath: path)
	}
	
	func perform(arguments: [String]) {
		if arguments.contains("all") || arguments.contains("git") {
			addUtility()
		}
		if arguments.contains("all") || arguments.contains("hook") {
			addCommitHookToGit()
		}
		if arguments.count == 0 {
			print(error: "Please choose one option")
		}
	}

}
