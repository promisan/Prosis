<cf_screentop html="yes" label="Customer view #url.mission#" layout="webapp" jquery="yes">

<cf_ListingScript>

<cfoutput>

	<script language = "JavaScript">
	
		function addCustomer(){			
			  ptoken.open("CustomerEditTab.cfm?mission=#url.mission#", "AddCustomer", "left=40, top=40, width=930, height= 670, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>

</cfoutput>

<table width="97%" height="100%" align="center">
 
 <tr>
 
   <td height="100%" style="padding-top:5px;padding-bottom:5px">
    <cfset url.systemfunctionid = url.idmenu>
    <cfinclude template="CustomerViewListing.cfm"> 
   </td>
 </tr>
 

</table>