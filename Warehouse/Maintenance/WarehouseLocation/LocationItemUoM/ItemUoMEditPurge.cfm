
<cfquery name="get" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 SELECT * 
		 FROM ItemWarehouseLocation			
		 WHERE ItemLocationId     = '#url.drillid#'	  			
</cfquery>	

<cfquery name="PurgeItem" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 DELETE FROM ItemWarehouseLocation			
		 WHERE ItemLocationId     = '#url.drillid#'	  			
</cfquery>	


<cfoutput>

	<script>	   
	   try {				
		opener.applyfilter('1','','#url.drillid#') } catch(e) {}    	
		window.close()    			
	</script>	
	
</cfoutput>