@isTest
private class CaseRequestRestAPITest {

    @isTest
    static void testDoGet_Success() {
        // Cria um registro de teste
        Case_Request__c caseRequest = new Case_Request__c(
            Subject__c = 'Teste REST',
            Description__c = 'Chamado criado via teste REST',
            Priority__c = 'Medium',
            Status__c = 'New',
            SLA_Met__c = true
        );
        insert caseRequest;

        // Simula o request REST
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/CaseRequestAPI/case?id=' + caseRequest.Id;
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRequestRestAPI.doGet();
        Test.stopTest();

        // Valida a resposta
        System.assertEquals(200, res.statusCode, 'Código de resposta deve ser 200');

        String jsonResponse = res.responseBody.toString();
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        System.assertEquals(caseRequest.Id, result.get('caseId'), 'Deve retornar o ID correto');
        System.assertEquals('New', result.get('status'), 'Status deve ser New');
        System.assertEquals(true, result.get('slaMet'), 'SLA Met deve ser true');
    }

    @isTest
    static void testDoGet_MissingId() {
        // Simula request sem parâmetro "id"
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/CaseRequestAPI/case'; // sem ?id=
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRequestRestAPI.doGet();
        Test.stopTest();

        System.assertEquals(400, res.statusCode, 'Deve retornar erro 400 por falta de parâmetro');
        System.assert(res.responseBody.toString().contains('Missing parameter: id'), 'Mensagem deve indicar falta do parâmetro id');
    }

    @isTest
    static void testDoGet_CaseNotFound() {
        // Simula request com ID inválido
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/CaseRequestAPI/case?id=001XXXXXXXXXXXXXXX';
        req.httpMethod = 'GET';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRequestRestAPI.doGet();
        Test.stopTest();

        System.assertEquals(404, res.statusCode, 'Deve retornar erro 404 para ID inválido');
        System.assert(res.responseBody.toString().contains('Case not found'), 'Mensagem deve indicar caso não encontrado');
    }
}