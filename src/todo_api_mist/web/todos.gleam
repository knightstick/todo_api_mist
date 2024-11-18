import gleam/dynamic
import gleam/http.{Post}
import gleam/json
import gleam/result
import gleam/string_builder
import wisp.{type Request, type Response}

import todo_api_mist/todos as application

pub type CreateListError {
  WorkflowError(application.CreateListError)
  CLDecodeError
}

pub type CreateListTodoError {
  CreateListTodoWorkflowError(application.CreateListTodoError)
  CLTDecodeError
}

type CreateListParams {
  CreateListParams(list: application.CreateListDto)
}

type CreateListTodoParams {
  CreateListTodoParams(the_todo: application.CreateListTodoDto)
}

pub fn lists(req: Request) -> Response {
  case req.method {
    Post -> create_list(req)
    _ -> wisp.method_not_allowed([Post])
  }
}

pub fn list_todos(req: Request, list_id: String) -> Response {
  case req.method {
    Post -> create_list_todo(req, list_id)
    _ -> wisp.method_not_allowed([Post])
  }
}

fn create_list(req: Request) -> Response {
  use json <- wisp.require_json(req)

  let parse = fn(json) {
    json
    |> decode_create_list
    |> result.map_error(fn(_) { CLDecodeError })
  }

  let workflow = fn(list_dto) {
    list_dto
    |> application.create_list
    |> result.map_error(WorkflowError)
  }

  let response = fn(res) {
    case res {
      Ok(list_dto) -> {
        list_dto
        |> serialize
        |> wisp.html_response(201)
      }
      Error(CLDecodeError) -> {
        "Bad Request"
        |> string_builder.from_string
        |> wisp.html_response(400)
      }
      Error(WorkflowError(application.CreateListDomainError)) -> {
        "Unprocessable Entity"
        |> string_builder.from_string
        |> wisp.html_response(422)
      }
    }
  }

  json
  |> parse
  |> result.try(workflow)
  |> response
}

fn create_list_todo(req: Request, list_id: String) -> Response {
  let list_id = application.ListIdDto(list_id)

  use json <- wisp.require_json(req)

  let parse = fn(json) {
    json
    |> decode_create_list_todo
    |> result.map_error(fn(_) { CLTDecodeError })
  }

  let workflow = fn(todo_dto) {
    todo_dto
    |> application.create_list_todo(list_id, _)
    |> result.map_error(CreateListTodoWorkflowError)
  }

  let response = fn(res) {
    case res {
      Ok(list_dto) -> {
        list_dto
        |> serialize
        |> wisp.html_response(201)
      }
      Error(CLTDecodeError) -> {
        "Bad Request"
        |> string_builder.from_string
        |> wisp.html_response(400)
      }
      Error(CreateListTodoWorkflowError(application.CreateListTodoDomainError)) -> {
        "Unprocessable Entity"
        |> string_builder.from_string
        |> wisp.html_response(422)
      }
    }
  }

  json
  |> parse
  |> result.try(workflow)
  |> response
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

fn decode_create_list_todo(json) {
  let decoder =
    dynamic.decode1(
      CreateListTodoParams,
      dynamic.field(
        "todo",
        dynamic.decode1(
          application.CreateListTodoDto,
          dynamic.field("title", dynamic.string),
        ),
      ),
    )

  case decoder(json) {
    Ok(CreateListTodoParams(the_todo)) -> Ok(the_todo)
    Error(errors) -> Error(errors)
  }
}

fn serialize(dto: application.ListDto) {
  let application.ListDto(id: application.ListIdDto(id), title: title) = dto

  let object =
    json.object([#("id", json.string(id)), #("title", json.string(title))])

  object
  |> json.to_string_builder
  |> string_builder.append("\n")
}
