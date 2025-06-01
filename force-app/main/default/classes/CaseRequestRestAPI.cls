@RestResource(urlMapping='/CaseRequestAPI/case')
global with sharing class CaseRequestRestAPI {

    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Extrai o ID do URI manualmente
        String uri = req.requestURI;
        String caseId;

        if (uri != null && uri.contains('?')) {
            String[] parts = uri.split('\\?');
            if (parts.size() > 1) {
                String[] paramParts = parts[1].split('=');
                if (paramParts.size() == 2 && paramParts[0] == 'id') {
                    caseId = paramParts[1];
                }
            }
        }

        if (String.isBlank(caseId)) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Missing parameter: id');
            return;
        }

        try {
            Case_Request__c caseRecord = [
                SELECT Id, Status__c, SLA_Met__c
                FROM Case_Request__c
                WHERE Id = :caseId
                LIMIT 1
            ];

            Map<String, Object> result = new Map<String, Object>{
                'caseId' => caseRecord.Id,
                'status' => caseRecord.Status__c,
                'slaMet' => caseRecord.SLA_Met__c
            };

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(result));
            res.addHeader('Content-Type', 'application/json');

        } catch (Exception e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('Case not found.');
        }
    }
}