# Naming Conventions

Use repository and language naming rules first. Examples use TypeScript; adapt them to Go and Python conventions.

## Use English for naming

All variables, functions, classes, and other identifiers should be named using English
words to ensure consistency and readability across the codebase.

TypeScript example:

```ts
/* Bad */
const primerNombre = 'Gustavo'
const amigos = ['Kate', 'John']

/* Good */
const firstName = 'Gustavo'
const friends = ['Kate', 'John']
```

## Use standard casing

Use consistent casing for variables, functions, classes, and other identifiers according
to the conventions of the respective programming language.

TypeScript example:

```ts
/* Bad in TypeScript */
const page_count = 5

/* Good */
const pageCount = 5
const shouldUpdate = true

/* Good where external schema requires snake_case */
const page_count = 5
const should_update = true
```

## Use short, intuitive, descriptive names

A name must be short, intuitive, and descriptive:

* **Short**: easy to type and remember.
* **Intuitive**: reads naturally.
* **Descriptive**: states purpose or value.

TypeScript example:

```ts
/* Bad */
const a = 5 // "a" could mean anything
const isPaginatable = a > 10 // "Paginatable" sounds extremely unnatural
const shouldPaginatize = a > 10 // Made up verbs are bad

/* Good */
const postCount = 5
const hasPagination = postCount > 10
const shouldPaginate = postCount > 10 // alternatively
```

## Avoid abbreviations

Do not shorten words when full names remain clear and practical.

TypeScript example:

```ts
/* Bad */
const onItmClk = () => {}

/* Good */
const onItemClick = () => {}
```

## Avoid context duplication

A name should not duplicate the context in which it is defined. Always remove the context
from a name if that doesn't decrease its readability.

TypeScript example:

```ts
class MenuItem {
  /* Bad: Method name duplicates the context (which is "MenuItem") */
  handleMenuItemClick = (event) => { ... }

  /* Good: Reads nicely as `MenuItem.handleClick()` */
  handleClick = (event) => { ... }
}
```

## Reflect the expected result

A name should clearly indicate the expected result or outcome of the variable, function, or method it represents.

TypeScript example:

```ts
/* Bad */
const isEnabled = itemCount > 3
return <Button disabled={!isEnabled} />

/* Good */
const isDisabled = itemCount <= 3
return <Button disabled={isDisabled} />
```

## Name functions by action and context

Use this pattern:

`prefix? + action (A) + high context (HC) + low context? (LC)`

`prefix` and `low context` are optional.

* **Action**: verb that states function behavior.
* **Context**: subject or data type. High context is most specific part.
* **Prefix**: use only to disambiguate or add meaning.

TypeScript example:

```ts
/* Bad */
const click = (event) => { ... } // action is not clear, high context is missing

/* Good */
// prefix: should, action:Display, high context: Message
const shouldDisplayMessage = (event) => { ... }

// action: get, high context: User, low context: Messages
const getUserMessages = () => { ... }
```

## Match singular and plural names

Use plural names for collections and singular names for single entities.

TypeScript example:

```ts
/* Bad */
const friends = 'Bob'
const friend = ['Bob', 'Tony', 'Tanya']
const userList = getUser() // "userList" implies multiple users, but the function returns a single user

/* Good */
const friend = 'Bob'
const friends = ['Bob', 'Tony', 'Tanya']
const user = getUser()
const users = getUsers()
```
