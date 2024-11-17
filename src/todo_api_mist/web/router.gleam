import todo_api_mist/web
import todo_api_mist/web/greet
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["greet"] -> greet.greet(req)
    _ -> wisp.not_found()
  }
}
