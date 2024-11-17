import gleam/http/request
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string_builder
import todo_api_mist/greet as application
import wisp.{type Request, type Response}

pub fn greet(request: Request) -> Response {
  request
  |> parse_name
  |> result.try(application.build_person_dto)
  |> option.from_result
  |> application.greeting
  |> response
}

fn parse_name(request: Request) -> Result(String, String) {
  let queries = request.get_query(request)

  let result = case queries {
    Error(_) -> Error(Nil)
    Ok(query_list) -> list.key_find(query_list, "name")
  }

  result |> result.map_error(fn(_) { "Failed to parse query" })
}

fn response(greeting: String) -> Response {
  greeting
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn build_dto(name: String) -> Result(application.PersonDto, _) {
  application.build_person_dto(name)
}
