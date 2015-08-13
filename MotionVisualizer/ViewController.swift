//
//  ViewController.swift
//  MotionVisualizer
//
//  Created by Mateus Reckziegel on 8/6/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import Cocoa
import OpenGL

class ViewController: NSViewController {

    let connectionManager = ConnectionManager()
    
    var graphicLayer = CALayer()
    
    @IBOutlet weak var viewGraphic: CustomView!
    @IBOutlet weak var txfData: NSTextField!
    @IBOutlet weak var txfInfo: NSTextField!
    @IBOutlet weak var txfPeer: NSTextField!
    @IBOutlet weak var txfStatus: NSTextField!
    var dataLineCount = 0
    var infoLineCount = 0
    var gValues:NSArray?
    
    var time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.connectionManager.delegate = self
        
        self.graphicLayer.delegate = self
        self.graphicLayer.frame = self.viewGraphic.frame
//        self.graphicLayer.backgroundColor = NSColor.redColor().CGColor

    }

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }

    func writeData(str:String) {
//        if self.dataLineCount >= 6 {
//            self.dataLineCount = 0
//            self.txfData.stringValue = ""
//        }
//        self.txfData.stringValue += str + "\n"
//        self.dataLineCount++
        self.txfData.stringValue = str
    }
    
    func writeInfo(message:String){
        if self.infoLineCount >= 25 {
            self.infoLineCount = 0
            self.txfInfo.stringValue = ""
        }
        self.txfInfo.stringValue += message + "\n"
        self.infoLineCount++
    }

    @IBAction func didPressBrowserButton(sender: NSButton) {
        if self.connectionManager.isActive() {
            sender.title = "Search for Nearby Devices"
            self.connectionManager.stopBrowsingForNearbyDevices()
        } else {
            sender.title = "Stop"
            self.txfPeer.stringValue = "No peer"
            self.txfStatus.stringValue = "Status: Not Connected"
            self.connectionManager.startBrowsingForNearbyDevices()
        }
    }
    
}

extension ViewController : ConnectionManagerDelegate {
    
    func didConnectToDevice(manager: ConnectionManager, connectedDevice: String?) {
        self.txfPeer.stringValue = manager.connectedDevice!
    }
    
    func didReceiveData(manager: ConnectionManager, data: NSData!) {
        var out = [Float(), Float(), Float(), Float()]
        data.getBytes(&out, length: data.length)
//        println(out)
        self.writeData("\(out)")
        self.gValues = out
    }
    
    func didDisconnect(manager: ConnectionManager) {
        self.writeInfo("Disconnected")
        self.txfPeer.stringValue = "No peer"
    }
    
    func statusMessage(manager: ConnectionManager, message: String) {
        self.writeInfo(message)
    }
    
    func sessionState(manager:ConnectionManager, state:String) {
        self.txfStatus.stringValue = "Status: " + state
    }

}
















