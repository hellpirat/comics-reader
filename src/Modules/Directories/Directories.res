open DirectoriesApi
open UseToggle
open Promise
open ImagesApi

let makeDirPath = (directories: array<string>) => {
  Js.Array2.joinWith(directories, "/")
}

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])
  let (value, setValue) = React.useState(() => "")
  let (currentDirectory, setCurrentDirectory) = React.useState(() => ["comics"])

  let {value: isOpen, onOpen, onClose} = useToggle()

  let lengthDirectories = Belt.Array.length(currentDirectory)

  let isRootDir = lengthDirectories === 1 // ./comics
  let isMangaDir = lengthDirectories === 2 // ./comics/naruto
  let isChapterDir = lengthDirectories === 3 // ./comics/naruto/chapter1

  let currentDirectoryPath = makeDirPath(currentDirectory)

  React.useEffect3(() => {
    if isChapterDir {
      let res: array<string> = ImagesApi.getImages(currentDirectoryPath)
      setFolders(_ => res)
    } else {
      let res: array<string> = DirectoriesApi.getDirectories(currentDirectoryPath)
      setFolders(_ => res)
    }

    setValue(_ => "")

    None
  }, (isOpen, currentDirectory, isChapterDir))

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
    DirectoriesApi.createDirectory(`${currentDirectoryPath}/${value}`)
    onClose()
  }

  let handleRead = event => {
    ReactEvent.Mouse.preventDefault(event)
    RescriptReactRouter.push(`/${currentDirectoryPath}`)
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

  let handleUpload = event => {
    ReactEvent.Mouse.preventDefault(event)

    let remote = Electron.remote
    let dialog = remote.dialog

    dialog.showOpenDialog({
      properties: ["openFile", "multiSelections"],
      filters: [{name: "Images", extensions: ["jpg"]}],
    })
    ->Promise.then(result => {
      let {canceled, filePaths} = result
      if !canceled {
        // TODO: add try/catch
        Belt.Array.forEach(filePaths, path => {
          let splitedPath = path->Js.String2.split("/")
          let fileName = Belt.Array.get(splitedPath, Belt.Array.length(splitedPath) - 1)
          switch fileName {
          | Some(fileName) => ImagesApi.uploadToFolder(path, currentDirectoryPath, fileName)
          | None => Js.Exn.raiseError("Bad file name")
          }
        })
      }
      resolve()
    })
    ->ignore
  }

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
  } else if isMangaDir {
    <Button variant={#success} onClick={handleAdd}> {"Add new chapter"->React.string} </Button>
  } else if isChapterDir {
    <>
      <Button variant={#success} onClick={handleRead}> {"Read"->React.string} </Button>
      <Button variant={#success} onClick={handleUpload}> {"Upload"->React.string} </Button>
    </>
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
