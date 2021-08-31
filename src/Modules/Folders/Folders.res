open FoldersApi
open UseToggle

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])
  let (value, setValue) = React.useState(() => "")
  let (currentDirectory, setCurrentDirectory) = React.useState(() => "./manga")

  let {value: isOpen, onOpen, onClose} = useToggle()

  React.useEffect2(() => {
    let res: array<string> = FolderApi.getDirectories(currentDirectory)
    setFolders(_ => res)
    setValue(_ => "")

    None
  }, (isOpen, currentDirectory))

  let handleAdd = event => {
    ReactEvent.Mouse.preventDefault(event)
    onOpen()
  }

  let handleClose = event => {
    ReactEvent.Mouse.preventDefault(event)
    onClose()
  }

  let handleSave = event => {
    ReactEvent.Mouse.preventDefault(event)
    FolderApi.create(`${currentDirectory}/${value}`)
    onClose()
  }

  let handleInputChange = event => {
    ReactEvent.Form.preventDefault(event)
    let value = ReactEvent.Form.target(event)["value"]
    setValue(_ => value)
  }

  let handleRowClick = (_, directory) => {
    setCurrentDirectory(prev => `${prev}/${directory}`)
  }

  <>
    <div className="flex items-center justify-between">
      <div className="mt-0 mb-2">
        <h1 className="text-4xl font-normal leading-normal  text-blueGray-800">
          {"Directories"->React.string}
        </h1>
      </div>
      <Button variant={#success} onClick={handleAdd}> {"Add new directory"->React.string} </Button>
    </div>
    <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <DirectoriesTable folders={folders} onRowClick={handleRowClick} />
    </div>
    <Modal title="Add new directory" isOpen={isOpen} onClose={handleClose} onSave={handleSave}>
      <div className="my-4 text-blueGray-500 text-lg leading-relaxed">
        <Input placeholder="Directory name..." value onChange={handleInputChange} />
      </div>
    </Modal>
  </>
}
