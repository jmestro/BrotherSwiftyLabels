//
//  WiFiPrintersTableViewController.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/27/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import UIKit

class WiFiPrintersTableViewController: UITableViewController {
	private let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
	
	private var networkManager: BRPtouchNetworkManager?
	
	// An array of all the printers found by the NetworkManager
	private var printers = [BRPtouchDeviceInfo]()
	
	// This contains the specific printer selected by the user.
	// Each form in this app sets a version of this property via
	// a Notification.
	private var selectedPrinter: BRPtouchDeviceInfo?

	// MARK: - Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Hide and disable the ability to exit this screen during
		// a device search. Normally you should give your users an
		// option to exit during a search, but be mindful that the
		// running service will want to delegate the didfinishSearch
		// method and will crash your app if the delegate is not
		// available.
		if let tabBarButtons = tabBarController?.tabBar.items {
			tabBarButtons.forEach { $0.isEnabled = false }
		}
		navigationItem.hidesBackButton = true
		
//		activityIndicator.style = .large
		activityIndicator.center = self.view.center
		self.view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		
		let manager = BRPtouchNetworkManager()
		manager.delegate = self
		manager.isEnableIPv6Search = false
		
		// You must specify an array of printer names as strings for the
		// printers you want your app to support. The helper method below
		// returns all of the printers found in PrinterList.plist 
		manager.setPrinterNames(allBrotherPrinters())
		
		// Search time is in seconds. The official Brother demo app sets
		// this at 5 seconds, but it seems to work in as little as one
		// second for a simple network with few devices.
		manager.startSearch(5)
		self.networkManager = manager
		
//		let bl = BRPtouchBluetoothManager.shared()?.pairedDevices()
//		print(bl)
    }

    // MARK: - Table view support

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return printers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrinterCell", for: indexPath)
		cell.textLabel?.text = printers[indexPath.row].strModelName
		cell.detailTextLabel?.text = printers[indexPath.row].strIPAddress

        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		NotificationCenter.default.post(name: Notification.Name("SetPrinter"), object: nil, userInfo: ["selectedPrinter": printers[indexPath.row]])
		navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Brother printers list helper
	
	fileprivate func allBrotherPrinters() -> [String] {
		guard let printNamesURL = Bundle.main.url(forResource: "PrinterList", withExtension: "plist")
			else { fatalError("PrinterList.plist missing in bundle") }
		
		let printersDict = NSDictionary.init(contentsOf: printNamesURL)!
		let printersArray = printersDict.allKeys as! [String]
		
		return printersArray
	}

}

// MARK: - Delegate for the Brother network printer search

extension WiFiPrintersTableViewController: BRPtouchNetworkDelegate {
	
	// You must implement this delegated method to receive an array
	// of found devices. Note that getPrinterNetInfo() returns an
	// array of type Any; cast devices to BRPtouchDeviceInfo elements
	// to expose all of the handy properties you will need later.
	
	func didFinishSearch(_ sender: Any!) {
		guard
			let manager = sender as? BRPtouchNetworkManager,
			let devices = manager.getPrinterNetInfo()
		else { return }
		
		for deviceInfo in devices {
			guard let deviceInfo = deviceInfo as? BRPtouchDeviceInfo else { continue }
			
			printers.append(deviceInfo)
		}
		
		tableView.reloadData()
		
		if let tabBarButtons = tabBarController?.tabBar.items {
			tabBarButtons.forEach { $0.isEnabled = true }
		}
		navigationItem.hidesBackButton = false
		
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
	}
}
