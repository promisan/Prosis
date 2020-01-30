
<cfquery name="MissionList" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Mission
	FROM   ItemMasterMission	
	WHERE Itemmaster IN (SELECT Code 
	                     FROM   ItemMaster 
						 WHERE  Mission = '#url.mission#') 
</cfquery>

 <select name="usage" id="usage" class="regularxl" onChange="search('<cfoutput>#URL.view#</cfoutput>')">
			
    <option value= "">All Items	
	<cfoutput query="MissionList">
	 <option value="#Mission#">Only #Mission# associated
	</cfoutput>
	
</select>