# -------------------------------
# Base image
# -------------------------------
FROM python:3.11-slim

# -------------------------------
# Set environment variables
# -------------------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# -------------------------------
# Install system dependencies
# -------------------------------
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    git \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libffi-dev \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR /usr/src/odoo

# -------------------------------
# Copy the entire project
# -------------------------------
COPY . /usr/src/odoo

# -------------------------------
# Upgrade pip and install Python dependencies
# -------------------------------
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# -------------------------------
# Make odoo-bin executable
# -------------------------------
RUN chmod +x odoo-bin

# -------------------------------
# Expose Odoo port
# -------------------------------
EXPOSE 8069

# -------------------------------
# Command to run Odoo
# -------------------------------
CMD ["python3", "odoo-bin", "-c", "odoo.conf"]

