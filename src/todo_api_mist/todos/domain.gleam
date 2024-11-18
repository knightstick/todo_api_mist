// TODO: remove simple types and use domain types
pub type CreateList {
  CreateList(title: String)
}

pub type CreateListTodo {
  CreateListTodo(title: String, list: TodoList)
}

pub type TodoList {
  TodoList(title: String, id: String, todos: List(Todo))
}

pub type Todo {
  Todo(title: String, id: String)
}

pub type CreateListError {
  Nil
}

pub type CreateListTodoError {
  Nil2
}

// TODO: is this the right "tense" for the event?
pub type CreateListEvent {
  CreateListEvent(TodoList)
}

pub type CreateListTodoEvent {
  CreateListTodoEvent(TodoList)
}

pub fn create_list(dto: CreateList) -> Result(CreateListEvent, CreateListError) {
  // TODO: ID? Or generated by the DB?
  TodoList(title: dto.title, id: "1", todos: [])
  |> CreateListEvent
  |> Ok
}

pub fn create_list_todo(
  dto: CreateListTodo,
) -> Result(CreateListTodoEvent, CreateListTodoError) {
  let CreateListTodo(title: title, list: list) = dto

  // TODO: ID? Or generated by the DB?
  TodoList(title: list.title, id: "1", todos: [Todo(title: title, id: "2")])
  |> CreateListTodoEvent
  |> Ok
}
