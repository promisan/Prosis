
<!--- configuration file --->

<cf_screentop html="No" scroll="Yes" jquery="Yes">

<cf_listingscript>

<cfoutput>

<table width="100%" style="height:100%;" align="center"> 
	
	<tr>
		<td id="mainlisting" valign="top" style="padding-left:8px;height:99%">		
			<cf_securediv id="divListing" style="height:100%;" bind="url:#SESSION.root#/System/Modules/Subscription/ListingDistributionDetailContent.cfm?row=#url.row#&id=#url.id#">        	
		</td>
	</tr>
	
</table>				     
			
</cfoutput>	