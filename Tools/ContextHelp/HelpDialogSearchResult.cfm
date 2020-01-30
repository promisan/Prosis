
<cfparam name="url.val" default="">

<cfquery name="Help" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  HelpProjectTopic
			<cfif url.mode eq "Project">
			WHERE 1=1 <!--- ProjectCode = '#URL.ProjectCode#' --->			
			<cfelse>
			WHERE  SystemFunctionId = '#url.systemfunctionid#'			
			</cfif>
			AND   ( TopicName LIKE '%#url.val#%' OR 
			        UITextQuestion LIKE '%#url.val#%' OR 
					UITextAnswer LIKE '%#url.val#%' 
				   )			
</cfquery>

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<tr><td height="1"></td></tr>

<cfloop query="Help">
	<tr class="navigation_row">
	<td width="20" height="16" style="padding-left:10px">
		<cf_img icon="open" onclick="reloadtext('#TopicId#')" navigation="Yes">
	</td>
	<td class="labelit">#TopicName#</td>
	</tr>

</cfloop>

</table>

<cfset ajaxonload("doHighlight")>

</cfoutput>