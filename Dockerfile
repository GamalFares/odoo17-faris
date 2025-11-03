# -------------------------------
# Odoo 17 Dockerfile
# -------------------------------

# Base image
FROM python:3.11-slim

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    ODOO_USER=odoo \
    ODOO_HOME=/usr/src/odoo

# Create a non-root user
RUN useradd -m -d $ODOO_HOME -s /bin/bash $ODOO_USER

# Set working directory
WORKDIR $ODOO_HOME

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
# Copy requirements and install
# -------------------------------
COPY requirements.txt $ODOO_HOME/requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r $ODOO_HOME/requirements.txt

# -------------------------------
# Copy the rest of the project
# -------------------------------
COPY . $ODOO_HOME

# Make odoo-bin executable
RUN chmod +x $ODOO_HOME/odoo-bin

# Set permissions for non-root user
RUN chown -R $ODOO_USER:$ODOO_USER $ODOO_HOME

# Switch to non-root user
USER $ODOO_USER

# Expose default Odoo port
EXPOSE 8069

# Default command
CMD ["python", "odoo-bin", "-c", "odoo.conf"]

