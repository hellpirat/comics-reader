open Cx

@react.component
let make = (~children: React.element, ~className as classNameProp: option<string>=?) => {
  let className = cx([
    "bg-white divide-y divide-gray-200",
    Belt.Option.getWithDefault(classNameProp, ""),
  ])

  <tbody className={className}> children </tbody>
}
