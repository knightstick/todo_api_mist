import gleam/option.{type Option, None, Some}

pub opaque type PersonDto {
  Name(String)
}

pub type ValidationError {
  ValidationError
}

pub fn build_person_dto(name: String) -> Result(PersonDto, ValidationError) {
  // TODO: validations
  Ok(Name(name))
}

pub fn greeting(person: Option(PersonDto)) -> String {
  case person {
    Some(Name(name)) -> "Hello, " <> name <> "!"
    None -> "Hello, World"
  }
}
