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
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Function Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
	FROM Ref_FunctionClass
WHERE FunctionClass = '#URL.ID1#'
</cfquery>


<cfquery name="Owner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
	FROM Ref_ParameterOwner
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this class?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td style="height:10px"></td></tr>

    <cfoutput>
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text"   name="FunctionClass"    value="#get.FunctionClass#" size="20" maxlength="20" class="regularxxl">
	   <input type="hidden" name="FunctionClassOld" value="#get.FunctionClass#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Owner">:</TD>
    <TD>
	   <select name="Owner" class="regularxxl">
	   <cfloop query="Owner">
	   <option value="#Owner#" <cfif get.Owner eq Owner>selected</cfif>>#Owner#</option>	   
	   </cfloop>
	   </select>
  	 </TD>
	</TR>
	
	</cfoutput>
		
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" height="3"></td></tr>
		
	<tr>
	<td align="center" colspan="2" valign="bottom">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

	