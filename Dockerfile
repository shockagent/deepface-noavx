#base image
FROM python:3.8
LABEL org.opencontainers.image.source https://github.com/serengil/deepface

ARG TF_URL="https://github.com/shockagent/tensorflow-noavx/releases/download/v2.13.1-cp38-cp38-linux_x86_64/tensorflow-2.13.1-cp38-cp38-linux_x86_64.whl"
# -----------------------------------
SHELL ["/bin/bash", "-c"]
# -----------------------------------
# switch to application directory
WORKDIR /app/
# -----------------------------------
# Copy required files from repo into image
COPY ./deepface ./api/app.py ./api/api.py ./api/routes.py ./api/service.py ./requirements.txt ./setup.py ./README.md ./
# -----------------------------------
# update image os
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1 libsm6 libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# -----------------------------------
# if you will use gpu, then you should install tensorflow-gpu package
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org tensorflow-gpu
# -----------------------------------
# install deepface from pypi release (might be out-of-the-date)
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org deepface
# -----------------------------------
# install deepface from source code (always up-to-date)
#RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org -e .
RUN pip install --upgrade pip && wget $TF_URL && pip install $(basename $TF_URL) deepface Deprecated
# -----------------------------------
# some packages are optional in deepface. activate if your task depends on one.
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org cmake==3.24.1.1
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org dlib==19.20.0
# RUN pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host=files.pythonhosted.org lightgbm==2.3.1
# -----------------------------------
# environment variables
ENV PYTHONUNBUFFERED=1
# -----------------------------------

RUN pip cache purge && rm $(basename $TF_URL)
# run the app (re-configure port if necessary)
EXPOSE 5000
CMD ["gunicorn", "--workers=1", "--timeout=3600", "--bind=0.0.0.0:5000", "app:create_app()"]