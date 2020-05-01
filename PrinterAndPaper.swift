//
//  PrinterAndPaper.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/28/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import Foundation

struct Printer: Codable {
	let model: String
	let paperSize: [Paper]
}

struct Paper: Codable {
	let paper: String
}

