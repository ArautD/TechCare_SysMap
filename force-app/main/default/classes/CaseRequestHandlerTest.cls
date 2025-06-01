@isTest
public class CaseRequestHandlerTest {
    
    static testMethod void testSLA_Complete() {
        Case_Request__c case1 = new Case_Request__c(
            Subject__c = 'Erro no sistema',
            Description__c = 'Sistema travando ao iniciar',
            Priority__c = 'High',
            Status__c = 'In Progress',
            SLA_Deadline__c = System.now().addHours(2)
        );
        insert case1;
        
        // Agora preenche Resolution_Notes__c junto com Status
        case1.Status__c = 'Closed';
        case1.Resolution_Notes__c = 'Resolvido';
        update case1;
        
        List<Case_History__c> histories = [
            SELECT Id, SLA_Met__c, Case_Request_Link__c
            FROM Case_History__c
            WHERE Case_Request_Link__c = :case1.Id
        ];
        
        System.assertEquals(1, histories.size(), 'Histórico deveria ter sido criado');
        System.assertEquals(true, histories[0].SLA_Met__c, 'SLA deveria ter sido cumprido');
    }
    
    static testMethod void testSLA_NaoCumprido() {
        Case_Request__c case2 = new Case_Request__c(
            Subject__c = 'Problema de login',
            Description__c = 'Usuário não consegue acessar',
            Priority__c = 'Medium',
            Status__c = 'In Progress',
            SLA_Deadline__c = System.now().addHours(-3)
        );
        insert case2;
        
        // Agora preenche Resolution_Notes__c junto com Status
        case2.Status__c = 'Closed';
        case2.Resolution_Notes__c = 'Resolvido';
        update case2;
        
        List<Case_History__c> histories = [
            SELECT Id, SLA_Met__c, Case_Request_Link__c
            FROM Case_History__c
            WHERE Case_Request_Link__c = :case2.Id
        ];
        
        System.assertEquals(1, histories.size(), 'Histórico deveria ter sido criado');
        System.assertEquals(false, histories[0].SLA_Met__c, 'SLA não deveria ter sido cumprido');
    }
}