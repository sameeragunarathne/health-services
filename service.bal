import ballerina/http;
import ballerina/log;
import ballerinax/health.fhir.r4.uscore501;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    resource function post sync(@http:Payload Patient payload) returns uscore501:USCorePatientProfile {
        // Send a response back to the caller.
        uscore501:USCorePatientProfile mapDataResult = mapData(payload);
        log:printInfo(mapDataResult.toBalString());
        return mapDataResult;
    }
}
