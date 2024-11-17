import gleam/http/request
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string_builder
import todo_api_mist/greet as application
import wisp.{type Request, type Response}

type ParseError {
  QueryParseError
  KeyMissing
}

type GreetError {
  QueryParseVariant
  ValidationError(application.ValidationError)
}

pub fn greet(request: Request) -> Response {
  request
  |> parse_name
  |> build_person_dto
  |> result.map(application.greeting)
  |> response
}

fn parse_name(request: Request) -> Result(String, ParseError) {
  request.get_query(request)
  |> result.map_error(fn(_) { QueryParseError })
  |> result.try(find_name)
}

fn find_name(query_list: List(#(String, String))) -> Result(String, ParseError) {
  query_list
  |> list.key_find("name")
  |> result.map_error(fn(_) { KeyMissing })
}

fn build_person_dto(
  result: Result(String, ParseError),
) -> Result(Option(application.PersonDto), GreetError) {
  case result {
    Error(KeyMissing) -> Ok(None)
    Error(QueryParseError) -> Error(QueryParseVariant)
    Ok(name) -> build_person_dto_from_name(name)
  }
}

fn build_person_dto_from_name(
  name: String,
) -> Result(Option(application.PersonDto), GreetError) {
  case application.build_person_dto(name) {
    Ok(person) -> Ok(Some(person))
    Error(err) -> Error(ValidationError(err))
  }
}

fn response(result: Result(String, GreetError)) -> Response {
  case result {
    Ok(greeting) -> {
      greeting
      |> string_builder.from_string
      |> wisp.html_response(200)
    }
    Error(QueryParseVariant) -> {
      "Query Parse Error"
      |> string_builder.from_string
      |> wisp.html_response(400)
    }
    Error(ValidationError(_err)) -> {
      "Validation Error"
      |> string_builder.from_string
      |> wisp.html_response(422)
    }
  }
}
