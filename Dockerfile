# Base image
FROM python:3.10-slim

# Environment setup
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV ODOO_HOME=/usr/src/odoo

# Create working directory
WORKDIR ${ODOO_HOME}

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential wget curl python3-dev libxml2-dev libxslt1-dev \
    libjpeg-dev libpq-dev libsasl2-dev libldap2-dev libssl-dev \
    libffi-dev libjpeg8-dev liblcms2-dev libblas-dev libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Odoo source (change branch for your version)
RUN git clone --depth=1 --branch 17.0 https://github.com/odoo/odoo.git ${ODOO_HOME}

# Copy config and scripts
COPY ./odoo.conf /etc/odoo/odoo.conf
COPY ./entrypoint.sh /entrypoint.sh
COPY ./requirements.txt /tmp/requirements.txt

# Install Python packages
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r /tmp/requirements.txt

# Fix permissions
RUN chmod +x /entrypoint.sh

# Expose Odoo port
EXPOSE 8069

# Default entrypoint
ENTRYPOINT ["/entrypoint.sh"]
