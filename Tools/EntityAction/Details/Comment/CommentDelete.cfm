
<cf_param name="url.objectid" default="" type="string">
<cf_param name="url.Threadid" default="" type="string">
<cf_param name="url.serialNo" default="" type="string">

<!--- delete --->

<cfquery name="delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   OrganizationObjectActionMail
		WHERE  ThreadId  = '#url.Threadid#'
		AND    SerialNo  = '#url.serialNo#'		
</cfquery>

<cfset vURLObjectId = replace(url.objectId,"-","","ALL")>

<cfoutput>
<script language="JavaScript">
  
   // refresh view
   
	_cf_loadingtexthtml='';	  
   ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/CommentListingContent.cfm?objectid=#url.objectid#','communicatecomment_#vURLObjectId#')
   
</script>
</cfoutput>
