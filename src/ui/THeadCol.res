open Cx

@react.component
let make = (~children: React.element, ~className as classNameProp: option<string>=?) => {
  let className = cx([
    "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wide",
    Belt.Option.getWithDefault(classNameProp, ""),
  ])
  <th scope="col" className={className}> children </th>
}
