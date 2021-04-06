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



    //Set Generic attributes

    String name = "Digital Zone of Immaterial Pictorial Sensibility, Series " + str(series) + ", Edition " + str(edition) + ". (Wrapped)";

    masterJson.setString("name", name);  

    String image = "https://ipfs.io/ipfs/" + imageHash;

    masterJson.setString("image", image);

    String description = "Transferable wrapper for a single IKB token.";
    masterJson.setString("description", description);

    String externalURL = "https://chan.gallery";
    masterJson.setString("description", description);


    // Set all OpenSea attributes  
    String[] trait_types = {"Artist", 
      "Series", 
      "Edition", 
      "First Exhibited", 
      "Further Reading", 
      "Collector Information", 
      "Display Instructions"
    };

    String[] values = {"Mitchell F. Chan", 
      "S", 
      "E", 
      "InterAccess, Toronto. August 30, 2017.", 
      "The artist's statment and other essays discussing this artwork are available at chan.gallery/essays/IKB", 
      "Collector's rights are important. They are made explicit in the metadata .JSON file associated with this NFT.", 
      "The wrapper image has been created at 4K resolution with a 1:1 aspect ratio for online display. However, for fullscreen display on a typical aspect ratio screen, cropping the top and bottom of the image is OK. For information about the display value of the unwrapped Digital Zone of Immaterial Pictorial Sensibilty, please consult the Blue Paper."
    };

    JSONArray attributes = new JSONArray();  
    for (int i = 0; i < trait_types.length; i++) {
      JSONObject thisAttribute = new JSONObject();

      thisAttribute.setString("trait_type", trait_types[i]); 

      String s = values[i];  

      if (s.equals("E")) {
        series = edition;
        thisAttribute.setInt("value", edition);
      } else if (s.equals("S")) {
        thisAttribute.setInt("value", series);
      } else {
        thisAttribute.setString("value", s);
      }

      attributes.setJSONObject(i, thisAttribute);
    }
    masterJson.setString("Display Instructions", "The wrapper image has been created at 4K resolution with a 1:1 aspect ratio for online display. However, for fullscreen display on a typical aspect ratio screen, cropping the top and bottom of the image is OK. For information about the display value of the unwrapped Digital Zone of Immaterial Pictorial Sensibilty, please consult the Blue Paper.");

    masterJson.setJSONArray("attributes", attributes);


    //set all superRare attributes
    masterJson.setString("createdBy", name);
    masterJson.setString("yearCreated", "2017");

    JSONObject superRareMedia = new JSONObject();
    superRareMedia.setString("uri", image);
    String dimensions = "3840x3840";
    superRareMedia.setString("dimensions", dimensions);  
    //superRareMedia.setString("size", "15MB"); 
    superRareMedia.setString("mimeType", "image/png");

    masterJson.setJSONObject("media", superRareMedia);


    String legalIntent = "The rights of collectors and artists are important. The following terms are created with the intent of preserving the artist's moral rights over the artwork, while expanding the rights for collectors beyond existing Canadian copyright laws, in order to acknowledge emerging ways of displaying digital artworks." ;
    String legalTerms = "TERMS: THE ARTIST refers to Mitchell F. Chan --- THE COLLECTOR refers to the individual who can prove ownership or custody of the wallet or smart contract identified as ownerOf() the token associated with the artwork. --- THE ARTWORK refers to all of 1) The wIKB token itself; 2) the specific image identified in the metadata linked to that wIKB token; 3) the metadata of the wIKB token; 4) the specific IKB token which is held in the Wrapped IKB smart contract and which as an edition() value corresponding with the tokenID() value of the wIKB token owned by the collector; 5) the actual, immaterial Digital Zone of Immaterial Pictorial Sensibility which is linked to that IKB token.";
    String artistRights = "The artist retains copyright, image rights, and moral rights over the work. The artist shall earn a 10% royalty on secondary sales. The artist must be credited when the work is displayed. The artist WAIVES his right under Canadian copyright law to receive exhibition fees of this artwork. Collectors are free to display this artwork without further compensating the artist. The artist reserves the rights to display or exhibit reproductions of the artwork."; 
    String collectorRights = "The collector has full property ownership rights over the artwork. The collector has the right to display or present the artwork publicly or privately, on all media currently known or yet to be developed. The collector has the right to loan or lease the artwork. The collector has the right to resell the artwork.";

    masterJson.setString ("Legal Intent", legalIntent);
    masterJson.setString("Legal Terms", legalTerms);
    masterJson.setString("Collector Rights", collectorRights);
    masterJson.setString("Artist Rights", artistRights);

    String filename = nf(edition, 4);
    saveJSONObject(masterJson, "data/" + filename + ".json");
    println(edition + " " + imageHash);
  }
}
