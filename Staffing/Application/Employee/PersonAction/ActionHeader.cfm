
<cf_screentop height="100%" jQuery="Yes" scroll="yes" html="No" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<script language="JavaScript">

 function newaction(id) {
    ptoken.location ("ActionAdd.cfm?id="+id);
 } 
 
</script>

<cfset url.header = "0">

<cfset mde = url.mode>

<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "1">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
	<cf_ListingScript>
	
	<cfset url.mode = mde>
	
	<tr>
	<td height="100%">	
		<cfinclude template="ActionList.cfm">
	</td>
	</tr>

</table>


