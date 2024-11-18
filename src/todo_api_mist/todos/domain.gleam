pub type CreateList {
  CreateList(title: String)
}

pub type List {
  List(title: String, id: String)
}

pub type CreateListError {
  Nil
}

// TODO: is this the right "tense" for the event?
pub type CreateListEvent {
  CreateListEvent(List)
}

pub fn create_list(dto: CreateList) -> Result(CreateListEvent, CreateListError) {
  List(title: dto.title, id: "1")
  |> CreateListEvent
  |> Ok
}
