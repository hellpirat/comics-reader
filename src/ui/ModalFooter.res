@react.component
let make = (~onClose) => {
  <div
    className="flex items-center justify-end p-6 border-t border-solid border-blueGray-200 rounded-b">
    <Button onClick={onClose} variant={#danger}> {"Close"->React.string} </Button>
    <Button type_={#submit} variant={#success}> {"Save"->React.string} </Button>
  </div>
}
