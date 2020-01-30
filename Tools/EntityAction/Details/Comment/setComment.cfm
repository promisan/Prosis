
<!--- set --->

<cfswitch expression="#url.field#">

<cfcase value="mailscope">

	<cfquery name="set" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OrganizationObjectActionMail
		SET #url.field# = '#url.value#'
		WHERE  ThreadId  = '#url.Threadid#'
		AND    SerialNo  = '#url.serialNo#'		
	</cfquery>
	
	<cfoutput>
	
		<cfif url.value eq "all">
			<font color="gray"><u><cf_tl id="public"></u></font>
			<input type="hidden" id="mailscope_#url.threadid#_#url.serialno#" value="support">
		<cfelse>
		    <font color="6688aa"><u><cf_tl id="support"></u></font>
			<input type="hidden" id="mailscope_#url.threadid#_#url.serialno#" value="all">
		</cfif>
	
	</cfoutput>

</cfcase>

</cfswitch>