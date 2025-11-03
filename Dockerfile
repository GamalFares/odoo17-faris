# -------------------------------
# Base image
# -------------------------------
FROM python:3.11-slim

# -------------------------------
# Environment variables
# -------------------------------
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED 1

# -------------------------------
# Create Odoo user
# -------------------------------
RUN useradd -m -d /home/odoo -s /bin/bash odoo

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR /usr/src/odoo

# -------------------------------
# Copy project files into container
# -------------------------------
COPY . /usr/src/odoo

# -------------------------------
# Upgrade pip and install dependencies
# -------------------------------
RUN pip install --upgrade pip
RUN pip install -r /usr/src/odoo/requirements.txt

# -------------------------------
# Make odoo-bin executable
# -------------------------------
RUN chmod +x /usr/src/odoo/odoo-bin

# -------------------------------
# Expose Odoo port
# -------------------------------
EXPOSE 8069

# -------------------------------
# Use non-root user
# -------------------------------
USER odoo

# -------------------------------
# Start Odoo
# -------------------------------
CMD ["python3", "/usr/src/odoo/odoo-bin", "-c", "/usr/src/odoo/odoo.conf"]
