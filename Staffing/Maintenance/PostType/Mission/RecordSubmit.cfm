
<cfquery name="Check"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM   Ref_PostTypeMission
	WHERE  PostType = '#url.posttype#'
	AND    Mission  = '#Form.Mission#'

</cfquery>

<cfif Check.recordcount eq 1>

	<cfoutput>
		<script>
			alert('Mission #Form.Mission# has been already associated to this Post Type');
		</script>
	</cfoutput>

<cfelse>

	<cfquery name="Insert"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO Ref_PostTypeMission
					VALUES(
						'#url.PostType#',
						'#Form.Mission#',
						'#SESSION.acc#',
					    '#SESSION.last#',		  
						'#SESSION.first#',
						getDate()
					)
		
	</cfquery>

</cfif>

<cfinclude template="RecordListing.cfm">