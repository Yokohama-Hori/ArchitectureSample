import SwiftUI

// MARK: - Model
struct SwiftUIFluxTodoItem: Identifiable {
    var id = UUID()
    var task: String
}

// MARK: - Actions
enum SwiftUIFluxTodoAction {
    case add(task: String)
    case removeTask(atOffsets: IndexSet)
}

// MARK: - Store
class SwiftUIFluxTodoStore: ObservableObject {
    @Published private(set) var tasks: [SwiftUIFluxTodoItem] = []

    func dispatch(action: SwiftUIFluxTodoAction) {
        switch action {
        case .add(let task):
            let newItem = SwiftUIFluxTodoItem(task: task)
            tasks.append(newItem)
        case .removeTask(let offsets):
            tasks.remove(atOffsets: offsets)
        }
    }
}

// MARK: - View
struct SwiftUIFluxTodoView: View {
    let titleText: String
    
    @State private var newTask: String = ""
    @ObservedObject var store = SwiftUIFluxTodoStore()
    
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
                ForEach(store.tasks) { task in
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
