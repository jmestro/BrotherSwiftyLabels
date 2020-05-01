//
//  SecondViewController.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/26/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import UIKit

class PrintTableViewController: UITableViewController {
	private var selectedPrinter: BRPtouchDeviceInfo?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(setPrinter(notification:)), name: Notification.Name("SetPrinter"), object: nil)
		
		//		let channel = BRLMChannel(wifiIPAddress: "10.0.1.66")
		//		let openChannelResult = BRLMPrinterDriverGenerator.open(channel)
		//
		//		guard openChannelResult.error.code == BRLMOpenChannelErrorCode.noError,
		//			let printerDriver = openChannelResult.driver else {
		//				print("Channel Error: \(openChannelResult.error.code.rawValue)")
		//				return
		//		}
				
		//		let testStarURL = Bundle.main.url(forResource: "TestStar", withExtension: "pdf")
		//		var printerSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
		//		printerSettings?.labelSize = .rollW62
				
				
				//let error = printerDriver.printPDF(with: testStarURL!, settings: printerSettings!)
				
		//		printerDriver.closeChannel()
	}

	@objc func setPrinter(notification: Notification) {
		guard
			let notifiction = notification.userInfo as? [String: BRPtouchDeviceInfo],
			let selectedPrinter = notifiction["selectedPrinter"]
		else { return }
		
		self.selectedPrinter = selectedPrinter
	}

}
