# Stage 1: Build environment for additional tools/extensions
FROM postgres:14 AS builder

# Install additional tools or dependencies (e.g., PostGIS, pg_cron, pg_partman)
RUN apt-get update && apt-get install -y \
    postgresql-14-postgis-3 \
    postgresql-14-cron \
    postgresql-14-pg-partman \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Final image with PostgreSQL and customizations
FROM postgres:14

# Set environment variables
ENV POSTGRES_USER=custom_user \
    POSTGRES_PASSWORD=custom_password \
    POSTGRES_DB=custom_database

# Copy tools/extensions from the builder stage
COPY --from=builder /usr/lib/postgresql/14/lib/postgis-3.so /usr/lib/postgresql/14/lib/

# Copy custom configuration files
COPY ./config/postgresql.conf /etc/postgresql/postgresql.conf
COPY ./config/pg_hba.conf /etc/postgresql/pg_hba.conf

# Set the custom configuration to load on startup
RUN echo "include '/etc/postgresql/postgresql.conf'" >> /usr/share/postgresql/postgresql.conf.sample

# Copy initialization scripts
COPY ./init/ /docker-entrypoint-initdb.d/

# Add backup, monitoring, and maintenance scripts
COPY ./scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

# Install monitoring tools (e.g., pg_monitor, Prometheus exporter)
RUN apt-get update && apt-get install -y \
    postgresql-14-pgmonitor \
    prometheus-postgres-exporter \
    && rm -rf /var/lib/apt/lists/*

# Health check to ensure the container is healthy
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s CMD pg_isready -U $POSTGRES_USER || exit 1

# Entry point
CMD ["postgres"]
