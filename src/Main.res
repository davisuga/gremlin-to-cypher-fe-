let client = ReactQuery.Provider.createClient()

ReactDOM.render(
  <React.StrictMode>
    <ReactQuery.Provider client> <App /> </ReactQuery.Provider>
  </React.StrictMode>,
  ReactDOM.querySelector("#root")->Belt.Option.getExn,
)
