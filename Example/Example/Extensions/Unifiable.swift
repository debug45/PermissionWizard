//
//  Unifiable.swift
//  Example
//
//  Created by Sergey Moskvin on 10.10.2020.
//

protocol Unifiable {
    
    static func checkStatus(completion: (String?) -> Void)
    
    static func requestAccess(completion: @escaping (String?) -> Void)
    
}
