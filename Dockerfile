# ------------------------------------------------------------
# ✅ Base image
# ------------------------------------------------------------
FROM python:3.11-slim

# Environment setup
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV ODOO_VERSION=17.0

# ------------------------------------------------------------
# ✅ System dependencies
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git build-essential wget curl python3-dev libxml2-dev libxslt1-dev \
    libjpeg-dev libpq-dev libsasl2-dev libldap2-dev libssl-dev \
    libffi-dev libjpeg62-turbo-dev liblcms2-dev libblas-dev libatlas3-base \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# ✅ Create odoo user and directory
# ------------------------------------------------------------
RUN useradd -m -d /usr/src/odoo -s /bin/bash odoo
WORKDIR /usr/src/odoo

# ------------------------------------------------------------
# ✅ Clone Odoo 17 source
# ------------------------------------------------------------
RUN git clone --depth=1 --branch ${ODOO_VERSION} https://github.com/odoo/odoo.git /usr/src/odoo/odoo

# ------------------------------------------------------------
# ✅ Copy configuration, entrypoint, and requirements
# ------------------------------------------------------------
COPY ./odoo.conf /etc/odoo/odoo.conf
COPY ./entrypoint.sh /entrypoint.sh
COPY ./requirements.txt /tmp/requirements.txt

# ------------------------------------------------------------
# ✅ Install Python dependencies
# ------------------------------------------------------------
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r /tmp/requirements.txt

# ------------------------------------------------------------
# ✅ Permissions and entrypoint
# ------------------------------------------------------------
RUN chmod +x /entrypoint.sh && chown -R odoo:odoo /usr/src/odoo
USER odoo

# ------------------------------------------------------------
# ✅ Expose port and start Odoo
# ------------------------------------------------------------
EXPOSE 8069
ENTRYPOINT ["/entrypoint.sh"]
