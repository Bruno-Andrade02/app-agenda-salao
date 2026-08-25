
sql
-- Extensão para gerar identificadores únicos (UUID) sozinho — essa extensão adiciona essa capacidade
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Tabela usuários com PK unica usando UUID como segurança.
CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    perfil VARCHAR(20) NOT NULL CHECK (perfil IN ('cliente', 'administrador')),
    criado_em TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabela serviços com check evitando horário nulo e negativo.
CREATE TABLE servicos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(100) NOT NULL,
    quantidade_horarios INTEGER NOT NULL CHECK (quantidade_horarios > 0),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- Tabela agendamentos com FK para usuários e check para DEFAULT 'reservado'.
CREATE TABLE agendamentos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios(id),
    data DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'reservado' CHECK (status IN ('reservado', 'confirmado', 'cancelado')),
    criado_em TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Tabela de relacionamento entre agendamentos e serviços, com PK composta. A chave primária é a combinação de agendamento_id + servico_id
CREATE TABLE agendamento_servicos (
    agendamento_id UUID NOT NULL REFERENCES agendamentos(id) ON DELETE CASCADE,
    servico_id UUID NOT NULL REFERENCES servicos(id),
    PRIMARY KEY (agendamento_id, servico_id)
);

-- Tabela bloqueios com FK para usuários e check para horário válido.
CREATE TABLE bloqueios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    criado_por UUID NOT NULL REFERENCES usuarios(id),
    criado_em TIMESTAMP NOT NULL DEFAULT NOW()
);