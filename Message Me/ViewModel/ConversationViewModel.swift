//
//  ConversationViewModel.swift
//  Message Me
//
//  Created by Apple on 30.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var creation: String {
        let seconds = conversation.message.creationDate!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: seconds)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
