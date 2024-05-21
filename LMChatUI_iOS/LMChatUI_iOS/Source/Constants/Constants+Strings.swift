//
//  Constants+Strings.swift
//  LMFramework
//
//  Created by Devansh Mohata on 07/12/23.
//

import Foundation

public extension Constants {
    struct Strings {
        private init() { }
        
        // Shared Instance
        public static let shared = Strings()
        
        public let edit = "Edit"
        public let copy = "Copy"
        public let select = "Select"
        public let setTopic = "Set as current topic"
        public let reportMessage = "Report message"
        public let delete = "Delete"
        public let reply = "Reply"
        public let dot = "•"
        public let restrictForAnnouncement = "Only community managers can respond here."
        public let restrictByManager = "Restricted to respond in this chatroom by community manager."
        public let warningMessageForDeletion = "Are you sure you want to delete this message? This action can not be reversed."
    }
}
