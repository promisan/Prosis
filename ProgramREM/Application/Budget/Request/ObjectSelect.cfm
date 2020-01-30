
<cfoutput>

<cfif find(url.objectcode,prior)>

	<input type="text" id="selectme" value="#url.prior#">
	
<cfelse>

	<input type="text" id="selectme" value="#url.prior#,#url.objectcode#">	

</cfif> 

</cfoutput>