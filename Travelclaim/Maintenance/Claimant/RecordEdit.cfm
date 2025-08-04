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

<cf_PreventCache>
  
<cfquery name="Get" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Claimant
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {
	  return true }
	return false
	}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- edit form --->

<table width="98%" cellspacing="2" cellpadding="2" align="center">

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
	   maxlenght = "40" class= "regular">
    </TD>
	</TR>
	
	
	<TR>
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="#get.ListingOrder#" message="please enter a valid number" style="text-align: center;" required="yes" size="1" 
	   maxlenght = "1" class= "regular">
    </TD>
	</TR>
	
	<TR>
    <TD>DSA reimbursements percentage:</TD>
    <TD>
  	   <cfinput type="Text" name="LinePercentage" value="#get.LinePercentage#" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="3" class="regular">
    </TD>
	</TR>
	
	
	
	</cfoutput>
	
	
</TABLE>

<cf_dialogBottom option="edit">
	
</CFFORM>


</BODY></HTML>