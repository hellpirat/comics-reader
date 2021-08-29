open FoldersApi

@react.component
let make = () => {
  // let (folders, setFolders) = React.useState((_): array<string> => [])

  // React.useEffect(() => {
  //   setFolders(_) => FolderApi.getDirectories("./manga"))
  // })
  let (count, setCount) = React.useState(() => 0)
  let folders = FolderApi.getDirectories("./manga")
  Js.log(folders)

  <div className="flex">
    <Header />
    <button type_="button" onClick={_ => setCount(prev => prev + 1)}> {React.int(count)} </button>
  </div>
}
