
<cfif ParameterExists(Form.Save)>

	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Parameter
		SET    HoursWorkDefault       = #Form.HoursWorkDefault#, 	    
			   HoursInDay             = #Form.HoursInDay#		
		WHERE  Identifier           = '#Form.Identifier#'
	</cfquery>
	
	<cfoutput>
		<script>
			ColdFusion.navigate('ParameterGeneralSettings.cfm?idmenu=#URL.IDMenu#','contentbox1');
		</script>
	</cfoutput>


</cfif>	
	
