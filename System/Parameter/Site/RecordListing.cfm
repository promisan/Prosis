<cf_listingscript>

<cfoutput>

<script>
	function recordadd() {
    	 window.open("RecordEdit.cfm?mode=add&idmenu=#url.idmenu#", "Add", "left=80, top=80, width=800,height=690, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
</script>  
                     
</cfoutput>		

<cfset url.systemfunctionid = url.idmenu>

<cfparam name="page"        default="1">
<cfparam name="add"         default="0">
<cfparam name="save"        default="0">
<cfparam name="option"      default="">
<cfparam name="header"      default="">
<cfparam name="URL.IDRefer" default="">
<cfparam name="URL.IDMenu"  default="">

<cf_screentop height="100%" scroll="Yes" html="No">

<table width="100%" 
       height="100%" 
	   align="center" 
	   border="0" 
	   cellspacing="0" 
	   cellpadding="0">
	   
	<tr><td height="40">
		
		<cfset Page         = "0">		
		<cfinclude template="../HeaderParameter.cfm"> 
	
	</td></tr>
	
	<tr>
	<td height="100%" valign="top">
	
		<table width="98%" height="100%" align="center">
		
		<tr><td height="99%" align="center" style="padding-left:15px;padding-right:15px">
		      <cfinclude template="RecordListingContent.cfm">	
		</td></tr>
		
		</table>
		
	</td>
	</tr>

</table>