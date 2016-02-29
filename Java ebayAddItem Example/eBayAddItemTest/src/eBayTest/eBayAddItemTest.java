package eBayTest;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import com.ebay.sdk.ApiContext;
import com.ebay.sdk.ApiCredential;
import com.ebay.sdk.call.AddItemCall;
import com.ebay.sdk.helper.ConsoleUtil;
import com.ebay.sdk.util.eBayUtil;
import com.ebay.soap.eBLBaseComponents.AmountType;
import com.ebay.soap.eBLBaseComponents.BuyerPaymentMethodCodeType;
import com.ebay.soap.eBLBaseComponents.CategoryType;
import com.ebay.soap.eBLBaseComponents.CountryCodeType;
import com.ebay.soap.eBLBaseComponents.CurrencyCodeType;
import com.ebay.soap.eBLBaseComponents.FeesType;
import com.ebay.soap.eBLBaseComponents.ItemType;
import com.ebay.soap.eBLBaseComponents.ListingDurationCodeType;
import com.ebay.soap.eBLBaseComponents.ListingTypeCodeType;
import com.ebay.soap.eBLBaseComponents.NameValueListArrayType;
import com.ebay.soap.eBLBaseComponents.NameValueListType;
import com.ebay.soap.eBLBaseComponents.ReturnPolicyType;
import com.ebay.soap.eBLBaseComponents.SellerPaymentProfileType;
import com.ebay.soap.eBLBaseComponents.SellerProfilesType;
import com.ebay.soap.eBLBaseComponents.SellerReturnProfileType;
import com.ebay.soap.eBLBaseComponents.SellerShippingProfileType;
import com.ebay.soap.eBLBaseComponents.ShippingDetailsType;
import com.ebay.soap.eBLBaseComponents.ShippingServiceCodeType;
import com.ebay.soap.eBLBaseComponents.ShippingServiceOptionsType;
import com.ebay.soap.eBLBaseComponents.ShippingTypeCodeType;
/**
 * 
 * A simple item listing sample,
 * show basic flow to list an item to eBay Site using eBay SDK.
 * 
 * @author boyang
 *
 */
public class eBayAddItemTest {
        
  // sample category ids supporting custom item specifics
  private static Set<String> sampleCatIDSet = new HashSet<String>();
  static {
          sampleCatIDSet.add("162140");
  }
        
  public static void main(String[] args) {

    try {

      System.out.print("\n");
      System.out.print("+++++++++++++++++++++++++++++++++++++++\n");
      System.out.print("+ Welcome to eBay SDK for Java Sample +\n");
      System.out.print("+  - ConsoleAddItem                   +\n");
      System.out.print("+++++++++++++++++++++++++++++++++++++++\n");
      System.out.print("\n");
      org.apache.log4j.BasicConfigurator.configure();
      // [Step 1] Initialize eBay ApiContext object
          System.out.println("===== [1] Account Information ====");
      ApiContext apiContext = getApiContext();
      
      // [Step 2] Create a new item object.
      System.out.println("===== [2] Item Information ====");
      ItemType item = buildItem();
      
      // [Step 3] Create call object and execute the call.
      System.out.println("===== [3] Execute the API call ====");
      System.out.println("Begin to call eBay API, please wait ...");
      AddItemCall api = new AddItemCall(apiContext);
      api.setItem(item);
      FeesType fees = api.addItem();
      System.out.println("End to call eBay API, show call result ...");
      System.out.println();

      // [Setp 4] Display results.
      

      double listingFee = eBayUtil.findFeeByName(fees.getFee(), "ListingFee").getFee().getValue();
      System.out.println("Listing fee is: " + new Double(listingFee).toString());
      System.out.println("Listed Item ID: " + item.getItemID());
    }
    catch(Exception e) {
      System.out.println("Fail to list the item.");
      e.printStackTrace();
    }
  }
  
