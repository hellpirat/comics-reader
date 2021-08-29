open Cx

type tableLayout = [#auto | #fixed]

@react.component
let make = (
  ~children: React.element,
  ~className as classNameProp: option<string>=?,
  ~tableLayout: option<tableLayout>=?,
) => {
  let className = cx([
    "min-w-full divide-y divide-gray-200",
    Belt.Option.getWithDefault(classNameProp, ""),
    switch tableLayout {
    | Some(#auto) => "table-auto"
    | Some(#fixed) => "table-fixed"
    | _ => ""
    },
  ])

  <table className={className}> {children} </table>
}