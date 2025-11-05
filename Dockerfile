# Use official Python slim image
FROM python:3.11-slim

# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH="/usr/src/odoo/venv/bin:$PATH"

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

# Create Odoo user
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo

# Set working directory
WORKDIR /usr/src/odoo

# Copy Odoo source
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# Make odoo-bin executable
RUN chmod +x /usr/src/odoo/odoo-bin

# Create Python virtual environment and install dependencies
RUN python3 -m venv /usr/src/odoo/venv \
    && /usr/src/odoo/venv/bin/pip install --upgrade pip \
    && /usr/src/odoo/venv/bin/pip install -r /usr/src/odoo/requirements.txt

# Expose Odoo port
EXPOSE 8069

# Run Odoo
CMD ["/usr/src/odoo/venv/bin/python", "/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
