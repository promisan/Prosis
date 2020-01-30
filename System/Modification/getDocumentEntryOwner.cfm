<cfparam name="url.application" default="">

<cfquery name="GetOwner" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT Owner
			FROM   Ref_Application
			WHERE  Code = '#url.application#'

</cfquery>

<cfoutput>
	<input type="hidden" name="Owner" id="Owner" value="#GetOwner.Owner#">
</cfoutput>