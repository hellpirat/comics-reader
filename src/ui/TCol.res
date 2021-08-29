open Cx

@react.component
let make = (~children: React.element, ~className as classNameProp: option<string>=?) => {
  let className = cx(["px-6 py-4 whitespace-nowrap", Belt.Option.getWithDefault(classNameProp, "")])
  <td className={className}> children </td>
}
