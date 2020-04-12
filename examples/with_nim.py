import ebook_homebrew


def main():
    print(ebook_homebrew.status())
    print(ebook_homebrew.list())
    upload_id = ebook_homebrew.convert("test_files", "image/jpeg")
    print(upload_id)
    ebook_homebrew.download(upload_id, "result.pdf")


def main2():
    ebook_homebrew.all("test_files", "image/jpeg", "result.pdf")


if __name__ == "__main__":
    main2()
