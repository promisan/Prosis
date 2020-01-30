<cf_screentop height="100%" scroll="yes" jquery="Yes" html="No" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id1#">
<!--- 

1. define the selection date from the mandate
2. show people
--->

<cf_ListingScript>
					
<table width="100%" height="100%" cellspacing="0" cellpadding="0">						
					
<tr><td height="8"></td></tr>

<tr>
	<td height="30" style="padding-left:5px">
	
	     <cfset openmode = "yes">
		 <cfinclude template="../PersonViewHeaderToggle.cfm">
		
	</td>
</tr>

<tr><td align="center" height="100%">									

	<table width="98%" align="center" height="100%">
	
	<tr><td class="line" height="1"></td></tr>		
	<tr>
		<td height="100%"><cfinclude template="WorkOrderListingContent.cfm"></td>
	</tr>	
	</table>
	
	</td></tr>		
	
</table>	
					  