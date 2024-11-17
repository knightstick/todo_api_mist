import gleam/erlang/process
import mist
import todo_api_mist/web

pub fn main() {
  let assert Ok(_) =
    web.web_service
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http

  process.sleep_forever()
}
