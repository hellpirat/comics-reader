@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <MainLayout>
    {switch url.path {
    | list{} => <Directories />
    | list{"comics", comicsId, chapterId} => <Comics comicsId chapterId />
    | _ => <div> {"Not Found"->React.string} </div>
    }}
  </MainLayout>
}
