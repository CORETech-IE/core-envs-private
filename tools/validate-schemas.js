#!/usr/bin/env node

const Ajv = require('ajv');
const ajvFormats = require('ajv-formats');
const yaml = require('js-yaml');
const fs = require('fs');
const path = require('path');

// Inicializar AJV con formatos
const ajv = new Ajv({ allErrors: true });
ajvFormats(ajv);

// Cargar esquemas
const configSchema = JSON.parse(
  fs.readFileSync(path.join(__dirname, 'schemas/config.schema.json'), 'utf8')
);
const secretsSchema = JSON.parse(
  fs.readFileSync(path.join(__dirname, 'schemas/secrets.schema.json'), 'utf8')
);

// Compilar validadores
const validateConfig = ajv.compile(configSchema);
const validateSecrets = ajv.compile(secretsSchema);

// Validar un cliente
function validateClient(clientName) {
  const clientPath = path.join(__dirname, 'clients', clientName);
  
  // Validar config.yaml
  const configPath = path.join(clientPath, 'config.yaml');
  const config = yaml.load(fs.readFileSync(configPath, 'utf8'));
  
  if (!validateConfig(config)) {
    console.error(`❌ config.yaml validation failed for ${clientName}:`);
    console.error(JSON.stringify(validateConfig.errors, null, 2));
    return false;
  }
  
  console.log(`✅ config.yaml valid for ${clientName}`);
  
  // Validar secrets.sops.yaml (si se puede decodificar)
  // Nota: En producción, esto requeriría decodificar con SOPS primero
  
  return true;
}

// Ejecutar validación
const client = process.argv[2] || 'core-dev';
validateClient(client);