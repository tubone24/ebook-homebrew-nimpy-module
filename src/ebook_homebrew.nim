import nimpy, ebook_homebrew/submodule

proc status(): string {.exportpy.} =
    return getStatus()

proc list(): string {.exportpy.} =
    return getResultList()

proc convert(directory: string, contentType: string): string {.exportpy.} =
    let uploadId = extractUploadId(uploadImgSeq(listImgFiles(directory), contentType))
    discard convertImg(uploadId, contentType)

proc download(uploadId: string, filename: string): void {.exportpy.} =
    convertPdfDownload(uploadId, filename)

proc all(directory: string, contentType: string, filename: string): void {.exportpy.} =
    echo getStatus()
    echo getResultList()
    let uploadId = extractUploadId(uploadImgSeq(listImgFiles(directory), contentType))
    discard convertImg(uploadId, contentType)
    convertPdfDownload(uploadId, filename)

proc benchBase64Img(directory: string): string {.exportpy.} =
    echo listImgFiles(directory)
