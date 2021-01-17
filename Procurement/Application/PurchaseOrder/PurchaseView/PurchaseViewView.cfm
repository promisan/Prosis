
<cf_screenTop height="100%" html="No" scroll="yes" jquery="yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_DialogStaffing>

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cf_listingscript>

<cfoutput>
	
	<script>
		
		function reloadForm(page,sort,view) {	   
		     ptoken.navigate('PurchaseViewListing.cfm?view='+view+'&sort='+sort+'&Period=#URL.Period#&Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#&Page=' + page,'detail');
		}
		
		function print(po) {
			 w = #CLIENT.width# - 100;
			 h = #CLIENT.height# - 140;
			 ptoken.open("PurchaseViewPrint.cfm?ID1="+po,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
		}
	
		$(document).ready(function(){
			doHighlight();
		});	
		
	
	</script>

</cfoutput>


<table width="100%" height="100%" cellspacing="0" cellpadding="0">
    <cfif url.id eq "Loc">
	<tr><td height="100">
		<cfinclude template="PurchaseViewLocate.cfm">
	</td></tr>
	<tr><td height="100%" valign="top" style="padding-left:4px;padding-right:4px">
	    <cf_divscroll style="height:100%" id="detail"/>			
	</td></tr>
	<cfelse>
	<tr><td height="100%" valign="top" style="padding-left:4px;padding-right:4px">
	    <cfdiv id="detail" style="height:100%">		
		  <cfinclude template="PurchaseViewListing.cfm">
		</cfdiv>   
		</td>
	</tr>	
	</cfif>
</table>
