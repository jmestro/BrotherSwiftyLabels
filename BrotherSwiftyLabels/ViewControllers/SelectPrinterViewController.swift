//
//  SelectPrinterViewController.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/26/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import UIKit

class SelectPrinterViewController: UIViewController {
	
	// Each view controller will get this property set
	// via a Notification
	private var selectedPrinter: BRPtouchDeviceInfo?
	
	@IBOutlet var selectedPrinterModel: UILabel!
	@IBOutlet var selectedPrinterIP: UILabel!
	@IBOutlet var selectedPrinterSerialNumber: UILabel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// This is a hack that "wakes up" the view controllers
		// that are wrapped inside of the tabBarController. It's here
		// to make debugging a bit easier for people that wish to
		// experiment with this app. It is not wise to use this
		// hack in a production product.
		
		if let viewControllers = tabBarController?.viewControllers {
			viewControllers.forEach { vc in
				if let navigationViewController = vc as? UINavigationController,
					let viewController = navigationViewController.viewControllers.first {
					let _ = viewController.view
				}
			}
		}
		
		// End of hack
		
		NotificationCenter.default.addObserver(self, selector: #selector(setPrinter(notification:)), name: Notification.Name("SetPrinter"), object: nil)
	}

	// MARK: - Printer selection
	
	@IBAction func wifiSelectPrinter(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let wifiPrintersViewController = storyboard.instantiateViewController(withIdentifier: "WifiPrinters") as! WiFiPrintersTableViewController
		wifiPrintersViewController.title = "Select a WiFi Printer"
		
		navigationController?.pushViewController(wifiPrintersViewController, animated: true)
	}
	
	@objc func setPrinter(notification: Notification) {
		guard
			let notifiction = notification.userInfo as? [String: BRPtouchDeviceInfo],
			let selectedPrinter = notifiction["selectedPrinter"]
		else { return }
		
		selectedPrinterModel.text = selectedPrinter.strModelName
		selectedPrinterIP.text = "IP: \(selectedPrinter.strIPAddress!)"
		selectedPrinterSerialNumber.text = "Serial #\(selectedPrinter.strSerialNumber!)"
		
		self.selectedPrinter = selectedPrinter
	}
	
}
