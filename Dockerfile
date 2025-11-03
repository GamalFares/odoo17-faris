# === Base Image ===
FROM python:3.11-slim

# === System Dependencies ===
RUN apt-get update && apt-get install -y \
    git \
    curl \
    gcc \
    g++ \
    libpq-dev \
    libsasl2-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libssl-dev \
    python3-dev \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# === Create odoo user ===
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo

WORKDIR /usr/src/odoo

# === Copy Odoo source ===
COPY odoo /usr/src/odoo/odoo
COPY odoo-bin /usr/src/odoo/odoo-bin
COPY requirements.txt /usr/src/odoo/requirements.txt
COPY odoo.conf /etc/odoo/odoo.conf

# === Permissions ===
RUN chmod +x /usr/src/odoo/odoo-bin
RUN chown -R odoo:odoo /usr/src/odoo

# === Virtual Env ===
RUN python -m venv /usr/src/odoo/venv311
RUN /usr/src/odoo/venv311/bin/pip install --upgrade pip
RUN /usr/src/odoo/venv311/bin/pip install -r /usr/src/odoo/requirements.txt

USER odoo

EXPOSE 8069

# === Default Command ===
CMD ["/usr/src/odoo/venv311/bin/python", "/usr/src/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]
