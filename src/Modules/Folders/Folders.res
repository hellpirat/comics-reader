open FoldersApi

type folders = array<string>

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])

  React.useEffect0(() => {
    let res: array<string> = FolderApi.getDirectories("./manga")
    setFolders(_ => res)

    None
  })

  let tableBody = Belt.Array.mapWithIndex(folders, (index, folder) => {
    <TableRow key={Belt.Int.toString(index)} className="cursor-pointer">
      <TCol> {folder->React.string} </TCol>
    </TableRow>
  })

  <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
    <Table tableLayout={#fixed}>
      <THead>
        <TableRow hover={false}> <THeadCol> {"Name"->React.string} </THeadCol> </TableRow>
      </THead>
      <TBody> {tableBody->React.array} </TBody>
    </Table>
  </div>
}