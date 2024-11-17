import gleam/option.{type Option, None, Some}

pub type PersonDto {
  PersonDto(name: String)
}

pub fn greeting(person: Option(PersonDto)) -> String {
  case person {
    Some(PersonDto(name: name)) -> "Hello, " <> name <> "!"
    None -> "Hello, World"
  }
}
