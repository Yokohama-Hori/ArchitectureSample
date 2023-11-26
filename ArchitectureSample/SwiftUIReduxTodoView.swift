import SwiftUI

// MARK: - Model
struct SwiftUIReduxTodoItem: Identifiable {
    var id = UUID()
    var task: String
}

// MARK: - State
struct SwiftUIReduxTodoState {
    var tasks: [SwiftUIReduxTodoItem] = []
}

// MARK: - Actions
enum SwiftUIReduxTodoAction {
    case add(task: String)
    case removeTask(atOffsets: IndexSet)
}

// MARK: - Reducer
func swiftUIReduxTodoReducer(state: inout SwiftUIReduxTodoState, action: SwiftUIReduxTodoAction) {
    switch action {
    case .add(let task):
        let newItem = SwiftUIReduxTodoItem(task: task)
        state.tasks.append(newItem)
    case .removeTask(let offsets):
        state.tasks.remove(atOffsets: offsets)
    }
}

// MARK: - Store
class SwiftUIReduxStore: ObservableObject {
    @Published private(set) var state: SwiftUIReduxTodoState = SwiftUIReduxTodoState()

    func dispatch(action: SwiftUIReduxTodoAction) {
        swiftUIReduxTodoReducer(state: &state, action: action)
    }
}

// MARK: - View
struct SwiftUIReduxTodoView: View {
    let titleText: String

    @State private var newTask: String = ""
    @ObservedObject var store = SwiftUIReduxStore()

    var body: some View {
        VStack {
            HStack {
                TextField("New task " + titleText, text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    store.dispatch(action: .add(task: newTask))
                    newTask = ""
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding()

            List {
                ForEach(store.state.tasks) { task in
                    Text(task.task)
                }
                .onDelete { offsets in
                    store.dispatch(action: .removeTask(atOffsets: offsets))
                }
            }
        }
        .navigationTitle(titleText)
    }
}
