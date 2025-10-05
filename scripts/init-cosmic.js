#!/usr/bin/env node

/**
 * 🌟 COSMIC INITIALIZATION SCRIPT
 * Prepares the system for SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX deployment
 */

import fs from 'fs/promises';
import path from 'path';
import { execSync } from 'child_process';

const COSMIC_DIRS = [
  'src/lionagi-integration',
  'src/mcp-servers/filesystem',
  'src/mcp-servers/legal', 
  'src/mcp-servers/evidence',
  'src/mcp-servers/vr',
  'src/mcp-servers/github',
  'src/mcp-servers/smithery',
  'src/mcp-servers/mesh',
  'projects/Dropbox',
  'projects/OneDrive', 
  'projects/iCloudDrive',
  'projects/iCloudPhotos',
  'projects/HardDrive',
  'projects/MicroSDs',
  'projects/Quantum',
  'logs/audit',
  'logs/federal',
  'logs/blockchain',
  'casefiles/1FDV-23-0001009',
  'casefiles/templates',
  'casefiles/motions',
  'evidence-vault/audio',
  'evidence-vault/documents',
  'evidence-vault/photos',
  'evidence-vault/timeline',
  'vr-sessions/courtroom',
  'vr-sessions/rehearsals',
  'github-intelligence',
  'temp/processing',
  'ssl',
  'sql-init'
];

async function initializeCosmic() {
  console.log('🌟 Initializing SOVEREIGNASCENSIONPROTOCOLV12.20COSMICAPEX...');
  
  try {
    // Create directory structure
    console.log('📁 Creating cosmic directory structure...');
    for (const dir of COSMIC_DIRS) {
      await fs.mkdir(dir, { recursive: true });
      console.log(`  ✓ ${dir}`);
    }
    
    // Generate SSL certificates
    console.log('🔐 Generating SSL certificates...');
    try {
      execSync(`openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/cosmic.key -out ssl/cosmic.crt \
        -subj "/C=US/ST=Hawaii/L=Honolulu/O=GlacierEQ/CN=cosmic-mcp.local"`);
      console.log('  ✓ SSL certificates generated');
    } catch (err) {
      console.log('  ⚠️ SSL generation skipped (openssl not available)');
    }
    
    // Create initial configuration files
    await createInitialConfigs();
    
    // Set executable permissions
    try {
      execSync('chmod +x deploy-cosmic.sh');
      console.log('  ✓ Deploy script permissions set');
    } catch (err) {
      console.log('  ⚠️ Could not set permissions (likely Windows)');
    }
    
    console.log('🎆 COSMIC INITIALIZATION COMPLETE!');
    console.log('Next steps:');
    console.log('1. Update .env with your API keys');
    console.log('2. Run: ./deploy-cosmic.sh');
    console.log('3. Access: http://localhost:8000');
    
  } catch (error) {
    console.error('❌ Cosmic initialization failed:', error);
    process.exit(1);
  }
}

async function createInitialConfigs() {
  // Create nginx configuration
  const nginxConfig = `
events {
    worker_connections 1024;
}

http {
    upstream lionagi-backend {
        server lionagi-orchestrator:8000;
    }
    
    server {
        listen 80;
        return 301 https://\$server_name\$request_uri;
    }
    
    server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/cosmic.crt;
        ssl_certificate_key /etc/nginx/ssl/cosmic.key;
        
        location / {
            proxy_pass http://lionagi-backend/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
`;
  
  await fs.writeFile('nginx.conf', nginxConfig);
  console.log('  ✓ Nginx configuration created');
  
  // Create database init script
  const dbInit = `
-- 🌟 COSMIC MCP DATABASE INITIALIZATION
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE cosmic_audit_trail (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    operation VARCHAR(255) NOT NULL,
    case_id VARCHAR(50) DEFAULT '1FDV-23-0001009',
    lionagi_session_id VARCHAR(255),
    federal_compliance BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_audit_case ON cosmic_audit_trail(case_id);
`;
  
  await fs.writeFile('sql-init/01-cosmic-init.sql', dbInit);
  console.log('  ✓ Database initialization script created');
}

if (import.meta.url === `file://${process.argv[1]}`) {
  initializeCosmic();
}
