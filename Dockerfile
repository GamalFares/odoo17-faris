# Use official Python base image
FROM python:3.11-slim

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/usr/src/odoo

# Install system dependencies
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

# Create Odoo user
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo

# Set working directory
WORKDIR /usr/src/odoo

# Copy Odoo source code
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# Give execution permission to odoo-bin
RUN chmod +x /usr/src/odoo/odoo-bin

# Create virtualenv and install Python requirements
RUN python3 -m venv /usr/src/odoo/venv \
    && /usr/src/odoo/venv/bin/pip install --upgrade pip \
    && /usr/src/odoo/venv/bin/pip install -r /usr/src/odoo/requirements.txt

# Change ownership to odoo user
RUN chown -R odoo:odoo /usr/src/odoo /etc/odoo

# Switch to odoo user
USER odoo

# Set workdir again for user context
WORKDIR /usr/src/odoo

# Run Odoo using venv python
CMD ["/usr/src/odoo/venv/bin/python", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]
