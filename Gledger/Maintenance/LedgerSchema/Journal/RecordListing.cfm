<!--- Create Criteria string for query from data entered thru search form --->


<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes" systemmodule="Accounting" functionclass="Maintain" functionname="Journal" menuclass="Dialog">

<cf_listingscript>

<cfparam name="URL.ID" default="Hide">

<script>
	
	function recordadd(mis) {
	     ptoken.open("RecordAdd.cfm?mission="+mis, "Add", "left=80, top=80, width=880, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>

<table width="98%" align="center" height="100%">	

	<tr style="height:20px" class="line clsNoPrint">
		<td class="labellarge" style="font-size:43px;font-weight:200;padding-top:9px;padding-left:7px;height:43px"><cfoutput>#url.Mission#</cfoutput></td>	
	</tr>	

	<tr>
	<td colspan="2" valign="top">
	   <cfinclude template="RecordListingContent.cfm">
	</td>
	</tr>
			
</table>
		

