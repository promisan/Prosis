<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop height="100%" scrolll="No" html="No" jquery="Yes">

<cf_DialogProcurement>
<cf_DialogOrganization>
<cf_listingscript>

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">

<cfoutput>

<script>

function reloadForm(page,sort,view) {
   ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseViewListing.cfm?view='+view+'&sort='+sort+'&Period=#URL.Period#&Mission=#URL.Mission#&ID=VED&ID1=#URL.ID#&Page=' + page,'detail');
}

function print(po) {
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Tools/Mail/MailPrepare.cfm?Id=Print&ID1="+po+"&ID0=Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}

</script>

</cfoutput>

<table width="100%" height="100%">
    <tr><td height="90">
	    <cfinclude template="UnitView/UnitViewHeader.cfm">		
	</td></tr>
	<tr><td height="90%" style="padding-left:5px;padding-right:5px" valign="top">
		<cf_securediv style="height:100%" 
		   bind="url:#SESSION.root#/Procurement/Application/PurchaseOrder/PurchaseView/PurchaseViewListing.cfm?systemfunctionid=#url.systemfunctionid#&id=VED&id1=#URL.ID#" 
		   id="detail">
	</td></tr>	
</table>
