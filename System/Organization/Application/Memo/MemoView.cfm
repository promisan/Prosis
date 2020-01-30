
<cfparam name="url.owner" default="">
<cfparam name="url.memo" default="1">

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>

<table width="97%" align="center">
	
	<cfif url.memo eq "1">
							
		<tr>
			<td style="padding-top:4px">		
				<cfdiv bind="url:../memo/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo"/>		
			</td>
		</tr>
	
	</cfif>	
	
<cfparam name="url.memo" default="1">

<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfif url.memo eq "1">
				
		<tr>
			<td><cfdiv bind="url:../memo/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#" id="imemo"/></td>
		</tr>
	
	</cfif>
	
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Parameter
		WHERE  Identifier = 'A'
	</cfquery>
				
	<tr>	
	<td style="padding-left:10px">
	
	<cf_filelibraryN
		DocumentPath="Organization"
		SubDirectory="#URL.ID#" 
		Filter="#url.owner#"
		Insert="yes"
		Box="1"
		Remove="yes"
		ShowSize="yes">	

	</td>
	</tr>

</table>

