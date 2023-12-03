//
//  MukchippaResult.swift
//  RockPaperScissors
//
//  Created by nayeon  on 2023/11/29.
//

import Foundation

enum MukchippaResult: Int {
    case draw = 0
    case computer = 1
    case user = 2

    var turnMessage: String? {
        switch self {
        case .user:
            return "[사용자 턴]"
        case .computer:
            return "[컴퓨터 턴]"
        case .draw:
            return nil
        }
    }

    var winMessage: String? {
            switch self {
            case .user:
                return "사용자의 승리"
            case .computer:
                return "컴퓨터의 승리"
            case .draw:
                return nil
            }
    }

    var turnStartMessage: String? {
        switch self {
        case .user:
            return "사용자의 턴입니다"
        case .computer:
            return "컴퓨터의 턴입니다"
        case .draw:
            return nil
        }
    }
}
