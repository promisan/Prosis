
<!--- -------------------- --->
<!--- preparation template --->
<!--- -------------------- --->

<cf_screentop height="100%" scroll="yes" html="No" menuaccess="context" jquery="Yes" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<table width="100%" height="100%">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "1">		
	      <cfset openmode = "show"> 		  
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
	<tr>
	<td height="100%" style="padding-left:10px;padding-right:10px">
	<cfinclude template="RequestListContent.cfm">
	</td>
	</tr>
	
</table>

<cf_ListingScript>

