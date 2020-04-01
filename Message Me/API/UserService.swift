//
//  UserService.swift
//  Message Me
//
//  Created by Apple on 29.03.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            if let i = users.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid }) {
                users.remove(at: i)
            }
            completion(users)
        }
    }
    
    static func uploadMessage(_ message: String, to user: User,completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let uid = user.uid else { return }
        
        let values = ["text": message,
                      "toId": uid,
                      "fromId": currentUid,
                      "creationDate": Int(NSDate().timeIntervalSince1970)] as [String: Any]
        
        let messageRef = REF_MESSAGES.childByAutoId()
        guard let messageKey = messageRef.key else { return }
        
        messageRef.updateChildValues(values) { (err, ref) in
            REF_USER_MESSAGES.child(currentUid).child(user.uid).updateChildValues([messageKey: 1])
            REF_USER_MESSAGES.child(user.uid).child(currentUid).updateChildValues([messageKey: 1])
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) ->  Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = user.uid else { return }
        
        REF_USER_MESSAGES.child(currentUid).child(chatPartnerId).observe(.childAdded) { (snapshot) in
            print(snapshot)
            let messageId = snapshot.key
            REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                
                let message = Message(dictionary: dictionary)
                messages.append(message)
                completion(messages)
            }
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var messages = [Message]()
        var conversations = [Conversation]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        messages.removeAll()
        conversations.removeAll()
        
        REF_USER_MESSAGES.child(currentUid).observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            REF_USER_MESSAGES.child(currentUid).child(uid).observe(.childAdded) { (snapshot) in
                let messageId = snapshot.key
                REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                    
                    let message = Message(dictionary: dictionary)
                    self.fetchUser(withUid: message.chatPartnerId) { (user) in
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                    }
                }
            }
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "email": user.email]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
}
