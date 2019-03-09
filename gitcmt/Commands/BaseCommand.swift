//
//  BaseCommand.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

protocol CommandProtocol {
	var name: String { get }
	var description: String { get }
	func perform(arguments: [String])
}
