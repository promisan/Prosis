<!--- roster action header --->

<cfparam name="Attributes.Class"  default="">

<cfset l = left(CreateUUID(),22)>
<cfset r = right(CreateUUID(),12)>
<cfset guid = "#l#7-#r#">

<!--- to be removed 

<cfif attributes.class eq "SystemFunctionId">
		
	<cfquery name="AddId" 
	datasource="AppsSystem">
		INSERT INTO UserStatusLoad
			   (Account,
			    HostName,
				NodeIP,
				SystemFunctionId,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
		VALUES ('#SESSION.acc#',
				'#cgi.http_host#',
				'#CGI.Remote_Addr#',
				'#guid#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#') 
	</cfquery>

</cfif>

--->

<CFSET Caller.RowGuid = guid>
