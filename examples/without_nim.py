import json
import os
import glob
import base64
import requests


def upload():
    images_b64 = _create_imageb64_list("test_files", "jpg")
    data = json.dumps({"contentType": "image/jpeg", "images": images_b64})
    r = requests.post("https://ebook-homebrew.herokuapp.com/data/upload", data=data).json()
    upload_id = r["upload_id"]
    data = json.dumps({"uploadId": upload_id, "contentType": "image/jpeg"})
    r = requests.post("https://ebook-homebrew.herokuapp.com/convert/pdf", data=data).json()
    print("upload_id: {}".format(r["upload_id"]))
    return upload_id


def download(upload_id):
    data = json.dumps({"uploadId": upload_id})
    r = requests.post("https://ebook-homebrew.herokuapp.com/convert/pdf/download", data=data)
    if r.status_code == requests.codes.ok:
        with open("result.pdf", "wb") as result_file:
            result_file.write(r.content)
    else:
        print("Convert Running....")
        download(upload_id)


def status():
    r = requests.get("https://ebook-homebrew.herokuapp.com/status").json()
    print(r)


def list():
    r = requests.get("https://ebook-homebrew.herokuapp.com/data/upload/list").json()
    print(r)


def _create_imageb64_list(directory, extension):
    images_b64 = []
    images = glob.glob(os.path.join(directory, "*." + extension))
    for image in images:
        with open(image, "rb") as image_binary:
            images_b64.append(base64.b64encode(image_binary.read()).decode("utf-8"))
    return images_b64


if __name__ == "__main__":
    status()
    list()
    upload_id = upload()
    download(upload_id)
