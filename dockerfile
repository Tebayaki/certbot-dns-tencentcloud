FROM python:3.10-alpine

WORKDIR /app

COPY app /app

RUN pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

ENV SECRET_ID=
ENV SECRET_KEY=
ENV REGION=
ENV DOMAINS=
ENV EMAIL=
ENV DRY_RUN=
ENV CRON_SCHEDULE=
ENV TZ=Asia/Shanghai
ENV PYTHONUNBUFFERED=1

CMD ["python", "entrypoint.py"]