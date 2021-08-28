open FoldersApi

@react.component
let make = () => {
    let (count, setCount) = React.useState(() => 0)
    let folders = FolderApi.getDirectories()
    Js.log(folders)

    <div>
        <Header />
        <button type_="button" onClick={(_) => setCount(prev => prev + 1)}>
            {React.int(count)}
        </button>
    </div>
}
