import gleam/option.{type Option, None, Some}
import gleam/result
import todo_api_mist/greet/domain

pub type PersonDto {
  PersonDto(name: String)
}

pub type GreetingError {
  ValidationError
}

pub fn greeting(person: Option(PersonDto)) -> Result(String, GreetingError) {
  case person {
    None -> Ok(domain.greeting(None))
    Some(person) -> {
      let PersonDto(name: name) = person
      name
      |> domain.build_person
      |> result.map_error(fn(_) { ValidationError })
      |> result.map(Some)
      |> result.map(domain.greeting)
    }
  }
}
