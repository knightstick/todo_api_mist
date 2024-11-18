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
  WorkflowError(application.GreetingError)
}

pub fn greet(request: Request) -> Response {
  request
  |> parse
  |> result.try(workflow)
  |> response
}

fn parse(req: Request) -> Result(Option(application.PersonDto), GreetError) {
  req
  |> parse_name
  |> build_person_dto
}

fn workflow(person: Option(application.PersonDto)) -> Result(String, GreetError) {
  person
  |> application.greeting
  |> result.map_error(WorkflowError)
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
    Ok(name) -> Ok(Some(application.PersonDto(name: name)))
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
    Error(WorkflowError(_error)) -> {
      "Workflow Error"
      |> string_builder.from_string
      |> wisp.html_response(422)
    }
  }
}
