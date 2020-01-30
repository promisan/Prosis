
<!--- remove workflow object, close screen and refresh the line --->

<cfquery name="get"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.positionno#'
	AND    Operational = 1
	AND    EntityCode = 'PositionReview'	
</cfquery>

<cfquery name="reset"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM OrganizationObject
	WHERE  ObjectKeyValue1 = '#url.positionno#'
	AND    Operational = 1
	AND    EntityCode = 'PositionReview'	
</cfquery>

<cfoutput>
	<script>
	    parent.document.getElementById("refresh_#url.box#").click()	
		parent.ColdFusion.Window.destroy('mystaff',true)	
	</script>

</cfoutput>

