@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <MainLayout>
    {switch url.path {
    | list{} => <Directories />
    | list{mangaId} => <Directories />
    | list{mangaId, chapterId} => <Directories />
    | _ => <div> {"Not Found"->React.string} </div>
    }}
  </MainLayout>
}
