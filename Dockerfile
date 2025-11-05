# Base image
FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    libffi-dev \
    wget \
    curl \
    git \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Add Odoo user
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo

# Working directory
WORKDIR /usr/src/odoo

# Copy source code
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# Set permissions
RUN chmod +x /usr/src/odoo/odoo-bin

# Create virtualenv and install Python packages
RUN python3 -m venv /usr/src/odoo/venv \
    && /usr/src/odoo/venv/bin/pip install --upgrade pip \
    && /usr/src/odoo/venv/bin/pip install -r /usr/src/odoo/requirements.txt

# Expose ports
EXPOSE 8069 8072

# Run Odoo in worker mode
CMD ["/usr/src/odoo/venv/bin/python3", "/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
