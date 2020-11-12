import Combine

public class QuickActionToPerform: ObservableObject {
    public enum QuickAction: Hashable {
        case add
    }

    @Published public var quickAction: QuickAction?

    public init() {}
}
