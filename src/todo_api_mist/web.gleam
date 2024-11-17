import gleam/http/request.{type Request}
import gleam/http/response.{type Response, Response}
import gleam/list
import gleam/string_builder
import wisp

pub fn web_service(request: Request(_)) -> Response(_) {
  let name = parse_name(request)

  case name {
    Ok(name) -> response(name)
    Error(_) -> response("World")
  }
}

fn parse_name(request: Request(_)) -> Result(String, Nil) {
  let queries = request.get_query(request)

  case queries {
    Error(_) -> Error(Nil)
    Ok(query_list) -> list.key_find(query_list, "name")
  }
}

fn response(name: String) -> Response(_) {
  let body = string_builder.from_string("Hello, " <> name <> "!\n")

  wisp.html_response(body, 200)
}
