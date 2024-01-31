FROM python:3.10-alpine as build

# bash is needed for the build
RUN apk update && apk add --no-cache bash
RUN pip3 install --no-cache-dir pipenv

WORKDIR /src

COPY . .

RUN python3 -m venv venv \
  && . venv/bin/activate \
  && pipenv install --dev \
  && pipenv run build


FROM python:3.10-alpine as app

WORKDIR /app

COPY --from=build /src/dist/smartmeter_datacollector-*.whl /app

RUN pip install --no-cache-dir /app/smartmeter_datacollector-*.whl

CMD ["smartmeter-datacollector", "--config", "/app/datacollector.ini"]
