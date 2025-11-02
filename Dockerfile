# Use Python 3.11 slim
FROM python:3.11-slim

# Set environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential wget curl libpq-dev \
    libxml2-dev libxslt1-dev libjpeg-dev libldap2-dev libsasl2-dev \
    python3-dev node-less npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /usr/src/odoo

# Copy Odoo source code
COPY ./odoo /usr/src/odoo

# Copy config
COPY ./odoo.conf /etc/odoo.conf

# Install Python packages (from requirements.txt if exists)
RUN pip install --upgrade pip
RUN pip install -r /usr/src/odoo/requirements.txt || true

# Expose Odoo port
EXPOSE 8069

# Start Odoo
CMD ["python3", "odoo-bin", "-c", "/etc/odoo.conf"]
