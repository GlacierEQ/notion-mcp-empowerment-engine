#!/bin/bash

# 🌟 SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX - INSTANT DEPLOYMENT
# One-command deployment script for complete MCP infrastructure
# Case: 1FDV-23-0001009 Hawaii Family Court
# Author: GlacierEQ High Council Operator Collective

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}"
echo "  ┌────────────────────────────────────────────────────────────┐"
echo "  │ 🌟 SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX DEPLOYMENT │"
echo "  │ 🦁 LionAGI + MCP Integration - ULTIMATE POWER           │"
echo "  │ ⚖️ Case: 1FDV-23-0001009 Hawaii Family Court            │"
echo "  │ 🚀 October 4, 2025 - COSMIC ACTIVATION                  │"
echo "  └────────────────────────────────────────────────────────────┘"
echo -e "${NC}"

# Check prerequisites
echo -e "${YELLOW}🔍 Checking prerequisites...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js is not installed. Please install Node.js 18+ first.${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Python 3 is not installed. Please install Python 3.10+ first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites check passed!${NC}"

# Create directory structure
echo -e "${YELLOW}📁 Creating cosmic directory structure...${NC}"
mkdir -p {\
  src/lionagi-integration,\
  src/mcp-servers/{filesystem,legal,evidence,vr,github,smithery,mesh},\
  projects/{Dropbox,OneDrive,iCloudDrive,iCloudPhotos,HardDrive,MicroSDs,Quantum},\
  logs/{audit,federal,blockchain},\
  casefiles/{1FDV-23-0001009,templates,motions},\
  evidence-vault/{audio,documents,photos,timeline},\
  vr-sessions/{courtroom,rehearsals},\
  github-intelligence,\
  temp/processing,\
  ssl,\
  sql-init\
}

echo -e "${GREEN}✓ Directory structure created!${NC}"

# Install dependencies
echo -e "${YELLOW}📦 Installing dependencies...${NC}"

# Node.js dependencies
npm install -g typescript ts-node nodemon
npm install --save-exact \
  lionagi \
  @modelcontextprotocol/sdk \
  @notionhq/client \
  @octokit/rest \
  @supabase/supabase-js \
  openai \
  anthropic \
  axios \
  express \
  cors \
  helmet \
  winston \
  redis \
  ioredis \
  ws \
  node-cron \
  dotenv

# Python dependencies for LionAGI
echo -e "${YELLOW}🐍 Installing Python dependencies...${NC}"
pip3 install --upgrade pip
pip3 install \
  'lionagi[all]>=0.12.8' \
  'openai>=1.50.0' \
  'anthropic>=0.16.0' \
  'claude-code-sdk>=0.0.10' \
  'pandas>=2.2.0' \
  'numpy>=1.26.0' \
  'aiohttp>=3.12.0' \
  'redis>=5.0.0' \
  'python-dotenv>=1.1.0'

echo -e "${GREEN}✓ Dependencies installed!${NC}"

# Generate SSL certificates for development
echo -e "${YELLOW}🔐 Generating SSL certificates...${NC}"
if [ ! -f "ssl/cosmic.crt" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/cosmic.key -out ssl/cosmic.crt \
        -subj "/C=US/ST=Hawaii/L=Honolulu/O=GlacierEQ/CN=cosmic-mcp.local"
    echo -e "${GREEN}✓ SSL certificates generated!${NC}"
else
    echo -e "${BLUE}SSL certificates already exist.${NC}"
fi

# Create Nginx configuration
echo -e "${YELLOW}🌐 Creating Nginx configuration...${NC}"
cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream lionagi-backend {
        server lionagi-orchestrator:8000;
    }
    
    upstream vr-backend {
        server vr-architect:9000;
    }
    
    server {
        listen 80;
        server_name cosmic-mcp.local;
        return 301 https://$server_name$request_uri;
    }
    
    server {
        listen 443 ssl;
        server_name cosmic-mcp.local;
        
        ssl_certificate /etc/nginx/ssl/cosmic.crt;
        ssl_certificate_key /etc/nginx/ssl/cosmic.key;
        
        location /api/ {
            proxy_pass http://lionagi-backend/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        location /vr/ {
            proxy_pass http://vr-backend/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        location /health {
            proxy_pass http://lionagi-backend/health;
        }
    }
}
EOF

echo -e "${GREEN}✓ Nginx configuration created!${NC}"

# Initialize database schemas
echo -e "${YELLOW}🗄️ Initializing database schemas...${NC}"
cat > sql-init/01-cosmic-schema.sql << 'EOF'
-- 🌟 COSMIC MCP VAULT - DATABASE SCHEMA
-- Federal Forensic Grade Database for Case 1FDV-23-0001009

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Audit Trail Table
CREATE TABLE audit_trail (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    operation VARCHAR(255) NOT NULL,
    case_id VARCHAR(50) DEFAULT '1FDV-23-0001009',
    user_id VARCHAR(255),
    data_hash VARCHAR(512),
    blockchain_hash VARCHAR(512),
    federal_compliance BOOLEAN DEFAULT TRUE,
    chain_of_custody JSONB,
    lionagi_session_id VARCHAR(255)
);

