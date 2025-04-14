#!/bin/bash
set -e

# 💥 Elimina el archivo que impide que Rails inicie
rm -f /usr/src/app/tmp/pids/server.pid

# 🔁 Continúa con el comando que se le pasa al contenedor (ej. rails server)
exec "$@"
