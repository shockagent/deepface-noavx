# deepface-noavx

Fork from https://github.com/serengil/deepface

**Face Verification** - [`Demo`](https://youtu.be/KRCvkNCOphE)

Example of base64 encoded images:

```python
result = DeepFace.verify(img1_path = "img1.jpg", img2_path = "img2.jpg")
# or
result = DeepFace.verify(img1_path = "data:image/jpg;base64,/9j/4AA...", img2_path = "data:/jpeg;base64,/9j/4AA...")
```

**API** - [`Demo`](https://youtu.be/HeKCQ6U9XmI)

DeepFace serves an API as well. You can clone [`/api`](https://github.com/serengil/deepface/tree/master/api) folder and run the api via gunicorn server. This will get a rest service up. In this way, you can call deepface from an external system such as mobile app or web.

```shell
cd scripts
./service.sh
```

<p align="center"><img src="https://raw.githubusercontent.com/serengil/deepface/master/icon/deepface-api.jpg" width="90%" height="90%"></p>

Face recognition, facial attribute analysis and vector representation functions are covered in the API. You are expected to call these functions as http post methods. Default service endpoints will be `http://localhost:5000/verify` for face recognition, `http://localhost:5000/analyze` for facial attribute analysis, and `http://localhost:5000/represent` for vector representation. You can pass input images as exact image paths on your environment, base64 encoded strings or images on web. [Here](https://github.com/serengil/deepface/tree/master/api), you can find a postman project to find out how these methods should be called.

Example for 'verify': just send a similar body
```JSON
{
  "img1_path": "data:/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD...",
  "img2_path": "https://images.pexels.com/photos/...",
  "model_name": "VGG-Face",
  "detector_backend": "retinaface",
  "distance_metric": "cosine"
}
```
Remember to set 'Content-type' header to 'application/json'.

**Dockerized Service**

You can deploy the deepface api on a kubernetes cluster with docker. The following [shell script](https://github.com/serengil/deepface/blob/master/scripts/dockerize.sh) will serve deepface on `localhost:5000`. You need to re-configure the [Dockerfile](https://github.com/serengil/deepface/blob/master/Dockerfile) if you want to change the port. Then, even if you do not have a development environment, you will be able to consume deepface services such as verify and analyze. You can also access the inside of the docker image to run deepface related commands. Please follow the instructions in the [shell script](https://github.com/serengil/deepface/blob/master/scripts/dockerize.sh).

```shell
cd scripts
./dockerize.sh
```

<p align="center"><img src="https://raw.githubusercontent.com/serengil/deepface/master/icon/deepface-dockerized-v2.jpg" width="50%" height="50%"></p>

**Command Line Interface**

DeepFace comes with a command line interface as well. You are able to access its functions in command line as shown below. The command deepface expects the function name as 1st argument and function arguments thereafter.

```shell
#face verification
$ deepface verify -img1_path tests/dataset/img1.jpg -img2_path tests/dataset/img2.jpg

#facial analysis
$ deepface analyze -img_path tests/dataset/img1.jpg
```

You can also run these commands if you are running deepface with docker. Please follow the instructions in the [shell script](https://github.com/serengil/deepface/blob/master/scripts/dockerize.sh#L17).
