# Use official slim Python 3.11 image
FROM python:3.11-slim

# Environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    wget \
    curl \
    python3-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg62-turbo-dev \
    libpq-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libffi-dev \
    liblcms2-dev \
    libblas-dev \
    liblapack-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# Create Odoo user
RUN useradd -m -d /var/lib/odoo -U -r -s /bin/bash odoo

# Switch to /usr/src
WORKDIR /usr/src

# Clone Odoo 17 official source
RUN git clone --branch 17.0 --depth 1 https://github.com/odoo/odoo.git odoo

WORKDIR /usr/src/odoo

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && pip install pypdf polib qrcode Pillow xlwt XlsxWriter

# Copy your custom entrypoint if you have one
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown -R odoo:odoo /usr/src/odoo /entrypoint.sh

# Expose Odoo default port
EXPOSE 8069

# Switch to Odoo user
USER odoo

# Start Odoo
CMD ["/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]