# ==========================
#  Odoo 17 Dockerfile
# ==========================

FROM python:3.11-slim

# Environment variables
ENV ODOO_HOME=/usr/src/odoo
ENV PATH="$ODOO_HOME:$PATH"

# === System dependencies ===
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

# === Create Odoo user ===
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

# === Set working directory ===
WORKDIR $ODOO_HOME

# === Copy source code ===
COPY odoo $ODOO_HOME/odoo
COPY odoo/odoo-bin $ODOO_HOME/odoo-bin
COPY requirements.txt $ODOO_HOME/requirements.txt
COPY odoo.conf /etc/odoo/odoo.conf

# === Install dependencies ===
RUN pip install --upgrade pip && pip install -r $ODOO_HOME/requirements.txt

# === Expose Odoo port ===
EXPOSE 8069

# === Run Odoo ===
USER odoo
CMD ["python3", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]

