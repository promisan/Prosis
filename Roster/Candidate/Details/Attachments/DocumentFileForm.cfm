
<cfparam name="url.memo" default="1">

<table width="100%">
	
	<cfif url.memo eq "1">
		
		<tr><td height="4"></td></tr>
		<tr class="line"><td><font size="3" color="gray"><cfoutput><cf_tl id="Memo"></cfoutput></font></td></tr>
				
		<tr>
		<td>		
		<cfdiv bind="url:attachments/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo"/>		
		</td>
		</tr>
	
	</cfif>
	
	
<cfparam name="url.memo" default="1">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<cfif url.memo eq "1">
				
		<tr><td height="1" class="linedotted"></td></tr>
				
		<tr>
		<td>		
		<cfdiv bind="url:attachments/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo"/>		
		</td>
		</tr>
	
	</cfif>
	
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
		WHERE Identifier = 'A'
	</cfquery>
		
	<tr class="line"><td height="20" bgcolor="white" class="labelmedium"><cfoutput><cf_tl id="Profile documents"> for #url.owner#</cfoutput></td></tr>
				
	<tr>	
	<td>		
	<cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#URL.ID#" 
		Filter="#url.owner#"
		Insert="yes"
		Box="#url.owner#"
		Remove="yes"
		ShowSize="yes">	
	</td>
	</tr>

</table>
