

<cfquery name = "Insert" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
		UPDATE Ref_ClaimType
		SET	   Description = '#Form.Description#',
			   Claimant = '#Form.Claimant#',			  
			   Operational ='#Form.Operational#'
		WHERE  Code = '#Form.Code#'			
</cfquery>

<cfoutput>
	<script>
	ColdFusion.navigate('RecordEditHeader.cfm?id1=#Form.Code#','editheader');
	ColdFusion.navigate('RecordEditTab.cfm?id1=#Form.Code#','mainEdit');
	</script>
</cfoutput>