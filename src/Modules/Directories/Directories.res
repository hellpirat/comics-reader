open DirectoriesApi
open UseToggle
open Promise
open ImagesApi
open DirectoriesUtils

@react.component
let make = () => {
  let (folders, setFolders) = React.useState(() => [])
  let (value, setValue) = React.useState(() => "")
  let (currentDirectory, setCurrentDirectory) = React.useState(() => ["comics"])
  let (isEditIndex, setIsEditIndex) = React.useState(() => None)

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

    None
  }, (isOpen, currentDirectory, isChapterDir))

  React.useEffect1(() => {
    if !isOpen {
      setValue(_ => "")
    }
    None
  }, [isOpen])

  let handleAdd = event => {
    ReactEvent.Mouse.preventDefault(event)
    onOpen()
  }

  let handleClose = event => {
    ReactEvent.Mouse.preventDefault(event)
    onClose()
  }

  let handleEdit = (event, index) => {
    ReactEvent.Mouse.stopPropagation(event)
    let found = Belt.Array.get(folders, index)
    switch found {
    | Some(found) => {
        onOpen()
        setIsEditIndex(_ => Some(found))
        setValue(_ => found)
      }
    | None => Js.log("Not found")
    }
  }

  let handleDelete = (event, index) => {
    ReactEvent.Mouse.stopPropagation(event)
    let found = Belt.Array.get(folders, index)
    switch found {
    | Some(found) => Js.log(found)
    | None => Js.log("Not found")
    }
  }

  let handleSubmit = event => {
    ReactEvent.Form.preventDefault(event)
    let newPath = `${currentDirectoryPath}/${value}`
    switch isEditIndex {
    | Some(isEditIndex) => {
        let oldPath = `${currentDirectoryPath}/${isEditIndex}`
        DirectoriesApi.renameDirectory(oldPath, newPath)
        setIsEditIndex(_ => None)
      }
    | None => DirectoriesApi.createDirectory(newPath)
    }

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
    if !isChapterDir {
      setCurrentDirectory(prev => Js.Array2.concat(prev, [directory]))
    }
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
      <Breadcrumbs currentDirectory lengthDirectories onBreadcrumbClick={handleBreadcrumbClick} />
    </div>
    <div className="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
      <DirectoriesTable
        folders={folders} onRowClick={handleRowClick} onEdit={handleEdit} onDelete={handleDelete}
      />
    </div>
    <Modal title="Add new directory" isOpen={isOpen} onClose={handleClose}>
      <form onSubmit={handleSubmit}>
        <ModalContent>
          <div className="my-4 text-blueGray-500 text-lg leading-relaxed">
            {if isOpen {
              <Input
                required={true} placeholder="Directory name..." value onChange={handleInputChange}
              />
            } else {
              React.null
            }}
          </div>
        </ModalContent>
        <ModalFooter onClose={handleClose} />
      </form>
    </Modal>
  </>
}
