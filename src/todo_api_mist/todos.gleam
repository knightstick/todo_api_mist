import gleam/result
import todo_api_mist/todos/domain

pub type CreateListDto {
  CreateListDto(title: String)
}

pub type ListDto {
  ListDto(title: String, id: String)
}

pub type CreateListError {
  DomainError
}

pub fn create_list(dto: CreateListDto) -> Result(ListDto, CreateListError) {
  dto
  |> create_list_dto_to_domain
  |> domain.create_list
  |> result.map(create_list_event_domain_to_dto)
  |> result.map_error(fn(_) { DomainError })
}

fn create_list_dto_to_domain(dto: CreateListDto) -> domain.CreateList {
  // TODO: validation -- some validation goes here right?
  domain.CreateList(title: dto.title)
}

fn create_list_event_domain_to_dto(event: domain.CreateListEvent) -> ListDto {
  let domain.CreateListEvent(domain.List(title: title, id: id)) = event
  ListDto(title: title, id: id)
}
