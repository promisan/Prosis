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
	  layout="webapp" 
	  label="Edit Deployment Grade" 
	  menuAccess="Yes" 
	  user="no"
	  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_GradeDeployment
	WHERE  GradeDeployment = '#URL.ID1#'
</cfquery>

<cfquery name="Budget"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PostGradeBudget
	ORDER BY PostOrderBudget
</cfquery>

<cfquery name="Parent"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeParent
	ORDER BY Description
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

<table width="95%" align="center" class="formpadding">
<!--- Field: code --->
	 <cfoutput>

	 <tr><td style="height:10px"></td></tr>	
	 
	 <TR>
	 <TD class="labelmedium">Grade Deployment:</TD>  
	 <TD class="labelmedium">#get.GradeDeployment# <input type="hidden" value="#Get.GradeDeployment#" id="GradeDeployment" name="GradeDeployment"> </TD>
	 </TR>
	 
    <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="30" class="regularxl">				
    </TD>
	</TR>
	
	  <TR>
    <TD class="labelmedium">Order:</TD>
    <TD><cfinput type="Text"
	       name="ListingOrder"
		   id = "ListingOrder"
	       value="#get.ListingOrder#"
	       message="Please enter an Id"
	       validate="integer"
	       required="Yes"     
	       size="1"
	       maxlength="2"
	       class="regularxl">
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Budget:</TD>
    <TD>
	   <select name="PostGradeBudget" id="PostGradeBudget" class="regularxl">
	   <cfloop query="Budget">
	   <option value="#Budget.PostGradeBudget#" <cfif Get.PostGradeBudget eq Budget.PostGradeBudget>selected</cfif>>#Budget.PostGradeBudget#</option>
	    </cfloop>
	   </select>
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Parent:</TD>
    <TD>
	   <select name="PostGradeParent" id="PostGradeParent" class="regularxl">
	   <cfloop query="Parent">
	   <option value="#Parent.Code#" <cfif #Get.PostGradeParent# eq "#Parent.Code#">selected</cfif>>#Parent.Description#</option>
	    </cfloop>
	   </select>
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" height="6" valign="bottom" align="center"></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6" valign="bottom" align="center"></tr>
	<tr>	
		<td align="center" height="20" colspan="2">
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
			<input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
	</tr>

</table>

</CFFORM>

