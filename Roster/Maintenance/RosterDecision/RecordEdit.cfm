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
<cf_screentop height="100%" 
		      scroll="Yes" 
			  layout="webapp" 
			  label="Edit decision code" >
			  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_RosterDecision
	WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this entry?")) {
	return true 
	}
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="96%" align="center" class="formpadding">

    <tr><td></tr>
    <cfoutput>
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="15" maxlength="15" class="regularxxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="15" maxlength="15" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	<TR valign="top">
    <TD class="labelmedium2">Memo:</TD>
    <TD>	
	   <textarea style="height:60px;width:90%;font-size:15px;padding:3px" name="DescriptionMemo" class="regular">#get.DescriptionMemo#</textarea>
  	  
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>
	</tr>
	
	
</TABLE>
		
</CFFORM>