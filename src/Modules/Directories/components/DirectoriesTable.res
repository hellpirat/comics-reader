@react.component
let make = (~folders: array<string>, ~onRowClick, ~onDelete) => {
  let handleDelete = (event, index) => {
    onDelete(event, index)
  }

  let handleEdit = event => {
    ReactEvent.Mouse.stopPropagation(event)
  }

  let tableBody = Belt.Array.mapWithIndex(folders, (index, folder) => {
    <TableRow
      key={Belt.Int.toString(index)}
      className="cursor-pointer"
      onClick={event => onRowClick(event, folder)}>
      <TCol className="w-full"> {folder->React.string} </TCol>
      <TCol>
        <Button onClick={handleEdit} variant={#info}> {"Edit"->React.string} </Button>
        <Button onClick={event => handleDelete(event, index)} variant={#danger}>
          {"Delete"->React.string}
        </Button>
      </TCol>
    </TableRow>
  })

  <Table tableLayout={#fixed}>
    <THead>
      <TableRow hover={false}>
        <THeadCol> {"Name"->React.string} </THeadCol>
        <THeadCol className="text-right"> {"Actions"->React.string} </THeadCol>
      </TableRow>
    </THead>
    <TBody> {tableBody->React.array} </TBody>
  </Table>
}
