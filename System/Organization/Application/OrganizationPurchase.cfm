
<cf_screentop height="100%" scrolll="No" html="No" jquery="Yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_listingscript>

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">

<cfoutput>

<script>

function reloadForm(page,sort,view) {
   ColdFusion.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseViewListing.cfm?view='+view+'&sort='+sort+'&Period=#URL.Period#&Mission=#URL.Mission#&ID=VED&ID1=#URL.ID#&Page=' + page,'detail');
}

function print(po) {
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  window.open("<cfoutput>#SESSION.root#</cfoutput>/Tools/Mail/MailPrepare.cfm?Id=Print&ID1="+po+"&ID0=Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}

</script>

</cfoutput>

<table width="100%" height="100%">
    <tr><td height="90">
	    <cfinclude template="UnitView/UnitViewHeader.cfm">		
	</td></tr>
	<tr><td height="90%" style="padding-left:5px;padding-right:5px" valign="top">
		<cfdiv style="height:100%" bind="url:#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseViewListing.cfm?systemfunctionid=#url.systemfunctionid#&id=VED&id1=#URL.ID#" id="detail"/>
	</td></tr>	
</table>
