<cfquery name="ResetGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   Ref_EntityActionDocument 
		WHERE  ActionCode = '#URL.ActionCode#'
</cfquery>

<cfparam name="Form.Document" type="any" default="">

	<cfloop index="Item" 
       list="#Form.Document#" 
       delimiters="' ,">

			<cfquery name="InsertGroup" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_EntityActionDocument
			         (ActionCode,DocumentId)
			VALUES ('#URL.ActionCode#', '#Item#')
		    </cfquery>
			  
	</cfloop>	
	
<cfinclude template="ActionRecordsEmbed.cfm">	