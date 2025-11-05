FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    git build-essential wget curl python3-dev libxml2-dev libxslt1-dev \
    libjpeg-dev libpq-dev libsasl2-dev libldap2-dev libssl-dev \
    libffi-dev liblcms2-dev libblas-dev liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy Odoo source
COPY odoo /usr/src/odoo
WORKDIR /usr/src/odoo

# Copy Python requirements
COPY requirements.txt /usr/src/odoo/
RUN python3 -m pip install --upgrade pip && python3 -m pip install -r requirements.txt

# Create Odoo user
RUN useradd -m -d /var/lib/odoo -U -r -s /bin/bash odoo

# Entry point
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R odoo:odoo /usr/src/odoo

EXPOSE 8069
USER odoo
CMD ["./odoo-bin", "-c", "/etc/odoo/odoo.conf"]