  /**
   * Build a sample item
   * @return ItemType object
   */
  private static ItemType buildItem() throws IOException {

      String input;
          ItemType item = new ItemType();

      // item title
      item.setTitle(ConsoleUtil.readString("Title: "));
      // item description
      item.setDescription(ConsoleUtil.readString("Description: "));
      
      // listing type
      item.setListingType(ListingTypeCodeType.FIXED_PRICE_ITEM);
      // listing price
      item.setCurrency(CurrencyCodeType.USD);
      input = ConsoleUtil.readString("Start Price: ");
      AmountType amount = new AmountType();
      amount.setValue(Double.valueOf(input));
      item.setStartPrice(amount);
      
      // listing duration
      item.setListingDuration(ListingDurationCodeType.DAYS_3.value());
      
      // item location and country
      item.setLocation(ConsoleUtil.readString("Location: "));
      item.setCountry(CountryCodeType.US);

      // listing category
      CategoryType cat = new CategoryType();
      String inputString = "Primary Category (e.g.";
      for(String catId : sampleCatIDSet) {
          inputString = inputString + "," + catId;
      }
      inputString += "): ";
      String catID = ConsoleUtil.readString(inputString);
      cat.setCategoryID(catID);
      item.setPrimaryCategory(cat);
      
      // item quantity
      item.setQuantity(new Integer(1));
      
      // item condition, New
      // item.setConditionID(1000);  
 
      // item specifics
      if(sampleCatIDSet.contains(catID)) {
          item.setItemSpecifics(buildItemSpecifics());
      }
      
      /*
                 * The Business Policies API and related Trading API fields are
                 * available in sandbox. It will be available in production for a
                 * limited number of sellers with Version 775. 100 percent of sellers
                 * will be ramped up to use Business Polcies in July 2012
                 */
      
      //Create Seller Profile container
      SellerProfilesType sellerProfile=new SellerProfilesType();
      
      //Set Payment ProfileId
      input = ConsoleUtil.readString("Enter your Seller Policy Payment ProfileId : ");
      SellerPaymentProfileType sellerPaymentProfile=new SellerPaymentProfileType();
      sellerPaymentProfile.setPaymentProfileID(Long.valueOf(input));
      sellerProfile.setSellerPaymentProfile(sellerPaymentProfile);

      //Set Shipping ProfileId
      SellerShippingProfileType sellerShippingProfile=new SellerShippingProfileType();
      input = ConsoleUtil.readString("Enter your Seller Policy Shipping ProfileId : ");
      sellerShippingProfile.setShippingProfileID(Long.valueOf(input));
      sellerProfile.setSellerShippingProfile(sellerShippingProfile);
      
      //Set Return Policy ProfileId
      SellerReturnProfileType sellerReturnProfile=new SellerReturnProfileType();
        input = ConsoleUtil.readString("Enter your Seller Policy Return ProfileId : ");
        sellerReturnProfile.setReturnProfileID(Long.valueOf(input));
        sellerProfile.setSellerReturnProfile(sellerReturnProfile);
      
        //Add Seller Profile to Item
      item.setSellerProfiles(sellerProfile);
      return item;
  }
  
  /**
   * Populate eBay SDK ApiContext object with data input from user
   * @return ApiContext object
   */
  private static ApiContext getApiContext() throws IOException {
          
          //String input;
      ApiContext apiContext = new ApiContext();
      
      //set Api Token to access eBay Api Server
      ApiCredential cred = apiContext.getApiCredential();
      //input = ConsoleUtil.readString("Enter your eBay Authentication Token: ");
          cred.seteBayToken("AgAAAA**AQAAAA**aAAAAA**zurAVg**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wFk4GhD5WGoAydj6x9nY+seQ**dLQDAA**AAMAAA**64nPDSmSM3t1EGVdurVrBAUqE9wsxD7VbV8haF3iqvwKcKchagZKAxfRD0lgRLvrJuTP3ioayBdggmF7Q80tLpH42mTSr//yaa4tUFSl7SgAnks4IPl2DyDx3l+DatBGHOJ3x9br5XYRQfCFD6p1Kc/am7v6sJlPEdgQmHvrGf85VQkC4l7Xx3f9jKiW3usKRCuV4da/C3vMJTAleVJJbzW46ZS9OMNZqTtrap628tNgk/xy9iwknXX9DF6m6ZXEk2d+DVv4e0UG85vKG6wI49n1dxkmQcfOCh4hlwyRPUh0nN4umcJYIBoPu7NnyM+p/pz3z5vcNtVBe74NZhgLk4uyqESuFB/FV+NsXYCKT79V7g7Gldqe8sYy3PXo2l+UDsdzvGNWVAXrAZRpw9r64I7k/VapA7x+IokGmKU1hRwQIX0Z7QWwOKzgMNmz8/K9dxXad0oWS2kinoREBWEmNiorMUPU8mBblk45FzhMKaYR8vbkvcx/+ztllqc1JamQCSkKEYUAc9A3zifDF09f9RV/7HN5AsXluv68j9AkK6MfcO6Y+MhFxkmPIikRISevWZofxzpLGrcxoftQ3rZKARJB19/HLKpxxnpcUiqC2JztdRvlY6qvjAPhGDqqgyP88PDuDabs7Yl1+hpm5hOqUhMk9iBpRz2/iMlVY6XnOxTortj1qepK3yzyF7tTiM+voWKIoaIr0zqFhMByx5npz3AGaWwpL+3ndEi8DuPUOvP2UNnfaR4COcuNE6bvtzhk");
      //set Api Server Url
      apiContext.setApiServerUrl( "https://api.sandbox.ebay.com/wsapi" );  // sandbox

      return apiContext;
  }
  
  // build sample item specifics
  public static NameValueListArrayType buildItemSpecifics(){
          
          //create the content of item specifics
          NameValueListArrayType nvArray = new NameValueListArrayType();
          NameValueListType nv1 = new NameValueListType();
          nv1.setName("Origin");
          nv1.setValue(new String[]{"US"});
          NameValueListType nv2 = new NameValueListType();
          nv2.setName("Year");
          nv2.setValue(new String[]{"2010"});
          nvArray.setNameValueList(new NameValueListType[]{nv1,nv2});
                  
          return nvArray;
  }
}
