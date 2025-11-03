# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV ODOO_RC=/etc/odoo.conf

# Create work directory
WORKDIR /usr/src/odoo

# Copy Odoo source
COPY ./odoo /usr/src/odoo

# Copy configuration
COPY ./odoo.conf /etc/odoo.conf

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libtiff5-dev \
    libjpeg62-turbo-dev \
    libopenjp2-7-dev \
    liblcms2-dev \
    libwebp-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxcb1-dev \
    python3-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies manually (since no requirements.txt)
RUN pip install --upgrade pip \
    && pip install setuptools wheel \
    && pip install \
        psycopg2-binary \
        babel \
        decorator \
        docutils \
        ebaysdk \
        feedparser \
        gevent \
        greenlet \
        Jinja2 \
        lxml \
        MarkupSafe \
        passlib \
        Pillow \
        psutil \
        pydot \
        pyparsing \
        PyPDF2 \
        reportlab \
        requests \
        six \
        xlrd \
        XlsxWriter \
        polib \
        werkzeug

# Make odoo-bin executable (important)
RUN chmod +x /usr/src/odoo/odoo-bin

# Expose Odoo port
EXPOSE 8069

# Default command
CMD ["python3", "/usr/src/odoo/odoo-bin", "-c", "/etc/odoo.conf"]
