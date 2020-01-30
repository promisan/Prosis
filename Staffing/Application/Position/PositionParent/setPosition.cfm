
<!--- 


set position field 
store the value in the log fiels

--->

<cfif url.field eq "disableloan">

	<!--- init the position log or pass the serialno --->		  
	<cf_setPositionLog PositionNo="#url.PositionNo#" mode="prepare">
	
	<cfquery name="setPosition" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 UPDATE Position			 
			 SET    disableLoan =  <cfif url.value eq "true">0<cfelse>1</cfif>
			 WHERE  PositionNo = '#URL.PositionNo#'	 
	</cfquery>
		
	<!--- init the position log or pass the serialno --->		  
	<cf_setPositionLog PositionNo="#url.PositionNo#" mode="log" serialno="#serialno#">
		
		
</cfif>	