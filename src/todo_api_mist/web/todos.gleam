import gleam/http.{Post}
import gleam/result
import gleam/string_builder
import wisp.{type Request, type Response}

import todo_api_mist/todos as application

pub type CreateListError {
  WorkflowError(application.CreateListError)
}

pub fn lists(req: Request) -> Response {
  case req.method {
    Post -> create_list(req)
    _ -> wisp.method_not_allowed([Post])
  }
}

fn create_list(req: Request) -> Response {
  req
  |> parse
  |> result.try(workflow)
  |> response
}

fn parse(_req) -> Result(application.CreateListDto, _) {
  // TODO parse the params from the request
  "title"
  |> build_dto
  |> Ok
}

fn build_dto(title: String) -> application.CreateListDto {
  application.CreateListDto(title: title)
}

fn workflow(list_dto: application.CreateListDto) -> Result(_, _) {
  list_dto
  |> application.create_list
  |> result.map_error(WorkflowError)
}

fn response(res) -> Response {
  case res {
    Ok(list_dto) -> {
      list_dto
      |> serialize
      |> string_builder.from_string
      |> wisp.html_response(201)
    }
    Error(_) -> {
      "Bad Request"
      |> string_builder.from_string
      |> wisp.html_response(400)
    }
  }
}

fn serialize(dto: application.ListDto) {
  // TODO: serialize json
  dto.id <> " " <> dto.title
}
