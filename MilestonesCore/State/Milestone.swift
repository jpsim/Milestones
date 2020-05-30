import ComposableArchitecture
import SwiftUI

// MARK: - State

struct Milestone: Codable, Hashable, Identifiable, Comparable {
    let id: UUID
    let calendar: Calendar

    var title: String
    var today: Date
    var date: Date
    var isEditing: Bool

    static func < (lhs: Milestone, rhs: Milestone) -> Bool {
        (lhs.date, lhs.title) < (rhs.date, rhs.title)
    }
}

// MARK: - Action

enum MilestoneAction: Equatable {
    case delete
    case setIsEditing(Bool)
    case setTitle(String)
    case setDate(Date)
}

// MARK: - Environment

struct MilestoneEnvironment {}

// MARK: - Reducer

let milestoneReducer = Reducer<Milestone, MilestoneAction, MilestoneEnvironment> { state, action, _ in
    switch action {
    case .delete:
        return .none
    case .setIsEditing(let isEditing):
        state.isEditing = isEditing
        return .none
    case .setTitle(let title):
        state.title = title
        return .none
    case .setDate(let date):
        state.date = date
        return .none
    }
}
