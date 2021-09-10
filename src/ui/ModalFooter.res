@react.component
let make = (~onClose, ~okText="Save") => {
  <div
    className="flex items-center justify-end p-6 border-t border-solid border-blueGray-200 rounded-b">
    <Button onClick={onClose} variant={#danger}> {"Close"->React.string} </Button>
    <Button type_={#submit} variant={#success}> {okText->React.string} </Button>
  </div>
}
