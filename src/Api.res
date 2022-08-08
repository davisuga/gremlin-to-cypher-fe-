open Promise
open Axios

type translationSourceType = Neptune | Cosmos | Tinker
type translationSource = (translationSourceType, string)

@val external backendUrl: string = "import.meta.env.VITE_BACKEND_URL"

let stringOfTranslationSourceType = translationSource => {
  switch translationSource {
  | Neptune => "neptune"
  | Cosmos => "cosmos"
  | Tinker => "tinker"
  }
}

let translationSourceTypeOfString = string => {
  switch string {
  | "neptune" => Neptune
  | "cosmos" => Cosmos
  | "tinker" => Tinker
  | _ => Cosmos
  }
}

let getData = response => response["data"]
let inst = Instance.create(makeConfig(~baseURL=backendUrl, ()))

let translateCypher = (translationSource, cypher): Promise.t<string> => {
  Instance.get(
    inst,
    `/?mode=${stringOfTranslationSourceType(translationSource)}&cypher=${cypher}`,
  )->thenResolve(getData)
}
