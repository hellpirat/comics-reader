open DirectoriesApi
open UseToggle

let makeDirPath = (directories: array<string>) => {
  Js.Array2.joinWith(directories, "/")
}

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])
  let (value, setValue) = React.useState(() => "")
  let (currentDirectory, setCurrentDirectory) = React.useState(() => ["./manga"])

  let {value: isOpen, onOpen, onClose} = useToggle()

  let isRootDir = Belt.Array.length(currentDirectory) === 1 // ./manga
  let isMangeDir = Belt.Array.length(currentDirectory) === 2 // ./manga/naruto
  let isChapterDir = Belt.Array.length(currentDirectory) === 3 // ./mango/naruto/chapter1

  React.useEffect2(() => {
    let res: array<string> = DirectoriesApi.getDirectories(makeDirPath(currentDirectory))
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
    DirectoriesApi.createDirectory(`${makeDirPath(currentDirectory)}/${value}`)
    onClose()
  }

  let handleInputChange = event => {
    ReactEvent.Form.preventDefault(event)
    let value = ReactEvent.Form.target(event)["value"]
    setValue(_ => value)
  }

  let handleRowClick = (_, directory) => {
    setCurrentDirectory(prev => Js.Array2.concat(prev, [directory]))
  }

  let handleBreadcrumbClick = (event, targetIndex) => {
    ReactEvent.Mouse.preventDefault(event)
    setCurrentDirectory(prev => Js.Array2.filteri(prev, (_, arrIndex) => arrIndex <= targetIndex))
  }

  let lengthDirectories = Belt.Array.length(currentDirectory)

  let renderBreadcrumbs = Belt.Array.mapWithIndex(currentDirectory, (index, directory) => {
    <>
      {if index + 1 == lengthDirectories {
        <li className="pr-4 text-gray-700"> {React.string(directory)} </li>
      } else {
        <li className="pr-4">
          <button type_="button" onClick={event => handleBreadcrumbClick(event, index)}>
            {React.string(directory)}
          </button>
        </li>
      }}
    </>
  })

  let renderAddButton = if isRootDir {
    <Button variant={#success} onClick={handleAdd}> {"Add new manga"->React.string} </Button>
  } else if isMangeDir {
    <Button variant={#success} onClick={handleAdd}> {"Add new chapter"->React.string} </Button>
  } else if isChapterDir {
    <Button variant={#success} onClick={handleAdd}> {"Upload"->React.string} </Button>
  } else {
    React.null
  }

  <>
    <div className="flex items-center justify-between">
      <div className="mt-0 mb-2">
        <h1 className="text-4xl font-normal leading-normal  text-blueGray-800">
          {"Directories"->React.string}
        </h1>
      </div>
      {renderAddButton}
    </div>
    <div className="mt-0 mb-2">
      <nav ariaLabel="breadcrumb">
        <ol className="flex leading-none text-indigo-600 divide-x divide-indigo-400">
          {React.array(renderBreadcrumbs)}
        </ol>
      </nav>
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
