//
//  TemplateViewController.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/27/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import UIKit

// Not working yet

class TemplateViewController: UIViewController {
	private var selectedPrinter: BRPtouchDeviceInfo?
	
	@IBOutlet var firstNamesTextView: UITextView!
	
	private let importantQRCode = [
		"https://www.youtube.com/watch?v=dQw4w9WgXcQ",
		"https://www.youtube.com/watch?v=J---aiyznGQ",
		"https://www.youtube.com/watch?v=RUaYbfKZIiA"
	]

    override func viewDidLoad() {
        super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(setPrinter(notification:)), name: Notification.Name("SetPrinter"), object: nil)
    }
	
	@IBAction func printBatchLabels(_ sender: UIButton) {
		
	}

	@objc func setPrinter(notification: Notification) {
		guard
			let notifiction = notification.userInfo as? [String: BRPtouchDeviceInfo],
			let selectedPrinter = notifiction["selectedPrinter"]
		else { return }
		
		self.selectedPrinter = selectedPrinter
	}
	
}
