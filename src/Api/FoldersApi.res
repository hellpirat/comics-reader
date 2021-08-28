

module FolderApi = {

    let getDirectories = () => {
        let mangas = FS.readdirSync("./manga")
        mangas
    }
}


 