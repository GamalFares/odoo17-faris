# Use official Python slim image
FROM python:3.11-slim

# -------------------------------
# Set environment variables
# -------------------------------
ENV ODOO_HOME=/usr/src/odoo
ENV PATH=$ODOO_HOME/venv/bin:$PATH

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
# Copy Odoo source and config
# -------------------------------
COPY odoo $ODOO_HOME/odoo
COPY odoo/odoo-bin $ODOO_HOME/odoo-bin
COPY odoo/odoo.conf $ODOO_HOME/odoo.conf
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

# Install Odoo as editable package
RUN pip install -e $ODOO_HOME/odoo

# -------------------------------
# Expose Odoo port
# -------------------------------
EXPOSE 8069

# -------------------------------
# Run Odoo
# -------------------------------
USER odoo
CMD ["./odoo-bin", "-c", "odoo.conf"]

