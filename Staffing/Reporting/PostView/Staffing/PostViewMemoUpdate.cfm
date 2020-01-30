
<cftry> 
	
	<cfquery name="UpdatePosition1" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	  	UPDATE Position
		SET    Remarks      = '#URL.remarks#'
		WHERE  PositionNo   = '#URL.PositionNo#'
	</cfquery>	
	
	<cfoutput>#URL.remarks#</cfoutput>
	
   <cfcatch>
   
   <font color="#FF0000">Memo could not be updated as it exceeds the maximum size of 300 characters.</font>

   </cfcatch>	
   
</cftry>
	