

<cfparam name="URL.observationclass"   default="Amendment">
<cfparam name="URL.context"            default="status">
<cfparam name="URL.contextid"          default="">

<cf_screentop html="no" jquery="Yes">
<cf_SystemScript>
<cf_ListingScript>


<cfoutput>
	
	<script>
	
		function addRequest(context,oclass) {		
		    w = #CLIENT.width# - 80;
		    h = #CLIENT.height# - 150;				
			ptoken.open("#SESSION.root#/System/Modification/DocumentEntry.cfm?observationclass=" + oclass + "&context=" + context + "&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>

<cfset currrow = 0>

<cf_wfpending entityCode="SysChange"  
      table="#SESSION.acc#wfSysChange" mailfields="No" includecompleted="No">		

<table width="100%" height="100%">
 <tr>
 <td style="padding-left:13px;padding-right:13px;padding-bottom:1px">  
 <cfinclude template="ModificationAmendmentListingContent.cfm">	
 </td>
 </tr>
</table>	


	