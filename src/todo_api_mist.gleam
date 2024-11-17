import gleam/erlang/process
import mist
import todo_api_mist/web
import wisp
import wisp/wisp_mist

pub fn main() {
  // TODO: Generate a random secret key base
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(web.web_service, secret_key_base)
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http

  process.sleep_forever()
}
