import ballerina/http;
import ballerina/log;
import ballerinax/health.clients.fhir;
import ballerinax/health.fhir.r4;

http:OAuth2ClientCredentialsGrantConfig ehrSystemAuthConfig = {
    tokenUrl: tokenUrl,
    clientId: client_id,
    clientSecret: client_secret,
    scopes: scopes,
    optionalParams: {
        "resource": "https://ohfhirrepositorypoc-ohfhirrepositorypoc.fhir.azurehealthcareapis.com"
    }
};

fhir:FHIRConnectorConfig ehrSystemConfig = {
    baseURL: fhirServerUrl,
    mimeType: fhir:FHIR_JSON,
    authConfig: ehrSystemAuthConfig
};

isolated fhir:FHIRConnector fhirConnectorObj = check new (ehrSystemConfig);

public isolated function createResource(json payload) returns r4:FHIRError|fhir:FHIRResponse {
    lock {
        fhir:FHIRResponse|fhir:FHIRError fhirResponse = fhirConnectorObj->create(payload.clone());
        if fhirResponse is fhir:FHIRError {
            log:printError(fhirResponse.toBalString());
            return r4:createFHIRError(fhirResponse.message(), r4:ERROR, r4:INVALID, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }
        log:printInfo(string `Data stored successfully: ${fhirResponse.toJsonString()}`);
        return fhirResponse.clone();
    }
}
