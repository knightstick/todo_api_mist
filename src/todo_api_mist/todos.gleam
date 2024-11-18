import gleam/result
import todo_api_mist/todos/domain

pub type CreateListDto {
  CreateListDto(title: String)
}

pub type CreateListTodoDto {
  CreateListTodoDto(title: String)
}

pub type ListDto {
  ListDto(title: String, id: ListIdDto)
}

pub type ListIdDto {
  ListIdDto(String)
}

pub type CreateListError {
  CreateListDomainError
}

pub type CreateListTodoError {
  CreateListTodoDomainError
}

pub fn create_list(dto: CreateListDto) -> Result(ListDto, CreateListError) {
  dto
  |> create_list_dto_to_domain
  |> domain.create_list
  |> result.map(create_list_event_domain_to_dto)
  |> result.map_error(fn(_) { CreateListDomainError })
}

pub fn create_list_todo(
  _list_id: ListIdDto,
  _dto: CreateListTodoDto,
) -> Result(ListDto, CreateListTodoError) {
  // fetch the list from the repository
  // create the params for the domain
  // run the domain function
  // map the result to a dto
  // map the error to a dto

  todo
}

fn create_list_dto_to_domain(dto: CreateListDto) -> domain.CreateList {
  // TODO: validation -- some validation goes here right?
  domain.CreateList(title: dto.title)
}

fn create_list_event_domain_to_dto(event: domain.CreateListEvent) -> ListDto {
  let domain.CreateListEvent(domain.TodoList(title: title, id: id, todos: _)) =
    event
  ListDto(title: title, id: ListIdDto(id))
}
