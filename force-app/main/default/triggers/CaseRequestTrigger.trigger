trigger CaseRequestTrigger on Case_Request__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        CaseRequestHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}