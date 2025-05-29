FROM maven:3.9-eclipse-temurin-21 AS builder

# Install Node.js (v20)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v

# Copy source files needed for building the theme
WORKDIR /build
COPY . .

# Run the build
RUN npm install && npm run build-keycloak-theme

# Stage 2: Final Keycloak image
FROM quay.io/keycloak/keycloak:26.2.2

# Copy the JAR from the build stage
COPY --from=builder /build/dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar /opt/keycloak/providers/

# Optionally copy other provider jars
COPY ./keycloak-md5crypt-1.0.1.jar /opt/keycloak/providers/