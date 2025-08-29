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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray"
			  label="Edit Language" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Language 
WHERE LanguageId = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>


<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- edit form --->

<table width="94%" align="center" class="formpadding">
	 <cfoutput>
	 <tr>
		<td colspan="2" style="height:10px;"></td>
	</tr>
	
	 <TR>
	 <TD class="labelmedium2" width="30%">Code:</TD>  
	 <TD>
	 	<input type="Text" name="LanguageId" id="LanguageId" value="#get.LanguageId#" size="10" maxlength="10"class="regularxxl">
		<input type="hidden" name="LanguageIdOld" id="LanguageIdOld" value="#get.LanguageId#" size="10" maxlength="10"class="regular">
	 </TD>
	 </TR>
	 
	 <tr><td height="3"></td></tr>
	 
    <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	  	<input type="Text" name="LanguageName" id="LanguageName" value="#get.LanguageName#" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	  <input type="radio" name="LanguageClass" class="radiol" id="LanguageClass" value="Official" <cfif get.LanguageClass eq "Official">checked</cfif>>Official
	  <input type="radio" name="LanguageClass" class="radiol" id="LanguageClass" value="Standard" <cfif get.LanguageClass eq "Standard">checked</cfif>>Standard
	</TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>		
	
	<TR>
		<td colspan="2" align="Center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
		<input class="button10g" type="submit" name="Update" value=" Update ">
		</td>
	</TR>
	
</cfoutput>
    	
</TABLE>


</CFFORM>

