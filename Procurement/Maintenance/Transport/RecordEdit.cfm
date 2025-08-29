<!--
    Copyright © 2025 Promisan B.V.

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
	<TITLE>Type of Transportation</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<cf_PreventCache>
  
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_transport
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this record?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<cf_dialogTop text="Edit">

<!--- edit form --->

<table width="100%">

	<tr>
	<td height="1" ></td>
	<td width="15%"></td>
	<td ></td>
	</tr>
	
    <cfoutput>
	<!--- Field: Code--->
	 <TR>
	 <TD class="regular"  width="60%">Code:&nbsp;</TD>  
	 <TD class="regular">
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regular">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regular">
	 </TD>
	 </TR>
	
	<tr><td height="4"></td></tr>
	
	<!--- Field: Description --->
    <TR>
    <TD class="regular">Description:&nbsp;</TD>
    <TD class="regular">
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regular">
				
    </TD>
	</TR>

	

	<tr><td height="4"></td></tr>
	<!--- Field: Tracking --->	
	<TR>
    <td class="regular">Tracking:&nbsp;</td>
	<td class="regular">
  	  <input type="radio" name="Tracking" id="Tracking" value="1" <cfif #Get.Tracking# eq "1">checked</cfif>>Yes
	  <input type="radio" name="Tracking" id="Tracking" value="0" <cfif #Get.Tracking# eq "0">checked</cfif>>No
    </TD>
	</TR>
	
	</cfoutput>



	
	
</TABLE>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Delete" id="Delete" value=" Delete " onClick="return ask()">
    <input class="button7" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>


</BODY></HTML>