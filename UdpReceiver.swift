//
//  UdpReceiver.swift
//  XRGyroControls
//
//  Created by Keith Ahern on 27/06/2023.
//

import CocoaAsyncSocket
import SimulatorKit

class UdpReceiver: NSObject, GCDAsyncUdpSocketDelegate {
    
    var udpSocket: GCDAsyncUdpSocket?
    var hid_client: SimDeviceLegacyHIDClient
    
    init(hid_client: SimDeviceLegacyHIDClient) {
        self.hid_client = hid_client
        super.init()
        
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try udpSocket?.bind(toPort: 11000)
            try udpSocket?.beginReceiving()
        } catch {
            print("Failed to bind port or start receiving: \(error)")
        }
    }
    
    deinit {
        // Close the socket when this instance is deinitialized
        udpSocket?.close()
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        let message = String(data: data, encoding: .utf8)
        
        if let message = message {
            let components = message.components(separatedBy: ";")
            
            let positionString = components[0].replacingOccurrences(of: "Position:", with: "")
            let rotationString = components[1].replacingOccurrences(of: "Rotation:", with: "")
            
            let positionComponents = positionString.components(separatedBy: ",")
            let rotationComponents = rotationString.components(separatedBy: ",")
            
            if positionComponents.count == 3, rotationComponents.count == 4 {
                let position = (Float(positionComponents[0]), Float(positionComponents[1]), Float(positionComponents[2]))
                let rotation = (Float(rotationComponents[0]), Float(rotationComponents[1]), Float(rotationComponents[2]), Float(rotationComponents[3]))
                
                print("Received position: \(position) and rotation: \(rotation)")
                
                hid_client.send(message: IndigoHIDMessage.camera(x: Float(positionComponents[0])!,
                                                                 y: Float(positionComponents[1])!,
                                                                 z: Float(positionComponents[2])!,
                                                                 rot_x: Float(rotationComponents[0])!,
                                                                 rot_y: Float(rotationComponents[1])!,
                                                                 rot_z: Float(rotationComponents[2])!,
                                                                 rot_w: Float(rotationComponents[3])!).as_struct())
                
                
            }
        }
    }
}
