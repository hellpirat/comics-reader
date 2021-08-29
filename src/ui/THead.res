open Cx

@react.component
let make = (~children: React.element, ~className as classNameProp: option<string>=?) => {
  let className = cx(["bg-gray-50", Belt.Option.getWithDefault(classNameProp, "")])
  <thead className={className}> children </thead>
}
