import gleam/dynamic.{type Dynamic}
import gleam/http.{Post}
import gleam/json
import gleam/result
import gleam/string_builder
import wisp.{type Request, type Response}

import todo_api_mist/todos as application

pub type CreateListError {
  WorkflowError(application.CreateListError)
  DecodeError
}

type CreateListParams {
  CreateListParams(list: application.CreateListDto)
}

pub fn lists(req: Request) -> Response {
  case req.method {
    Post -> create_list(req)
    _ -> wisp.method_not_allowed([Post])
  }
}

fn create_list(req: Request) -> Response {
  use json <- wisp.require_json(req)

  json
  |> parse
  |> result.try(workflow)
  |> response
}

fn parse(json: Dynamic) -> Result(application.CreateListDto, _) {
  json
  |> decode_create_list
  |> result.map_error(fn(_) { DecodeError })
}

fn decode_create_list(
  json,
) -> Result(application.CreateListDto, dynamic.DecodeErrors) {
  let decoder =
    dynamic.decode1(
      CreateListParams,
      dynamic.field(
        "list",
        dynamic.decode1(
          application.CreateListDto,
          dynamic.field("title", dynamic.string),
        ),
      ),
    )

  case decoder(json) {
    Ok(CreateListParams(list)) -> Ok(list)
    Error(errors) -> Error(errors)
  }
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
      |> wisp.html_response(201)
    }
    Error(DecodeError) -> {
      "Bad Request"
      |> string_builder.from_string
      |> wisp.html_response(400)
    }
    Error(WorkflowError(application.DomainError)) -> {
      "Unprocessable Entity"
      |> string_builder.from_string
      |> wisp.html_response(422)
    }
  }
}

fn serialize(dto: application.ListDto) {
  let object =
    json.object([
      #("id", json.string(dto.id)),
      #("title", json.string(dto.title)),
    ])

  object
  |> json.to_string_builder
  |> string_builder.append("\n")
}
