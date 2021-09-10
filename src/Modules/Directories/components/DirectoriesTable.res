@react.component
let make = (~folders: array<string>, ~onRowClick, ~onEdit, ~onDelete, ~isChapterDir) => {
  let tableBody = Belt.Array.mapWithIndex(folders, (index, folder) => {
    <TableRow
      key={Belt.Int.toString(index)}
      className="cursor-pointer"
      onClick={event => onRowClick(event, folder)}>
      <TCol className="w-full"> {folder->React.string} </TCol>
      {if !isChapterDir {
        <TCol>
          <Button onClick={event => onEdit(event, index)} variant={#info}>
            {"Edit"->React.string}
          </Button>
          <Button onClick={event => onDelete(event, index)} variant={#danger}>
            {"Delete"->React.string}
          </Button>
        </TCol>
      } else {
        React.null
      }}
    </TableRow>
  })

  <>
    <Table tableLayout={#fixed}>
      <THead>
        <TableRow hover={false}>
          <THeadCol> {"Name"->React.string} </THeadCol>
          {if !isChapterDir {
            <THeadCol className="text-right"> {"Actions"->React.string} </THeadCol>
          } else {
            React.null
          }}
        </TableRow>
      </THead>
      <TBody> {tableBody->React.array} </TBody>
    </Table>
  </>
}
