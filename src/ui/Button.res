open Cx

type buttonType = [#button | #submit | #reset]
type buttonSize = [#large | #regular | #small]
type buttonVariant = [#danger | #success | #info | #secondary]

@react.component
let make = (
  ~children: React.element,
  ~type_: buttonType=#button,
  ~className as classNameProp: option<string>=?,
  ~variant=#secondary,
  ~size=#regular,
  ~onClick=?,
  ~disabled=false,
) => {
  let handleClick = event => {
    switch onClick {
    | Some(f) => f(event)
    | None => ()
    }
  }

  let className = cx([
    "m-2 transition-colors duration-150 rounded-lg focus:shadow-outline",
    switch variant {
    | #danger => "bg-red-700 hover:bg-red-800 text-red-100"
    | #success => "bg-green-700 hover:bg-green-800 text-green-100"
    | #info => "bg-blue-700 hover:bg-blue-800 text-blue-100"
    | #secondary => "bg-gray-700 hover:bg-gray-800 text-gray-100"
    },
    switch size {
    | #large => "h-12 px-6 text-lg"
    | #regular => "h-10 px-5"
    | #small => "h-8 px-4 text-sm"
    },
    Belt.Option.getWithDefault(classNameProp, ""),
  ])
  <button type_={(type_ :> string)} className={className} onClick={handleClick} disabled>
    children
  </button>
}