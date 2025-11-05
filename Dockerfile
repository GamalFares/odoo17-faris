FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git build-essential wget curl python3-dev libxml2-dev libxslt1-dev \
    libjpeg-dev libpq-dev libsasl2-dev libldap2-dev libssl-dev \
    libffi-dev liblcms2-dev libblas-dev libjpeg62-turbo-dev liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/odoo

# Copy and install Python dependencies first (to use Docker layer caching)
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the Odoo source code
COPY . .

# Create odoo user
RUN useradd -m -d /var/lib/odoo -U -r -s /bin/bash odoo

# Set permissions and entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R odoo:odoo /usr/src/odoo

EXPOSE 8069
USER odoo
CMD ["./odoo-bin", "-c", "/etc/odoo/odoo.conf"]
