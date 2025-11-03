# === Base image ===
FROM python:3.11-slim

# === Set environment variables ===
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ODOO_HOME=/usr/src/odoo \
    PATH="/usr/src/odoo/venv/bin:$PATH"

# === Install system dependencies ===
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

# === Create odoo user ===
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo

# === Set working directory ===
WORKDIR /usr/src/odoo

# === Copy Odoo source and configs ===
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt /usr/src/odoo/requirements.txt

# === Make odoo-bin executable ===
RUN chmod +x /usr/src/odoo/odoo-bin

# === Create virtual environment and install Python dependencies ===
RUN python3 -m venv /usr/src/odoo/venv \
    && /usr/src/odoo/venv/bin/pip install --upgrade pip \
    && /usr/src/odoo/venv/bin/pip install -r /usr/src/odoo/requirements.txt

# === Set the container user ===
USER odoo

# === Default command to run Odoo ===
CMD ["/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]


