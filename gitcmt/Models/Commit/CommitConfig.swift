//
//  Commit.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct CommitConfig: Codable {
	var header: Header = Header()
	var body: Body = Body()
	var footer: Footer = Footer()
}
