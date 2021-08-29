type result = {
  value: bool,
  toggle: unit => unit,
  onOpen: unit => unit,
  onClose: unit => unit,
}

let useToggle = () => {
  let (state, setState) = React.useState(() => false)

  let toggle = () => {
    setState(prev => !prev)
  }

  let onOpen = () => {
    setState(_ => true)
  }

  let onClose = () => {
    setState(_ => false)
  }

  {value: state, toggle: toggle, onOpen: onOpen, onClose: onClose}
}
