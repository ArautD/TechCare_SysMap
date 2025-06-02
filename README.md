# 🛠️ Projeto Salesforce: TechCare Support 
## Trata-se de uma atividade de caso prático da 6ª Edição do Programa Trainee Sysmap de Excelência SalesForce.

## 📌 Objetivo
Esta aplicação tem como objetivo gerenciar solicitações de suporte técnico, com dois tipos de perfis (Support Premium e Support Standard), conta com controle de Casos e relatórios em uma instância Salesforce personalizada. Utilizando recursos declarativos (Admin) e programáticos (Dev) com foco em boas práticas de configuração e desenvolvimento.
## Diagrama de Caso de Uso
![image](https://github.com/user-attachments/assets/b444b8eb-7d1d-46b6-922b-2fdba2b66e6d)

## 🚀 Instalação & Deploy
### 🔧 Pré-requisitos
- Conta Salesforce Developer Edition
- VSCode com Salesforce Extension Pack
- Salesforce CLI (opcional para deploy automático) disponível em: <https://developer.salesforce.com/tools/salesforcecli>

### 📥 Clonagem do Projeto
bash
git clone https://github.com/ArautD/TechCare_SysMap.git


### 📤 Deploy via CLI
bash
sfdx force:source:deploy -p force-app -u Caso_pratico_playground


## 🔧 Configurações Declarativas
- Objeto: Case_Request__c com campos como: Case Request Name, ClosedDate, Created By, Description, Last Modified By, Owner, Priority, Record Type, Resolution Notes, Resolution Time, SLA Deadline, SLA Met, Status e Subject.
- Objeto Case_History__c com campos como: Case History Name, Case Request Link, Created By, Last Modified By, Owner, SLA Met, Time Closed.
- Record Types: Premium e Standard
- Permission Sets: Support Premium, Support Standard
- Flow: SLA automático (8h para Premium ou 24h para Standard) e ClosedDate (Define a data de fechamento do Caso)
- Validações: Bloqueia fechamento sem resolução do caso
- Atribuição via Flow automático
- Dynamic Forms condicionais entre perfil Premium e Standard
- App Lightning com abas úteis como Case Requests, Dashboards e Reports

## 📊 Relatórios & Dashboards
- Relatórios: Casos por status/prioridade
- Dashboards: SLA médio e total por status

## 👨‍💻 Desenvolvimento (Dev)
- Classe Apex CaseRequestHandler para checar SLA e gravar em Case_History__c
- Classe CaseRequestController para editar o campo Status__c de 'Closed' para 'In Progress' quando pressionado o botão 'Reabrir Caso'
- LWC para criar o componente caseDetail com countdown e botão "Reabrir Caso" e CaseRequestTrigger para fazer a chamada
- Classe de teste para CaseRequestController, CaseRequestHanddler, CaseRequestRestAPI e CaseRequestTrigger com 90%+ cobertura
- API REST Classe CaseRequestRestAPI com status do caso, se SLA foi cumprido (SLAMet), Status e o caseID do caso.

### EXEMPLO
![image](https://github.com/user-attachments/assets/729c1603-0416-42f3-96e0-91de3aea332f)


## ✅ Testes Recomendados
1. CaseRequestControllerTest, para fazer a verificação se o caso está sendo salvo sem Resolution Note
2. CaseRequestHandlerTest, para fazer a verificação se o botão está funcionando para reabrir o caso transformando status 'Closed' para 'In Progress' e se o SLA Deadline foi cumprido.
3. CaseRequestTrigger para verificar se o método CaseRequestHandler está sendo chamado.
4. CaseRequestRestAPITest para fazer uma requisição, utilizando um GET para ter como resultado um JSON com Status e o SLA.

### Exemplo dos testes
   ![image](https://github.com/user-attachments/assets/3519a3a5-3c83-4bd8-9961-515cb86d524b)


## 📁 Estrutura

📦 force-app
 ┣ 📂 objects
 ┣ 📂 triggers
 ┣ 📂 classes
 ┣ 📂 lwc
 ┣ README.md


> Desenvolvido por [Paulo Sergio Lemos (ArautD)] – 2025

>"Não acredite em você mesmo, acredite em mim, que acredita em você." _Kamina
