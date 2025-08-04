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
<cfparam name="url.idmenu" default="">

<HTML><HEAD>
	<TITLE>Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
  
<cfquery name="Get" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ClaimEvent
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {
	  return true }
	return false
	}	

</script>


<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="98%" cellspacing="3" cellpadding="3" align="center">

    <cfoutput>
    <TR>
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="2" maxlength="2"class="regular">
	   <input type="hidden" name="CodeOld" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" required=  "yes" size="40" 
	   maxlenght="40" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Icon file name:</TD>
    <TD>
  	   <cfinput type="text" name="Image" value="#get.Image#" required="no" size="20" maxlength="20" class= "regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Reference:</TD>
    <TD>
  	   <cfinput type="Text" name="Reference" value="#get.Reference#" required="No" visible="Yes" enabled="Yes" size="1" maxlength="4" class="regular">
    </TD>
	</TR>
				
	<TR>
	<td>
	Requires entry flight/travel No:
	</td>
	<TD>
	   <input type="radio" name="PointerReference" value="1" <cfif Get.PointerReference eq "1">checked</cfif>>Enabled
	   <input type="radio" name="PointerReference" value="0" <cfif Get.PointerReference eq "0" or get.PointerReference eq "">checked</cfif>>Disabled
    </TD>
	</TR>
	
	<TR>
	<td>
	Calculate Terminal expenses:
	</td>
	<TD>
	   <input type="radio" name="PointerTerminal" value="1" <cfif Get.PointerTerminal eq "1">checked</cfif>>Enabled
	   <input type="radio" name="PointerTerminal" value="0" <cfif Get.PointerTerminal eq "0" or Get.PointerTerminal eq "">checked</cfif>>Disabled
    </TD>
	</TR>
	
	<TR>
	<td>
	Express Claim:
	</td>
	<TD>
	   <input type="radio" name="PointerExpress" value="1" <cfif Get.PointerExpress eq "1">checked</cfif>>Enabled
	   <input type="radio" name="PointerExpress" value="0" <cfif Get.PointerExpress eq "0" or Get.PointerExpress eq "">checked</cfif>>Disabled
    </TD>
	</TR>
	
	<TR>
	<td>
	<cftooltip tooltip="By default check any transporation indicators">Check Transportation Indicators:</cftooltip>
	</td>
	<TD>
	   <input type="radio" name="PointerTransport" value="1" <cfif Get.PointerTransport eq "1">checked</cfif>>Yes
	   <input type="radio" name="PointerTransport" value="0" <cfif Get.PointerTransport eq "0" or Get.PointerTransport eq "">checked</cfif>>No
    </TD>
	</TR>	
		
	<TR>
	<td>
	Set as default:
	</td>
	<TD>
	   <input type="radio" name="PointerDefault" value="1" <cfif Get.PointerDefault eq "1">checked</cfif>>Yes
	   <input type="radio" name="PointerDefault" value="0" <cfif Get.PointerDefault eq "0" or Get.PointerDefault eq "">checked</cfif>>No
    </TD>
	</TR>	
	
	<TR>
	<td>
	Operational:
	</td>
	<TD>
	   <input type="radio" name="Operational" value="1" <cfif Get.Operational eq "1" or Get.Operational eq "">checked</cfif>>Yes
	   <input type="radio" name="Operational" value="0" <cfif Get.Operational eq "0">checked</cfif>>No
    </TD>
	</TR>	
	
	</cfoutput>
		
</TABLE>


<cfquery name="CountRec" 
      datasource="AppsTravelClaim" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT EventCode
      FROM ClaimEventTrip
      WHERE EventCode  = '#get.Code#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		<cfset del = "0">
	<cfelse>
	    <cfset del = "1">	
	</cfif>	
	
<cfif url.id1 eq "0">	
	<cf_dialogBottom allowdelete="#del#" option="add">
<cfelse>
	<cf_dialogBottom allowdelete="#del#" option="edit">
</cfif>
	
</CFFORM>


</BODY></HTML>