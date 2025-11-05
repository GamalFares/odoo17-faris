# Use official Python 3.11 slim image
FROM python:3.11-slim

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ODOO_HOME=/usr/src/odoo

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
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

# Set working directory
WORKDIR $ODOO_HOME

# Copy Odoo source
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# Set permissions
RUN chmod +x /usr/src/odoo/odoo-bin

# Create virtual environment and install Python dependencies
RUN python3 -m venv $ODOO_HOME/venv \
    && $ODOO_HOME/venv/bin/pip install --upgrade pip \
    && $ODOO_HOME/venv/bin/pip install -r /usr/src/odoo/requirements.txt

# Expose Odoo port for Render
EXPOSE 8080

# Run Odoo
CMD ["/usr/src/odoo/venv/bin/python3", "/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
