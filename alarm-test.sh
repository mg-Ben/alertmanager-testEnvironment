#!/bin/bash
. .env
curl -XPOST http://localhost:${ALERTMANAGER_PORT}/api/v2/alerts -H 'Content-type: application/json' -d @alarm.json