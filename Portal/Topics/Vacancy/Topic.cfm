

<script>
	
	function listing(mission,box,ent,code) {
			
		icM  = document.getElementById("d"+box+"Min")
	    icE  = document.getElementById("d"+box+"Exp")
		se   = document.getElementById("d"+box);
		frm  = document.getElementById("i"+box);
		 		 
		if (se.className=="hide") {
		 	 icM.className = "regular";
		     icE.className = "hide";
	    	 se.className  = "regular";
			
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
			 se.className  = "hide"	 
		 }		 		
	  }
  
</script>  

<cfparam name="SystemFunctionId" default="#URL.ID#">
<cfparam name="URL.Mode" default="Portal">

<cfoutput>


<cfquery name="cleanse"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE OrganizationObject
	WHERE ObjectId IN (
		     SELECT ObjectId
		     FROM   OrganizationObject O
		     WHERE  EntityCode = 'VacCandidate' 
			 AND    ObjectReference2 != 'Embedded workflow'
			 AND    NOT EXISTS
        	                (SELECT  'X' AS Expr1
            	             FROM    Vacancy.dbo.DocumentCandidate
                	         WHERE   DocumentNo = O.ObjectKeyValue1 
							 AND     PersonNo = O.ObjectKeyValue2))
</cfquery>			

<cfquery name="Mission" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM     UserModuleCondition C
	WHERE    C.Account   = '#SESSION.acc#'
	AND      C.SystemFunctionId = '#SystemFunctionId#'  
</cfquery>

<cfloop query="Mission">

	<cf_pane id="Vacancy_#conditionvalue#" search="No">
	
	<cf_paneItem id="Vacancy_#conditionvalue#_1" 
				source="#session.root#/Vactrack/Application/ControlView/ControlListing.cfm?mode=portal&mission=#conditionvalue#&detail=No"
				width="95%"
				height="auto"
				Mission="#conditionvalue#"											
				Label="#conditionvalue# Outstanding Recruitment Tracks"
				filterValue="Staffing">
										
	</cf_pane>		

</cfloop>

</cfoutput>



