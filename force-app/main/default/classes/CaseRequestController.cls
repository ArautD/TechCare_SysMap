public with sharing class CaseRequestController {
    @AuraEnabled
    public static void reopenCase(Id caseId) {
        Case_Request__c caseRequest = [SELECT Id, Status__c FROM Case_Request__c WHERE Id = :caseId LIMIT 1];

        if (caseRequest.Status__c == 'Closed') {
            caseRequest.Status__c = 'In Progress';
            update caseRequest;
        } else {
            throw new AuraHandledException('O caso não está fechado.');
        }
    }
}