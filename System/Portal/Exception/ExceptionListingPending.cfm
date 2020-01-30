
<cfquery name="Servers" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT HostServer
	FROM   UserError
	WHERE  ActionStatus IN ('0','1') 
	AND    EnableProcess = '1'
	AND    Created > GETDATE() - 7
	AND    HostServer > ''
	<cfif SESSION.isAdministrator eq "No">
	AND    (HostServer IN (SELECT DISTINCT GroupParameter 
	                       FROM   Organization.dbo.OrganizationAuthorization
						   WHERE  Role        = 'ErrorManager'
						   AND    UserAccount = '#SESSION.acc#')
			OR
			
			Account = '#SESSION.acc#'
			)		
	</cfif>			   
</cfquery>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="15" colspan="6"></td></tr>
		
	<tr> 
		<td style="height:25px;font-size:31px" colspan="5" align="left" class="labellarge">
		<cfoutput>
		<b>#session.welcome# Exception for review 
		</cfoutput>
		</td> 
		<td height="15" align="right" class="labelmedium"> 
			
				<input name="servers" id="servers" class="radiol" value="All" type="radio" onClick="ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionListingPendingDetail.cfm?hostserver=All','ldetail')" checked>
				<a href="javascript:servers[0].checked=true; ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionListingPendingDetail.cfm?hostserver=All','ldetail')">Any</a>
				<cfset index = 1>
				<cfoutput query="Servers">
					<input name="servers" id="servers" class="radiol" value="#HostServer#" onClick="ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionListingPendingDetail.cfm?hostserver='+this.value,'ldetail')" type="radio" >
					<a href="javascript:servers[#index#].checked=true;ColdFusion.navigate('#client.root#/System/Portal/Exception/ExceptionListingPendingDetail.cfm?hostserver=#HostServer#','ldetail')">#HostServer#</a>
					<cfset index = index + 1>
				</cfoutput>
			 </font>
		</td> 
	</tr>
	
	<tr>
	
	 <td height="15" colspan="6">	 	
		<cfdiv bind="url:#client.root#/System/Portal/Exception/ExceptionListingPendingDetail.cfm" id="ldetail">		
	 </td>
	 
	</tr>	
	
</table>
