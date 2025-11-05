#!/bin/bash
set -e

echo "🚀 Starting Odoo..."

# Wait for the database to be ready
if [ -n "$ODOO_DB_HOST" ]; then
  echo "⏳ Waiting for PostgreSQL at $ODOO_DB_HOST:$ODOO_DB_PORT..."
  until pg_isready -h "$ODOO_DB_HOST" -p "$ODOO_DB_PORT" -U "$ODOO_DB_USER"; do
    sleep 2
  done
  echo "✅ Database ready!"
fi

# Start Odoo
exec python3 /usr/src/odoo/odoo/odoo-bin -c /etc/odoo/odoo.conf
