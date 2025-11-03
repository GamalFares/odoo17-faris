# Use official Python 3.11 slim image
FROM python:3.11-slim

# === Set environment variables ===
ENV ODOO_HOME=/usr/src/odoo
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# === Install system dependencies ===
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
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# === Create Odoo user ===
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

# === Set working directory ===
WORKDIR $ODOO_HOME

# === Copy Odoo source files ===
COPY odoo $ODOO_HOME/odoo
COPY odoo-bin $ODOO_HOME/odoo-bin
COPY odoo.conf /etc/odoo/odoo.conf
COPY requirements.txt $ODOO_HOME/requirements.txt

# Make odoo-bin executable
RUN chmod +x $ODOO_HOME/odoo-bin

# === Create Python virtual environment and install dependencies ===
RUN python3 -m venv $ODOO_HOME/venv \
    && $ODOO_HOME/venv/bin/pip install --upgrade pip \
    && $ODOO_HOME/venv/bin/pip install -r $ODOO_HOME/requirements.txt

# === Set PATH to include virtualenv binaries ===
ENV PATH="$ODOO_HOME/venv/bin:$PATH"

# === Expose default Odoo port ===
EXPOSE 8069

# === Run Odoo ===
CMD ["odoo-bin", "-c", "/etc/odoo/odoo.conf"]



