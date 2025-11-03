# ==========================================================
# Odoo 17.0 Custom Dockerfile for Render Deployment
# ==========================================================

# 1️⃣ Base image
FROM python:3.11-slim

# 2️⃣ Environment variables
ENV ODOO_HOME=/usr/src/odoo \
    PATH="$ODOO_HOME:$PATH"

# 3️⃣ System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    gcc \
    g++ \
    libpq-dev \
    libsasl2-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libssl-dev \
    python3-dev \
    python3-venv \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 4️⃣ Create odoo user and working directory
RUN useradd -m -d $ODOO_HOME -s /bin/bash odoo
WORKDIR $ODOO_HOME

# 5️⃣ Copy Odoo source and dependencies
COPY odoo $ODOO_HOME/odoo
COPY requirements.txt $ODOO_HOME/requirements.txt
COPY odoo.conf /etc/odoo/odoo.conf
COPY odoo-bin $ODOO_HOME/odoo-bin

# 6️⃣ Permissions
RUN chmod +x $ODOO_HOME/odoo-bin && chown -R odoo:odoo $ODOO_HOME

# 7️⃣ Install Python packages
RUN pip install --upgrade pip && \
    pip install -r $ODOO_HOME/requirements.txt

# 8️⃣ Expose Odoo port
EXPOSE 8069

# 9️⃣ Switch to odoo user
USER odoo

# 🔟 Default command to start Odoo
CMD ["./odoo-bin", "-c", "/etc/odoo/odoo.conf"]

