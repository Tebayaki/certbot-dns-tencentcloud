FROM python:3.10-alpine

WORKDIR /app

COPY app /app

RUN pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

ENV TZ=Asia/Shanghai
ENV PYTHONUNBUFFERED=1

CMD ["python", "entrypoint.py"]