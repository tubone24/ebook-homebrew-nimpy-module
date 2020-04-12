from benchmarker import Benchmarker
import requests
import ebook_homebrew
import without_nim

# warmup
requests.get("https://ebook-homebrew.herokuapp.com/status")

with Benchmarker(10, width=20) as bench:
    @bench("nim")
    def _(bm):
        ebook_homebrew.benchBase64Img("test_files")

    @bench("without_nim")
    def _(bm):
        without_nim.create_imageb64_list("test_files", "jpg")
