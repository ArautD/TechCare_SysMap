@isTest
private class CaseRequestControllerTest {

    private static Id getPremiumRecordTypeId() {
        return Schema.SObjectType.Case_Request__c.getRecordTypeInfosByName().get('Premium').getRecordTypeId();
    }

    @isTest
    static void testReopenCase_Success() {
        Id premiumRecordTypeId = getPremiumRecordTypeId();

        Case_Request__c closedCase = new Case_Request__c(
            RecordTypeId = premiumRecordTypeId,
            Subject__c = 'Erro no sistema',
            Description__c = 'Sistema travando ao iniciar',
            Priority__c = 'High',
            Status__c = 'Closed',
            Resolution_Notes__c = 'funcional'
        );
        insert closedCase;

        Test.startTest();
        CaseRequestController.reopenCase(closedCase.Id);
        Test.stopTest();

        Case_Request__c updatedCase = [SELECT Status__c FROM Case_Request__c WHERE Id = :closedCase.Id];
        System.assertEquals('In Progress', updatedCase.Status__c, 'O status deve ser alterado para In Progress');
    }

    @isTest
    static void testReopenCase_ThrowsException() {
        Id premiumRecordTypeId = getPremiumRecordTypeId();

        Case_Request__c openCase = new Case_Request__c(
            RecordTypeId = premiumRecordTypeId,
            Subject__c = 'Erro nos sistemas',
            Description__c = 'Sistema travando ao iniciar',
            Priority__c = 'High',
            Status__c = 'New'
        );
        insert openCase;

        Test.startTest();
        try {
            CaseRequestController.reopenCase(openCase.Id);
            System.assert(false, 'Deveria lançar uma exceção para caso não fechado');
        } catch (AuraHandledException ex) {
            System.assertEquals('O caso não está fechado.', ex.getMessage());
        }
        Test.stopTest();
    }
}