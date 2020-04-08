
<cfparam name="form.MailAddress" default="">

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    UserNames U 		
	<cfif form.MailAddress neq "">		
	WHERE 	U.Account IN (#preserveSingleQuotes(Form.MailAddress)#)
	<cfelse>
	WHERE    1=0
	</cfif>
	<cfif url.action eq "delete">
		AND Account != '#url.useraccount#'
	<cfelse>
		OR Account = '#url.useraccount#'	
	</cfif>
	
</cfquery>

<table style="width:100%">
													
		<cfoutput query="get">
		    <tr class="<cfif currentrow neq recordcount>line</cfif>">
		    <td class="labelit" style="padding-left:0px; color:black;">#LastName#</td>
			<td align="right" style="padding-top:2px;padding-left:2px;padding-right:4px">
			<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/Tools/EntityAction/Details/Comment/setMailAddress.cfm?objectid=#url.objectid#&action=delete&useraccount=#account#','mailselect','','','POST','entryform')">
			</td> 												
			</tr>
		</cfoutput>
		
	</table>
	
	<cfoutput>										
		<input type="hidden" id="mailaddress" name="mailaddress" 
		    value="#quotedvalueList(get.Account)#">
	</cfoutput>

		