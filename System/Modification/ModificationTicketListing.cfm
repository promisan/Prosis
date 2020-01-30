
<cfparam name="URL.observationclass"   default="Inquiry">
<cfparam name="URL.context"            default="status">
<cfparam name="URL.contextid"          default="">
<cfparam name="URL.systemfunctionid"   default="">

<cf_screentop html="no" jquery="yes">
<cf_SystemScript>
<cf_ListingScript>

<cfoutput>
	
	<script>
	
		function addRequest(context,oclass) {		
		    w = #CLIENT.width# - 70;
		    h = #CLIENT.height# - 160;				
			window.open("#SESSION.root#/System/Modification/DocumentEntry.cfm?observationclass=" + oclass + "&context=" + context, "amendment", "left=40, top=20, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>

<cfset currrow = 0>
	
<cf_wfpending entityCode="SysTicket"  
      table="#SESSION.acc#wfSysTicket" mailfields="No" includecompleted="No">	
	  
<table width="100%" height="100%">
 <tr>
 <td style="padding-left:13px;padding-right:13px;padding-bottom:1px">  
 <cfinclude template="ModificationTicketListingContent.cfm">		
 </td>
 </tr>
</table>	
