# -------------------------------
# Base image
# -------------------------------
FROM python:3.11-slim

# -------------------------------
# Environment variables
# -------------------------------
ENV ODOO_HOME=/usr/src/odoo
ENV PATH="$ODOO_HOME/venv311/bin:$PATH"

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
# Copy source files
# -------------------------------
COPY odoo $ODOO_HOME/odoo
COPY odoo-bin $ODOO_HOME/odoo-bin
COPY odoo.conf $ODOO_HOME/odoo.conf
COPY requirements.txt $ODOO_HOME/requirements.txt

# -------------------------------
# Make odoo-bin executable
# -------------------------------
RUN chmod +x $ODOO_HOME/odoo-bin

# -------------------------------
# Create virtual environment and install Python dependencies
# -------------------------------
RUN python -m venv venv311
RUN $ODOO_HOME/venv311/bin/pip install --upgrade pip
RUN $ODOO_HOME/venv311/bin/pip install --no-cache-dir -r $ODOO_HOME/requirements.txt

# -------------------------------
# Set Odoo user
# -------------------------------
USER odoo

# -------------------------------
# Default command
# -------------------------------
CMD ["./odoo-bin", "-c", "odoo.conf"]


