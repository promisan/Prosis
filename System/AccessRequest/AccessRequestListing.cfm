

<cf_screentop html="no" jquery="Yes">
<cf_SystemScript>
<cf_ListingScript>

<cfoutput>
	
	<script>
				
		function addRequestAccess(context) {					
			window.open("#SESSION.root#/System/AccessRequest/DocumentEntry.cfm?context=" + context + "&ts="+new Date().getTime(), "accessrequest", "left=40, top=40, width=920,height=830, status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>



<cfset currrow = 0>

<cf_wfpending entityCode="AuthRequest"  
      table="#SESSION.acc#wfAuthorization" mailfields="No" includecompleted="No">		


<table width="100%" height="100%"><tr><td style="padding:10px">  
<cfinclude template="AccessRequestListingContent.cfm">
 </td></tr></table>		

	