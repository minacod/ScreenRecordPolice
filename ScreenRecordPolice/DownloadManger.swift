//
//  DownloadManger.swift
//  ScreenRecordPolice
//
//  Created by Mina Abdelfady on 7/20/20.
//  Copyright © 2020 Shafy. All rights reserved.
//

import Foundation

class DownloadManger : NSObject, URLSessionDelegate , URLSessionDownloadDelegate{
    
    static var shared = DownloadManger()
        
    var backgroundCompletionHandler : (() -> Void)?
    
    lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            debugPrint("Progress \(downloadTask) \(progress)")
        }
    }
    

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download finished: \(location)")
        do {
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            let savedURL = documentsURL.appendingPathComponent("1.mp4")
            try FileManager.default.moveItem(at: location, to: savedURL)
            }
        catch {
            print ("file error: \(error)")
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("Task completed: \(task), error: \(error)")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
         DispatchQueue.main.async {
             guard let backgroundCompletionHandler =
                self.backgroundCompletionHandler else {
                     return
             }
             backgroundCompletionHandler()
         }
     }
    
    func calculateProgress( completionHandler : @escaping (Float) -> ()) {
        urlSession.getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            let bytesReceived = downloads.map{ $0.countOfBytesReceived }.reduce(0, +)
            let bytesExpectedToReceive = downloads.map{ $0.countOfBytesExpectedToReceive }.reduce(0, +)
            let progress = bytesExpectedToReceive > 0 ? Float(bytesReceived) / Float(bytesExpectedToReceive) : 0.0
            debugPrint("Total Progress \(progress)")
            completionHandler(progress)
        }
    }
     
}
