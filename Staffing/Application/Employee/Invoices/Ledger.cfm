<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes"  menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
		
<cf_dialogLedger>	
<cf_dialogPosition>
<cf_dialogOrganization>
<cf_listingScript>

<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">

<tr class="linedotted">
	<td height="20" style="padding-left:0px">	
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	</td>
</tr>

<tr><td height="100%" valign="top">
			
	<cfinclude template="LedgerListing.cfm">
	
</td></tr></table>
