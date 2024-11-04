#!/bin/bash

cp .env.template .env
docker rm alertmanager
docker compose up --build