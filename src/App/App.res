@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  <MainLayout>
    {switch url.path {
    | list{} => <Directories />
    | _ => <div> {"Not Found"->React.string} </div>
    }}
  </MainLayout>
}
