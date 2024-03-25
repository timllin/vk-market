//
//  SearchInfo.swift
//  vk-market-intership--2024
//
//  Created by Тимур Калимуллин on 25.03.2024.
//

import Foundation

struct SearchInfo {
    let title: String
    let subtitle: String

    public func createQuery() -> String {
        return "\(title), \(subtitle)"
    }
}
