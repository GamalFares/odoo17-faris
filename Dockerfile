# -------------------------------
# Base image
# -------------------------------
FROM python:3.11-slim

# -------------------------------
# Environment variables
# -------------------------------
ENV ODOO_HOME=/usr/src/odoo
ENV PATH=$ODOO_HOME:$PATH

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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Create Odoo user
# -------------------------------
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

WORKDIR $ODOO_HOME

# -------------------------------
# Copy project files
# -------------------------------
COPY requirements.txt $ODOO_HOME/requirements.txt
COPY odoo $ODOO_HOME/odoo
COPY odoo-bin $ODOO_HOME/odoo-bin
COPY odoo.conf $ODOO_HOME/odoo.conf

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
# Expose Odoo port
# -------------------------------
EXPOSE 8069

# -------------------------------
# Start Odoo
# -------------------------------
CMD ["./odoo-bin", "-c", "odoo.conf"]


