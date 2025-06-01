# 🛠️ Projeto Salesforce: TechCare Support

## 📌 Objetivo
Esta aplicação tem como objetivo gerenciar solicitações de suporte técnico, com controle de SLA, priorização e relatórios em uma instância Salesforce personalizada. Utiliza recursos declarativos (Admin) e programáticos (Dev) com foco em boas práticas de configuração e desenvolvimento.

## 🚀 Instalação & Deploy
### 🔧 Pré-requisitos
- Conta Salesforce Developer Edition
- VS Code com Salesforce Extension Pack
- Salesforce CLI (opcional para deploy automático)

### 📥 Clonagem do Projeto
bash
git clone https://github.com/seu-repositorio/salesforce-techcare.git


### 📤 Deploy via CLI
bash
sfdx force:source:deploy -p force-app -u nome-da-org


## 🔧 Configurações Declarativas
- Objeto: Case_Request__c com campos como Subject, Description, Priority, SLA, Resolution Notes
- Record Types: Premium e Standard
- Permission Sets: Support Premium, Support Standard
- Flow: SLA automático (8h ou 24h)
- Validações: Bloqueia fechamento sem resolução
- Atribuição via Flow automático
- Dynamic Forms condicionais
- App Lightning com abas úteis

## 📊 Relatórios & Dashboards
- Relatórios: Casos por status/prioridade
- Dashboards: SLA médio e total por status

## 👨‍💻 Desenvolvimento (Dev)
- Trigger para checar SLA e gravar em Case_History__c
- Classe de teste com 90%+ cobertura
- LWC para countdown e botão "Reabrir Caso"
- API REST (opcional) com status do caso

## ✅ Testes Recomendados
1. Criar casos e testar SLA
2. Validar fluxo e bloqueios
3. Fechar casos e revisar histórico
4. Usar LWC para reabrir

## 📹 Vídeos
- Configuração: https://loom.com/...
- Flows e validações: https://loom.com/...
- Desenvolvimento: https://loom.com/...

## 📁 Estrutura

📦 force-app
 ┣ 📂 objects
 ┣ 📂 triggers
 ┣ 📂 classes
 ┣ 📂 lwc
 ┣ README.md


> Desenvolvido por [Seu Nome] – 2025
