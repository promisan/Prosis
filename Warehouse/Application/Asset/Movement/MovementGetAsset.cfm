
<!--- capture the selected assets and then load the screen for entry --->

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#AssetMove">

<cfinvoke component = "Service.Process.Materials.Asset"  
   method           = "AssetList" 
   mission          = "#url.mission#"
   children         = "1"
   assetid          = "#url.AssetId#"		
   table            = "#SESSION.acc#AssetMove2">		
     
<cfinclude template="MovementItems.cfm">   
