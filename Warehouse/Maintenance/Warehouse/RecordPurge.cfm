<cf_tl id = "Warehouse is in use. Operation aborted."                    var="msg3">

    <cfquery name="CountRec" 
     datasource="appsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    *
	     FROM      ItemWarehouse
	     WHERE     Warehouse  = '#url.id1#'
	</cfquery>

    <cfif CountRec.recordCount gt 0>
		 <cfoutput>
	     <script language="JavaScript">
	         alert("#msg3#")
	      </script>
		  </cfoutput>  
	 	 
    <cfelse>
		
		<cfquery name="Delete" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Warehouse 
				WHERE  Warehouse  = '#url.id1#'
	    </cfquery>
		
		<script language="JavaScript">   
		     parent.window.close();
			 opener.history.go();      
		</script>
		
		<!----
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	     action="Delete">--->
			
		
    </cfif>	
