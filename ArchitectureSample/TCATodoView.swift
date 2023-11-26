import SwiftUI
import ComposableArchitecture

// MARK: - Model
struct TCATodoItem: Identifiable, Equatable {
    var id: UUID
    var task: String
}

struct TCATodoState: Equatable {
    var tasks: [TCATodoItem] = []
}

enum TCATodoAction: Equatable {
    case add(task: String)
    case removeTask(atOffsets: IndexSet)
}

// MARK: - Reducer
let swiftUITCATodoReducer = Reducer<TCATodoState, TCATodoAction, Void> { state, action, _ in
    switch action {
    case .add(let task):
        let newItem = TCATodoItem(id: UUID(), task: task)
        state.tasks.append(newItem)
        return .none
    case .removeTask(let offsets):
        state.tasks.remove(atOffsets: offsets)
        return .none
    }
}

// MARK: - View
struct TCATodoView: View {
    let titleText: String
    let store: Store<TCATodoState, TCATodoAction>
    
    @State private var newTask: String = ""
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    TextField("New task " + titleText, text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        viewStore.send(.add(task: newTask))
                        newTask = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                    }
                }
                .padding()
                
                List {
                    ForEach(viewStore.tasks) { todo in
                        Text(todo.task)
                    }
                    .onDelete { offsets in
                        viewStore.send(.removeTask(atOffsets: offsets))
                    }
                }
            }
            .navigationTitle(titleText)
        }
    }
}
