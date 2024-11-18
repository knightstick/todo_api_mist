import todo_api_mist/web
import todo_api_mist/web/greet as greet_web
import todo_api_mist/web/todos as todos_web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["greet"] -> greet_web.greet(req)
    ["todos", "lists"] -> todos_web.lists(req)
    _ -> wisp.not_found()
  }
}
