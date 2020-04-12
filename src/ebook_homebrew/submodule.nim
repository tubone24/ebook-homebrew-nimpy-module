import httpclient, base64, os, lists, json, strutils

const url = "https://ebook-homebrew.herokuapp.com/"

proc getStatus*(): string =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })
  let response = client.get(url & "status")
  return response.body

proc convertBase64*(filePath: string): string =
  block:
    let f : File = open(filePath , FileMode.fmRead)
    defer :
      close(f)
      echo "closed"
    return encode(f.readAll())

proc listImgFile*(filePath: string): seq[string] =
  var path = newSeq[string]()
  for f in walkDir(filePath):
    path.add(f.path)
  return path

proc listImgFiles*(filePath: string): seq[string] =
  var base64seq = newSeq[string]()
  for f in listImgFile(filePath):
    base64seq.add(convertBase64(f))
  return base64seq

proc uploadImgSeq*(imgSeq: seq[string], contentType: string): string =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })
  let body = %* {"contentType": contentType, "images": imgSeq}
  let response = client.request(url & "data/upload", httpMethod = HttpPost, body = $body)
  return response.body

proc convertImg*(uploadId: string, contentType: string): string =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })
  let body = %* {"contentType": contentType, "uploadId": uploadId}
  let response = client.request(url & "convert/pdf", httpMethod = HttpPost, body = $body)
  return response.body

proc convertPdfDownload*(uploadId: string, filename: string): void =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })
  let body = %* {"uploadId": uploadId}
  let response = client.request(url & "convert/pdf/download", httpMethod = HttpPost, body = $body)
  if response.status == "404 Not Found":
      echo "convert running..."
      sleep(1000)
      convertPdfDownload(uploadId, filename)
  elif response.status == "200 OK":
      block:
        let f : File = open(filename, FileMode.fmWrite)
        f.write(response.body)
        defer :
          close(f)
          echo "file write"
  else:
      echo response.status

proc extractUploadId*(jsonStr: string): string =
  return parseJson(jsonStr)["upload_id"].getStr()

proc getResultList*(): string =
  let client = newHttpClient()
  client.headers = newHttpHeaders({ "Content-Type": "application/json" })
  let response = client.get(url & "data/upload/list")
  return response.body
