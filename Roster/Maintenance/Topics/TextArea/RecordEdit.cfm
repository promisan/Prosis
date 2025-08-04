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

<HTML><HEAD>
	<TITLE>Reference Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_TextArea
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this topics?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Edit">

<!--- edit form --->

<table width="92%">

    <cfoutput>
    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD>Domain:</TD>
    <TD>
	   <select name="TextAreaDomain">
					<option value="Preliminary" <cfif #get.TextAreaDomain# eq "Preliminary">selected</cfif>>Preliminary Interview</option>
					<option value="Bucket" <cfif #get.TextAreaDomain# eq "Bucket">selected</cfif>>Roster bucket/Vacancy Interview</option>
					<option value="JobProfile" <cfif #get.TextAreaDomain# eq "JobProfile">selected</cfif>>Job Profile</option>
		</select>
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40"class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Text area rows:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="NoRows" value="#get.NoRows#" message="Please enter an integer value" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="2" class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD>Entry mode:</TD>
    <TD>
	  <input type="radio" name="EntryMode" value="Regular" <cfif #get.EntryMode# eq "Regular">checked</cfif>>Standard
	  <input type="radio" name="EntryMode" value="Editor" <cfif #get.EntryMode# eq "Editor">checked</cfif>>Editor
     </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="regular">Explanation:</TD>
    <TD class="regular">
	   <textarea cols="50" rows="7" name="Explanation" class="regular">#get.explanation#</textarea>
   </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	</cfoutput>
	
</TABLE>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button7" type="submit" name="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>


</BODY></HTML>
