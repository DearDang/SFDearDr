@IsTest
global class ParkServiceMock implements WebServiceMock{
 	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        ParkService.byCountryResponse  response_x = new ParkService.byCountryResponse();
               String[] parkNames = new List<String>();
               parkNames.add('HCL');
parkNames.add('H2SO4');
parkNames.add('NACL');
parkNames.add('H2O');
parkNames.add('N2');
parkNames.add('U296');
        response_x.return_x = parkNames;
        // end
        response.put('response_x', response_x); 
   }
}