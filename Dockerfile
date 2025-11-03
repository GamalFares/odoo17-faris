# Use official Python 3.11 slim image
FROM python:3.11-slim

# Set environment variables
ENV ODOO_HOME=/usr/src/odoo
ENV PATH="$ODOO_HOME/venv/bin:$PATH"

# Create Odoo user
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo

# Set working directory
WORKDIR $ODOO_HOME

# Install system dependencies
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

# Copy files from repo to container
COPY odoo $ODOO_HOME/odoo
COPY odoo-bin $ODOO_HOME/odoo-bin
COPY odoo.conf $ODOO_HOME/odoo.conf
COPY requirements.txt $ODOO_HOME/requirements.txt


# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r $ODOO_HOME/requirements.txt

# Make odoo-bin executable
RUN chmod +x $ODOO_HOME/odoo-bin

# Expose default Odoo port
EXPOSE 8069

# Run Odoo
CMD ["python3", "/usr/src/odoo/odoo-bin", "-c", "/usr/src/odoo/odoo.conf"]

