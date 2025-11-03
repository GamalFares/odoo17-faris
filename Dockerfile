# -------------------------------
# Base image
# -------------------------------
FROM python:3.11-slim

# -------------------------------
# Environment variables
# -------------------------------
ENV ODOO_HOME=/usr/src/odoo
ENV PYTHONUNBUFFERED=1
ENV PATH="$ODOO_HOME:$PATH"

# -------------------------------
# Install system dependencies
# -------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        g++ \
        libxml2-dev \
        libxslt-dev \
        libpq-dev \
        libjpeg-dev \
        zlib1g-dev \
        libffi-dev \
        curl \
        git \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Create Odoo user
# -------------------------------
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR $ODOO_HOME

# -------------------------------
# Copy files from repo to container
# -------------------------------
# Copy the full Odoo source
COPY odoo $ODOO_HOME/odoo

# Copy odoo-bin if it exists (adjust path if in root)
COPY odoo/odoo-bin $ODOO_HOME/odoo-bin
COPY odoo/odoo.conf $ODOO_HOME/odoo.conf

# Copy requirements
COPY requirements.txt $ODOO_HOME/requirements.txt

# -------------------------------
# Make odoo-bin executable
# -------------------------------
RUN chmod +x $ODOO_HOME/odoo-bin

# -------------------------------
# Install Python dependencies
# -------------------------------
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r $ODOO_HOME/requirements.txt

# -------------------------------
# Switch to Odoo user
# -------------------------------
USER odoo

# -------------------------------
# Expose default Odoo port
# -------------------------------
EXPOSE 8069

# -------------------------------
# Entrypoint
# -------------------------------
CMD ["./odoo-bin", "-c", "odoo.conf"]

