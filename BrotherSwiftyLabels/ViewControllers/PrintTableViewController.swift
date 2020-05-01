//
//  PrintTableViewController.swift
//  BrotherSwiftyLabels
//
//  Created by Joe Mestrovich on 4/26/20.
//  Copyright © 2020 Mizmovac. All rights reserved.
//

import UIKit

class PrintTableViewController: UITableViewController {
	private var selectedPrinter: BRPtouchDeviceInfo?

	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(setPrinter(notification:)), name: Notification.Name("SetPrinter"), object: nil)
	}

	@objc func setPrinter(notification: Notification) {
		guard
			let notifiction = notification.userInfo as? [String: BRPtouchDeviceInfo],
			let selectedPrinter = notifiction["selectedPrinter"]
		else { return }
		
		self.selectedPrinter = selectedPrinter
	}
	
	// MARK: - Print samples
	
	// Important: Check the BRLMQLPrintSettings initial settings
	// value. These samples are set for a QL-820NWB.
	
	// Also important: Verify you have the correct .labelSize enum
	// selected. All dimensions are in millimeters.
	
	// You will notice that the printing examples below are not
	// refactored to be efficient. This is by design so that
	// debugging is easier when experimenting. Note the lack of error
	// handling and imagine how frustrated a user would become if
	// this was a production app.
	
	@IBAction func printPDFSample(_ sender: UIButton) {
		guard let selectedPrinter = selectedPrinter else { return }
		
		let channel = BRLMChannel(wifiIPAddress: selectedPrinter.strIPAddress)
		let openChannelResult = BRLMPrinterDriverGenerator.open(channel)

		guard openChannelResult.error.code == BRLMOpenChannelErrorCode.noError,
			let printerDriver = openChannelResult.driver else {
				print("Channel Error: \(openChannelResult.error.code.rawValue)")
				return
		}
		
		let pdfURL = Bundle.main.url(forResource: "PDFSample", withExtension: "pdf")
		let printerSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
		printerSettings?.labelSize = .rollW54
		printerSettings?.autoCut = true
		
		let error = printerDriver.printPDF(with: pdfURL!, settings: printerSettings!)
		print("PDFSample print - result code: \(error.code.rawValue)")
		
		printerDriver.closeChannel()
	}
	
	@IBAction func printRedBlackSample(_ sender: UIButton) {
		guard let selectedPrinter = selectedPrinter else { return }
		
		let channel = BRLMChannel(wifiIPAddress: selectedPrinter.strIPAddress)
		let openChannelResult = BRLMPrinterDriverGenerator.open(channel)

		guard openChannelResult.error.code == BRLMOpenChannelErrorCode.noError,
			let printerDriver = openChannelResult.driver else {
				print("Channel Error: \(openChannelResult.error.code.rawValue)")
				return
		}
		
		let redBlackURL = Bundle.main.path(forResource: "RedBlackImageSample", ofType: "png")
		let printerSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
		printerSettings?.labelSize = .rollW62RB
		printerSettings?.twoColorPrint = true
		printerSettings?.autoCut = true
		
		let pngImage = UIImage(contentsOfFile: redBlackURL!)
		let error = printerDriver.printImage(with: pngImage!.cgImage!, settings: printerSettings!)
		print("RedBlackImageSample print - result code: \(error.code.rawValue)")
		
		printerDriver.closeChannel()
	}
	
	// Special note: Running this method from a simulator may
	// crash, but it seems to run fine on an actual device. Some
	// developers report success at avoiding the crash by
	// modifying the debug run-time scheme so that METAL API
	// Validation is disabled. To try yourself:
	// - From the Product menu, select Scheme
	// - Select Edit Scheme...
	// - Click on Run (Debug) in the left-hand navigation pane
	// - Select the Options right-hand settings panel
	// - Change the METAL API Validation to Disabled
	// - Press the Close button and try a run in the Simulator.
	//   If it still crashes then build this is on your device
	//   and it should work.
	@IBAction func printDitheredSample(_ sender: UIButton) {
		guard let selectedPrinter = selectedPrinter else { return }
		
		let channel = BRLMChannel(wifiIPAddress: selectedPrinter.strIPAddress)
		let openChannelResult = BRLMPrinterDriverGenerator.open(channel)

		guard openChannelResult.error.code == BRLMOpenChannelErrorCode.noError,
			let printerDriver = openChannelResult.driver else {
				print("Channel Error: \(openChannelResult.error.code.rawValue)")
				return
		}
		
		let kittenURL = Bundle.main.path(forResource: "BengalSample", ofType: "png")
		let printerSettings = BRLMQLPrintSettings(defaultPrintSettingsWith: .QL_820NWB)
		printerSettings?.labelSize = .rollW62
		printerSettings?.autoCut = true
		
		let kittenImage = UIImage(contentsOfFile: kittenURL!)
		let context = CIContext(options: nil)
		
		if let ditherFilter = CIFilter(name: "CIDither") {
			let initialImage = CIImage(image: kittenImage!)
			ditherFilter.setValue(initialImage, forKey: kCIInputImageKey)
			
			// Lower the Intensity value below to reduce the
			// density of dots in your image
			ditherFilter.setValue(2.5, forKey: kCIInputIntensityKey)
			
			if let finalImage = ditherFilter.outputImage {
				if let cgImage = context.createCGImage(finalImage, from: finalImage.extent) {
					let error = printerDriver.printImage(with: cgImage, settings: printerSettings!)
					print("Dithered print - result code: \(error.code.rawValue)")
				}
			}
		}
		
		printerDriver.closeChannel()
	}
	
}
