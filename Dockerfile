# Use the official Odoo 17 image
FROM odoo:17.0

# Copy custom addons if you have any
COPY odoo /mnt/extra-addons

# Copy Odoo configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Set environment variable for Odoo configuration
ENV ODOO_RC=/etc/odoo/odoo.conf

# Expose ports
EXPOSE 8069 8072

# Start Odoo
CMD ["odoo"]
