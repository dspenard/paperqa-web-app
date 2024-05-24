FROM python:3.10-slim-bullseye

# Set working directory and copy files
WORKDIR /app

# Install requirements
RUN apt-get update && \
    apt-get install curl gcc python3-dev --no-install-recommends -y

ENV POETRY_VIRTUALENVS_CREATE=false \
    PATH="/root/.local/bin:$PATH"

RUN curl -sSL https://install.python-poetry.org | python3 -
# RUN poetry cache clear --all

COPY pyproject.toml /app

# RUN poetry env remove python
RUN rm -f poetry.lock
RUN poetry lock --no-update
COPY poetry.lock /app
RUN poetry install

COPY paperqa/ /app/paperqa
COPY src/ /app/src
COPY app.py /app

# Set the entrypoint and allow additional CLI arguments to be passed
CMD ["printenv"]
ENTRYPOINT ["streamlit", "run", "app.py"]
