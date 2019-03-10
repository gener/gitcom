//
//  Header.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct Header: Codable {
	struct HType: Codable {
		var request: String = "Please, choose you type of commit:"
		var items: [TypeItem] = [
			TypeItem(key: "build", value: "Modifications related by configuration or building rules of project"),
			TypeItem(key: "ci", value: "Changes for continuous integration"),
			TypeItem(key: "doc", value: "Some documentation changes"),
			TypeItem(key: "feat", value: "Making some feature"),
			TypeItem(key: "fix", value: "Bugfixing"),
			TypeItem(key: "perf", value: "Perfomance improvement")
		]
	}
	
	struct Scope: Codable {
		var enabled: Bool = true
		var skip: Bool = false
		var skiptRequest: String = "Do not add scope."
		var request: String = "Please, choose you scope of code:"
		var items: [ScopeItem] = [
			ScopeItem(key: "core", value: "Part of code in core ypu application", types: nil),
			ScopeItem(key: "styles", value: "Code related by styles or markup of project", types: nil),
			ScopeItem(key: "unit_tests", value: "Creation or modification unit tests", types: nil),
			ScopeItem(key: "ui_test", value: "Creation or modification test of interfaces", types: nil),
			///
			ScopeItem(key: "stylefix", value: "Markup fixing", types: ["fix"]),
			ScopeItem(key: "featfix", value: "Feature fixing", types: ["fix"]),
			ScopeItem(key: "tempfix", value: "Temporary fix", types: ["fix"])
		]
	}
	
	struct CustomScope: Codable {
		var enabled: Bool = true
		var request: String = "Please, enter your custom scope (or enter `<` to return to list of scopes):"
		var back: String = "<"
		var lenght: Lenght = Lenght(min: Lenght.Val.min(2), max: Lenght.Val.max(5))
	}
	
	var type: HType = HType()
	var request: String = "Please enter a header of commit"
	var lenght: Lenght = Lenght(min: Lenght.Val.min, max:  Lenght.Val.max)
	var scope: Scope = Scope()
	var customScope = CustomScope()
}
