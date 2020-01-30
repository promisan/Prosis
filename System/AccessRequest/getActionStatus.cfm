

	<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   UserRequest
		<cfif url.ajaxid eq "">
		WHERE 1=0
		<cfelse>
		WHERE  RequestId = '#url.ajaxid#' 
		</cfif>		
	</cfquery>

	<cfif get.ActionStatus eq "9">
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="FF0000">This request was cancelled</font>
				
	</td></tr>
	</table>
	
	<cfelseif get.ActionStatus eq "3">
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="green">This request is completed</font>
				
	</td></tr>
	</table>
	
	
	<cfelse>
	
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="gray">This request is in process</font>
				
	</td></tr>	
	</table>
	
	
	</cfif>