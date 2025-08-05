#!/bin/sh
set -e

host="$1"
shift

until mysqladmin ping -h"$host" --silent; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing command"
exec "$@"
