

@react.component
let make = () => {
  <header className="App-header">
    <p>
      {React.string("Edit")}
      <code> {React.string("src/App.js")} </code>
      {React.string("and save to reload.")}
    </p>
    <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">
      {React.string("Learn React")}
    </a>
  </header>
}