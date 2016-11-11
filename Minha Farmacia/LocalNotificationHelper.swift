//
//  LocalNotificationHelper.swift
//  Farmácia
//
//  Created by Kleiton Batista on 26/10/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class LocalNotificationHelper: NSObject {
    func checkNotificationEnabled() -> Bool {
        // Check if the user has enabled notifications for this app and return True / False
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return false}
        if settings.types == .None {
            return false
        } else {
            return true
        }
    }
    
    func checkNotificationExists(taskTypeId: String) -> Bool {
        // Loop through the pending notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            // Find the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                return true
            }
        }
        return false
        
    }
    
    func scheduleLocal(taskTypeId: String, alertDate: NSDate, corpoNotificacao:String, medicamentoId:Int, numeroDose:Int) {
        let id = "\(medicamentoId)\(numeroDose)"
        let idUnicoNotificacao = Int(id)
        let notification = UILocalNotification()
        notification.fireDate = alertDate
        notification.alertBody = corpoNotificacao
        notification.alertAction = ""
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["idNotificacao": idUnicoNotificacao!]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        var notifications = [UILocalNotification]()
//        notifications.append(notification)
//        UIApplication.sharedApplication().scheduledLocalNotifications(alertDate)
//        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//                    UIApplication.sharedApplication().scheduledLocalNotifications()

//        print("Notification set for taskTypeID: \(taskTypeId) at \(alertDate)")
    }
    
    func removeNotification(taskTypeId: String) {
        
        // loop through the pending notifications
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            
            // Cancel the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as! String == String(taskTypeId)) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                
                print("Notification deleted for taskTypeID: \(taskTypeId)")
                
                break
            }
        }
    }
    
    func listNotifications() -> [UILocalNotification] {
        var localNotify:[UILocalNotification]?
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            localNotify?.append(notification)
        }
        return localNotify!
    }
    
    func printNotifications() {
        
        print("List of notifications currently set:- ")
        
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] {
            print ("\(notification)")
        }
    }

}
