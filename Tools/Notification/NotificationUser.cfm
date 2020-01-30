

<cfquery name="GetUsers" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT E.HostName, U.*
		 FROM   SystemEventServerUser E
		 		INNER JOIN UserNames U
					ON E.Account = U.Account
		 WHERE  EventId = '#url.drillid#'
		 
</cfquery>


<cfif GetUsers.recordcount gt 0>


	<cf_divscroll>
	
	<table cellpadding="0" cellspacing="0" align="center" width="90%">
	
	<tr><td height="20"></td></tr>
	
	<tr>
		<td class="labelmedium">
			<b>Users that have seen this notification</b>
		</td>
	</tr>
	
	<tr>
		<td height="10"></td>
	</tr>
	
	<cfoutput query="GetUsers" group="Hostname">
		
		<tr>
			<td style="padding-left:15px;" class="labellarge">
				#Hostname#
			</td>
		</tr>
		
		<tr>
			<td class="linedotted">
			</td>
		</tr>
		
		<tr>
			<td>
				<table>
					<tr>
  						<td width="25%">Account</td> 
						<td width="25%">Name</td> 
						<td width="25%">IndexNo</td> 
						<td width="25%">eMailAddress</td>
					</tr>
					<cfoutput>
						
						<tr>
							<td>#Account#</td> 
							<td>#FirstName# #LastName#</td> 
							<td>#IndexNo#</td> 
							<td>#eMailAddress#</td>
						</tr>
						
					</cfoutput>
				</table>
			</td>
		</tr>
			
	</cfoutput>
	
	</table>
	
	</cf_divscroll>
	
<cfelse>

	<table align="center">
		<tr>
			<td style="padding-top:30px;" class="labellarge" align="center">
				At this moment nobody have seen this event.
			</td>
		</tr>
	</table>

</cfif>