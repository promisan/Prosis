
<!--- get Reference --->

<cfquery name="get"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_SubmissionEditionPosition 		
	WHERE  SubmissionEdition = '#URL.id#'
	AND    PositionNo        = '#url.positionno#'
</cfquery>

<cfoutput>
		   
	<cfif get.reference eq "">
	  
		 <input type="checkbox" name="groupreference" value="#get.positionno#">
			 
	<cfelse>
	     	
		#get.reference#	
		
	</cfif>		

</cfoutput>	 
	  