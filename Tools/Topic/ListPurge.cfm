
<cfquery name="Delete" 
	     datasource="#alias#" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_TopicList
		 WHERE Code = '#URL.Code#'
		 AND ListCode = '#URL.id2#'
</cfquery>


<cfset url.id2="new">
<cfinclude template="List.cfm">
