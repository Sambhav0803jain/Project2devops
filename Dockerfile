FROM python
WORKDIR /docker-flast-app
ADD . /docker-flast-app/
RUN pip install -r requirements.txt
CMD ["python","run.py"]