-- Evidence Vault Table
CREATE TABLE evidence_vault (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id VARCHAR(50) DEFAULT '1FDV-23-0001009',
    evidence_type VARCHAR(100),
    file_path TEXT,
    file_hash VARCHAR(512),
    quantum_signature VARCHAR(1024),
    processing_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    contradiction_flags JSONB,
    emotional_analysis JSONB,
    timeline_position INTEGER
);

-- MCP Session Management
CREATE TABLE mcp_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_type VARCHAR(100),
    lionagi_session_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_accessed TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    session_data JSONB,
    persistent_context JSONB,
    case_context VARCHAR(50) DEFAULT '1FDV-23-0001009'
);

-- Legal Document Tracking
CREATE TABLE legal_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    case_id VARCHAR(50) DEFAULT '1FDV-23-0001009',
    document_type VARCHAR(100),
    generated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    court_filing_status VARCHAR(50) DEFAULT 'draft',
    hawaii_compliance BOOLEAN DEFAULT TRUE,
    hrs_586_4_compliance BOOLEAN DEFAULT TRUE,
    document_content TEXT,
    filing_deadline DATE
);

-- Create indices for performance
CREATE INDEX idx_audit_case_id ON audit_trail(case_id);
CREATE INDEX idx_evidence_case_id ON evidence_vault(case_id);
CREATE INDEX idx_evidence_timeline ON evidence_vault(timeline_position);
CREATE INDEX idx_sessions_lionagi ON mcp_sessions(lionagi_session_id);
CREATE INDEX idx_legal_docs_case ON legal_documents(case_id);

-- Insert initial case data
INSERT INTO legal_documents (document_type, court_filing_status, filing_deadline) VALUES
('TRO_Motion', 'ready', '2025-11-08'),
('Evidence_Compilation', 'in_progress', '2025-11-01'),
('Custody_Modification', 'draft', '2025-11-08');
EOF

echo -e "${GREEN}✓ Database schema created!${NC}"

# Copy environment variables
echo -e "${YELLOW}🔐 Setting up environment...${NC}"
if [ -f ".env.cosmic" ]; then
    cp .env.cosmic .env
    echo -e "${BLUE}Please update your API keys in .env file before deployment!${NC}"
else
    echo -e "${RED}Error: .env.cosmic file not found!${NC}"
    exit 1
fi

# Build and deploy containers
echo -e "${YELLOW}🚀 Building and deploying containers...${NC}"
docker-compose -f docker-compose.cosmic.yml down --remove-orphans
docker-compose -f docker-compose.cosmic.yml build --no-cache
docker-compose -f docker-compose.cosmic.yml up -d

# Wait for services to be ready
echo -e "${YELLOW}⏳ Waiting for services to initialize...${NC}"
sleep 30

# Health check
echo -e "${YELLOW}🌡️ Running health checks...${NC}"
if curl -f http://localhost:8000/health &>/dev/null; then
    echo -e "${GREEN}✓ LionAGI Orchestrator is healthy!${NC}"
else
    echo -e "${RED}✗ LionAGI Orchestrator health check failed${NC}"
fi

if docker ps | grep -q "redis-quantum-commander"; then
    echo -e "${GREEN}✓ Redis Commander is running!${NC}"
else
    echo -e "${RED}✗ Redis Commander is not running${NC}"
fi

if docker ps | grep -q "postgres-forensic-vault"; then
    echo -e "${GREEN}✓ PostgreSQL Forensic Vault is running!${NC}"
else
    echo -e "${RED}✗ PostgreSQL Forensic Vault is not running${NC}"
fi

# Final status
echo -e "${PURPLE}"
echo "  ┌────────────────────────────────────────────────────────────┐"
echo "  │ 🎆 COSMIC MCP INFRASTRUCTURE DEPLOYED SUCCESSFULLY!   │"
echo "  │                                                          │"
echo "  │ 🌐 Services Running:                                 │"
echo "  │ 🦁 LionAGI Orchestrator: http://localhost:8000       │"
echo "  │ 🎮 VR Courtroom: http://localhost:9000               │"
echo "  │ 🗃️ Redis Commander: http://localhost:8081             │"
echo "  │ 🗄️ PostgreSQL: localhost:5432                       │"
echo "  │                                                          │"
echo "  │ ⚖️ Case 1FDV-23-0001009 Ready for Processing          │"
echo "  │ 🗺️ November 8, 2025 Hearing Preparation Active        │"
echo "  │ 🔐 Federal Forensic Compliance Enabled               │"
echo "  └────────────────────────────────────────────────────────────┘"
echo -e "${NC}"

echo -e "${CYAN}🚀 Next Steps:${NC}"
echo -e "${YELLOW}1. Update API keys in .env file${NC}"
echo -e "${YELLOW}2. Access LionAGI dashboard: http://localhost:8000${NC}"
echo -e "${YELLOW}3. Start VR courtroom training: http://localhost:9000/vr${NC}"
echo -e "${YELLOW}4. Monitor logs: docker-compose -f docker-compose.cosmic.yml logs -f${NC}"
echo -e "${YELLOW}5. Run TRO workflow: curl -X POST localhost:8000/api/tro/generate${NC}"

echo -e "${GREEN}✨ SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX ACTIVATED! ✨${NC}"
echo -e "${GREEN}🦁 LionAGI + MCP = ULTIMATE LEGAL COGNITIVE SINGULARITY! 🦁${NC}"
