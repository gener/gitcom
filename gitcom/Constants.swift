//
//  Constants.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

class Constants {
	static let config = "config.json"
	static let skipScopeIndex = "-"
	static let skipScopeKey = "//skip"
	static let customScopeKey = "custom"
	static let customScopeIndex = "0"
	static let messageArgument = "-m"
	static let gitCommitMsgHookFileName = "commit-msg"
	static let executableNamePath = "/gitcom"
	static let gitCommandNamePath = "/git-cm"
	static let binPath = "/usr/local/bin"
	static let gitHookPath = "/.git/hooks/"
	static let gitCommandContent = """
#!/bin/sh
gitcom make
"""
	
	static let commitMessageHookHeader = """
#!/bin/sh
"""
	
	static let commitMessageHook = """

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
message=`cat $1`
messageWithNewLine=${message//|/"\\n"}
echo "$messageWithNewLine" > "$1"
gitcom validate "$message"
"""
}
