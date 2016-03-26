package eBayStuff;

import java.io.IOException;


import com.ebay.sdk.ApiAccount;
import com.ebay.sdk.ApiContext;
import com.ebay.sdk.ApiCredential;
import com.ebay.sdk.call.GetSessionIDCall;


public class GetUser {
        
  // sample category ids supporting custom item specifics
//  private static Set<String> sampleCatIDSet = new HashSet<String>();
//  static {
//          sampleCatIDSet.add("162140");
//  }
        
  public static void main(String[] args) {

    try {
    	
      org.apache.log4j.BasicConfigurator.configure();
      ApiContext apiContext = getApiContext();
      GetSessionIDCall res = new GetSessionIDCall(apiContext);
      
      System.out.println(res.getSessionID());
      


    }
    catch(Exception e) {
      System.out.println("Failed");
      e.printStackTrace();
    }
  }
  
  private static ApiContext getApiContext() throws IOException {
      
	  ApiAccount ac = new ApiAccount();
      ac.setDeveloper("Dev ID");
 	  ac.setApplication("App ID here");
 	  ac.setCertificate("Cert ID");
	
      ApiCredential apiCred = new ApiCredential();
	  apiCred.setApiAccount(ac);

	  ApiContext apiContext = new ApiContext();
	  apiContext.setApiCredential(apiCred);
	  apiContext.setRuName("RUName");
	  System.out.println(apiContext.getRuName());
	  apiContext.setApiServerUrl("https://api.ebay.com/wsapi");  // not sandbox
      // https://api.sandbox.ebay.com/wsapi

      return apiContext;
  }
}
