# todo_api_mist TODO

CRUD Todos via Web API
- [x] Create a new list
- [ ] Add a todo to a list
- [ ] View the list with the todos
- [ ] Validate presence and length of string attributes
- [ ] Mark an item as completed
etc.

## Add a todo to a list

```http
POST /todos/lists/{list_id}/todos
{ "description": "Buy milk" }
```
