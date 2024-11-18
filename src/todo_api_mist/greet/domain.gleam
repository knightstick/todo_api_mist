import gleam/option.{type Option, None, Some}

pub opaque type Person {
  Person(name: Name)
}

type Name {
  Name(name: String)
}

pub type ValidationError {
  ValidationError
}

// TODO: validation and errors
pub fn build_person(name: String) -> Result(Person, ValidationError) {
  Ok(Person(Name(name)))
}

pub fn greeting(opt: Option(Person)) -> String {
  case opt {
    Some(Person(name: name)) -> "Hello, " <> name_to_string(name) <> "!\n"
    None -> "Hello, World!\n"
  }
}

fn name_to_string(name: Name) {
  let Name(name: name) = name
  name
}
