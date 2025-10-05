# 🌟 SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX - Docker Image
# Multi-stage build for production deployment

FROM node:20-alpine AS builder

# Install Python for LionAGI integration
RUN apk add --no-cache python3 py3-pip python3-dev build-base

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY src/ ./src/

# Build TypeScript
RUN npm run build

# Production stage
FROM node:20-alpine AS production

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    bash \
    openssl

# Create app user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Copy built application
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./package.json

# Copy Python requirements and install
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Create required directories
RUN mkdir -p logs projects casefiles evidence-vault vr-sessions
RUN chown -R nodejs:nodejs /app

# Switch to app user
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose ports
EXPOSE 8000 8001

# Start application
CMD ["node", "dist/index.js"]
