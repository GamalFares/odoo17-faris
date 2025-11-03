FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gcc \
    g++ \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create Odoo user
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo
WORKDIR /usr/src/odoo

# Copy Odoo source and configs
COPY odoo/odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# Make odoo-bin executable
RUN chmod +x /usr/src/odoo/odoo-bin

# Create virtualenv and install Python dependencies
RUN python3 -m venv venv311
RUN /usr/src/odoo/venv311/bin/pip install --upgrade pip
RUN /usr/src/odoo/venv311/bin/pip install --no-cache-dir -r /usr/src/odoo/requirements.txt

# Run Odoo
CMD ["/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]


