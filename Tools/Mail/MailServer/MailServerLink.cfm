
<cfquery name="SysParam" 
datasource="AppsSystem">
	SELECT *
	FROM   Parameter	
</cfquery>

<cfif SysParam.ExchangeServerURL neq "">

	<cfoutput>
		<a href="#SysParam.ExchangeServerURL#" target="_blank" title="Go to Mail"><b>#Attributes.Name#</b></a>
	</cfoutput>

</cfif> 