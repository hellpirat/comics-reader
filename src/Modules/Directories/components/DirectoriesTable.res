@react.component
let make = (~folders: array<string>, ~onRowClick) => {
  let tableBody = Belt.Array.mapWithIndex(folders, (index, folder) => {
    <TableRow
      key={Belt.Int.toString(index)}
      className="cursor-pointer"
      onClick={event => onRowClick(event, folder)}>
      <TCol> {folder->React.string} </TCol>
    </TableRow>
  })

  <Table tableLayout={#fixed}>
    <THead>
      <TableRow hover={false}> <THeadCol> {"Name"->React.string} </THeadCol> </TableRow>
    </THead>
    <TBody> {tableBody->React.array} </TBody>
  </Table>
}
