open Cx

@react.component
let make = (
  ~children: React.element,
  ~className as classNameProp: option<string>=?,
  ~hover=true,
  ~onClick=?,
) => {
  let hoverClassName = if hover {
    "hover:bg-blue-200"
  } else {
    ""
  }
  let className = cx([Belt.Option.getWithDefault(classNameProp, ""), hoverClassName])

  let handleClick = event => {
    ReactEvent.Mouse.preventDefault(event)

    switch onClick {
    | Some(f) => f()
    | None => ()
    }
  }

  <tr className={className} onClick={handleClick}> children </tr>
}
