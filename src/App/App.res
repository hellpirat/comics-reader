@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <MainLayout>
    {switch url.path {
    | list{} => <Folders />
    | _ => <div> {"Not Found"->React.string} </div>
    }}
  </MainLayout>
}
