open FoldersApi
open UseToggle

let baseDir = "./manga"

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])
  let (value, setValue) = React.useState(() => "")

  let {value: isOpen, onOpen, onClose} = useToggle()

  React.useEffect1(() => {
    let res: array<string> = FolderApi.getDirectories("./manga")
    setFolders(_ => res)
    setValue(_ => "")

    None
  }, [isOpen])

  let hanldeAdd = event => {
    ReactEvent.Mouse.preventDefault(event)
    onOpen()
  }

  let handleClose = event => {
    ReactEvent.Mouse.preventDefault(event)
    onClose()
  }

  let handleSave = event => {
    ReactEvent.Mouse.preventDefault(event)
    FolderApi.create(`${baseDir}/${value}`)
    onClose()
  }

  let handleInputChange = event => {
    ReactEvent.Form.preventDefault(event)
    let value = ReactEvent.Form.target(event)["value"]
    setValue(_ => value)
  }

  let tableBody = Belt.Array.mapWithIndex(folders, (index, folder) => {
    <TableRow key={Belt.Int.toString(index)} className="cursor-pointer">
      <TCol> {folder->React.string} </TCol>
    </TableRow>
  })

  <div>
    <div className="flex items-center justify-between">
      <h1 className="text-4xl font-normal leading-normal mt-0 mb-2 text-blueGray-800">
        {"Directories"->React.string}
      </h1>
      <Button variant={#success} onClick={hanldeAdd}> {"Add new directory"->React.string} </Button>
    </div>
    <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <Table tableLayout={#fixed}>
        <THead>
          <TableRow hover={false}> <THeadCol> {"Name"->React.string} </THeadCol> </TableRow>
        </THead>
        <TBody> {tableBody->React.array} </TBody>
      </Table>
    </div>
    <Modal title="Add new directory" isOpen={isOpen} onClose={handleClose} onSave={handleSave}>
      <div className="my-4 text-blueGray-500 text-lg leading-relaxed">
        <Input placeholder="Directory name..." value onChange={handleInputChange} />
      </div>
    </Modal>
  </div>
}
