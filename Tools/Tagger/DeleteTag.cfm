
<!--- Define the request variables. --->
<cfparam name="url.id"  type="string" default=""/>
<cfparam name="FORM.id" type="string" default=""/>

<cfif url.id eq "">
	<cfset url.id = FORM.id>
</cfif>	


<!--- Delete the given tag. --->
	<cfquery name="qImages" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemImage 
		WHERE ImageId = '#URL.Id#'
	</cfquery>	

	
	
<cfoutput>#serializeJSON( URL.id )#</cfoutput>