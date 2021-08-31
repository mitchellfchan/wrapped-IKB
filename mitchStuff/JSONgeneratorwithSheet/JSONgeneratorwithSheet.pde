JSONObject masterJson;
JSONArray values;
Table table;
int edition;
String imageHash;
int series = 0;
void setup() {





  table = loadTable("source/imageHashes.csv");
  println(table.getRowCount());
  println(table.getInt(0, 0));
  println(table.getString(0, 1));




  for (TableRow row : table.rows()) {
    masterJson = new JSONObject();
    edition = row.getInt(0);
    imageHash = row.getString(1);

    // Find Series based on edition
    if (edition <=30) series = 0;
    else if (edition <= 40) series = 1;
    else if (edition <= 50) series = 2;
    else if (edition <= 60) series = 3;
    else if (edition <= 70) series = 4;
    else if (edition <= 80) series = 5;
    else if (edition <= 90) series = 6;
    else series = 7;



    //Set Generaic attributes

    String name = "Digital Zone of Immaterial Pictorial Sensibility, Series " + str(series) + ", Edition " + str(edition) + ". (Wrapped)";

    masterJson.setString("name", name);  

    String image = "https://ipfs.io/ipfs/" + imageHash;

    masterJson.setString("image", image);

    String description = "Transferable wrapper and receipt for a single IKB token.";
    masterJson.setString("description", description);

    String externalURL = "https://chan.gallery";
    masterJson.setString("description", description);


    // Set all OpenSea attributes  
    JSONArray attributes = new JSONArray();  
      JSONObject object0 = new JSONObject();
      //object0.setString("display_type", "string");
      object0.setString("trait_type", "Artist");
      object0.setString("value", "Mitchell F. Chan");
      attributes.setJSONObject(0, object0);
      
      JSONObject object1 = new JSONObject();
      //object1.setString("display_type", "string");
      object1.setString("trait_type", "Essay (IPFS)");
      object1.setString("value", "QmcdKPjcJgYX2k7weqZLoKjHqB9tWxEV5oKBcPV6L8b5dD");
      attributes.setJSONObject(1, object1);
      
      JSONObject object2 = new JSONObject();
      //object2.setString("display_type", "string");
      object2.setString("trait_type", "Collector Information (IPFS)");
      object2.setString("value", "QmWh4gvtmXkrhA5dG6wKkqe5keNnUUziFq28t3qbsYdGDz");
      attributes.setJSONObject(2, object2);
      
     JSONObject object3 = new JSONObject();
      object3.setString("display_type", "date");
      object3.setString("trait_type", "First Exhibited");
      object3.setInt("value", 1504139939); 
      attributes.setJSONObject(3, object3);
      
      JSONObject object4 = new JSONObject();
      object4.setString("display_type", "number");
      object4.setString("trait_type", "Edition");
      object4.setInt("value", edition); 
      attributes.setJSONObject(4, object4);
      
      JSONObject object5 = new JSONObject();
      object5.setString("display_type", "number");
      object5.setString("trait_type", "Series");
      object5.setInt("value", series);
      attributes.setJSONObject(5, object5);
      
     
   
    masterJson.setJSONArray("attributes", attributes);


    //set all superRare attributes
    masterJson.setString("createdBy", "Mitchell F. Chan");
    masterJson.setString("yearCreated", "2017");

    JSONObject superRareMedia = new JSONObject();
    superRareMedia.setString("uri", image);
    String dimensions = "3840x3840";
    superRareMedia.setString("dimensions", dimensions);  
    //superRareMedia.setString("size", "15MB"); 
    superRareMedia.setString("mimeType", "image/png");

    masterJson.setJSONObject("media", superRareMedia);


    //String filename = nf(edition, 4);
    saveJSONObject(masterJson, "data/" + edition + ".json");
    println(edition + " " + imageHash);
  }
}
