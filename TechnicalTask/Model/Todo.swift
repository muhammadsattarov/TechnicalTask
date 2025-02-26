//
//  Todo.swift
//  TechnicalTask
//
//  Created by user on 26/02/25.
//

import Foundation

struct Todo: Codable {
  let userId: Int
  let id: Int
  let title: String
  let completed: Bool
}
