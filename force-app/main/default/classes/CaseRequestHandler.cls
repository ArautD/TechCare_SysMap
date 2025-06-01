public class CaseRequestHandler {
    public static void handleAfterUpdate(List<Case_Request__c> newList, Map<Id, Case_Request__c> oldMap) {
        List<Case_History__c> historiesToInsert = new List<Case_History__c>();

        for (Case_Request__c newCase : newList) {
            // Verifica se o status está como "Closed"
            if (newCase.Status__c == 'Closed') {
                Boolean slaMet = false;
                
                if (newCase.SLA_Deadline__c != null) {
                    slaMet = newCase.SLA_Deadline__c >= System.now();
                }

                // Evita criar registros duplicados se já houver histórico para este Case
                Boolean alreadyHasHistory = [
                    SELECT COUNT()
                    FROM Case_History__c
                    WHERE Case_Request_Link__c = :newCase.Id
                ] > 0;

                if (!alreadyHasHistory) {
                    Case_History__c history = new Case_History__c(
                        Case_Request_Link__c = newCase.Id,
                        Time_Closed__c = System.now(),
                        SLA_Met__c = slaMet
                    );

                    historiesToInsert.add(history);
                }
            }
        }

        if (!historiesToInsert.isEmpty()) {
            insert historiesToInsert;
        }
    }
}