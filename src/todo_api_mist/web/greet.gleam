import gleam/http/request
import gleam/list
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn greet(request: Request) -> Response {
  let name = parse_name(request)

  case name {
    Ok(name) -> response(name)
    Error(_) -> response("World")
  }
}

fn parse_name(request: Request) -> Result(String, Nil) {
  let queries = request.get_query(request)

  case queries {
    Error(_) -> Error(Nil)
    Ok(query_list) -> list.key_find(query_list, "name")
  }
}

fn response(name: String) -> Response {
  let body = string_builder.from_string("Hello, " <> name <> "!\n")

  wisp.html_response(body, 200)
}
