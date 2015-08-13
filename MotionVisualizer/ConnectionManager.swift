//
//  ConnectionManager.swift
//  MotionVisualizer
//
//  Created by Mateus Reckziegel on 8/12/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    
    func didConnectToDevice(manager:ConnectionManager, connectedDevice:String?)
    func didReceiveData(manager:ConnectionManager, data:NSData!)
    func didDisconnect(manager:ConnectionManager)
    func statusMessage(manager:ConnectionManager, message:String)
    func sessionState(manager:ConnectionManager, state:String)
    
}

class ConnectionManager: NSObject {
   
    private let serviceType = "motion-app"
    private let myPeerID = MCPeerID(displayName: NSHost.currentHost().localizedName)
    private let browser:MCNearbyServiceBrowser
    var connectedDevice:String?
    var delegate:ConnectionManagerDelegate?
    private var active = false
    
    lazy var session:MCSession = {
       let session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
        session?.delegate = self
        return session
    }()
    
    override init() {
    
        self.browser = MCNearbyServiceBrowser(peer: self.myPeerID, serviceType: self.serviceType)
        super.init()        
        self.browser.delegate = self

    }
    
    func startBrowsingForNearbyDevices() {
        self.active = true
        self.delegate?.statusMessage(self, message: "Started Browser")
        self.browser.startBrowsingForPeers()
    }
    
    func stopBrowsingForNearbyDevices() {
        self.active = false
        self.delegate?.statusMessage(self, message: "Stopped Browser")
        self.browser.stopBrowsingForPeers()
    }
    
    func isActive() -> Bool {
        return self.active
    }
    
}

extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .NotConnected: return "Not Connected"
        case .Connecting: return "Connecting"
        case .Connected: return "Connected"
        default: return "Unknown"
        }
    }
    
}

extension ConnectionManager : MCSessionDelegate {
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println(state.stringValue())
        self.delegate?.sessionState(self, state:state.stringValue())
        
        switch(state) {
        case .Connected:
            self.connectedDevice = session.connectedPeers.map({$0.displayName})[0] as String
            self.delegate?.didConnectToDevice(self, connectedDevice: self.connectedDevice!)
        case .NotConnected:
            self.connectedDevice = nil
            self.delegate?.didDisconnect(self)
        default:
            print("")
        }
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
//        self.delegate?.statusMessage(self, message: "Data received")
        self.delegate?.didReceiveData(self, data: data)
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
//        self.delegate?.statusMessage(self, message: "Did Receive Certificate (???)")
        certificateHandler(true)
    }
    
}

extension ConnectionManager : MCNearbyServiceBrowserDelegate {
    
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        self.delegate?.statusMessage(self, message: "didNotStartBrowsingForPeers :(")
        println("Did Not Start Browsing For Peers :(")
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        self.delegate?.statusMessage(self, message: "Found peer \(peerID)")
        println("Found peer \(peerID)")
        self.delegate?.statusMessage(self, message: "Inviting...")
        self.browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 10)
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        self.delegate?.statusMessage(self, message: "Lost peer \(peerID)")
        println("Lost peer \(peerID)")
    }
    
}











