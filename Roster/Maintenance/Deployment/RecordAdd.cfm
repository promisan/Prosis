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

<cf_screentop height="100%" 
			  layout="webapp" 
			  label="Add Deployment Grade" 
			  menuAccess="Yes" 
			  user="no"
			  systemfunctionid="#url.idmenu#">

<cfquery name="Budget"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeBudget
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

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cfoutput>

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

   <tr><td></td></tr>

  <!--- Field: Id --->
    <TR>
    <TD class="labelmedium">Id:</TD>
    <TD><cfinput class="regularxl" type="Text" name="GradeDeployment" id="GradeDeployment" message="Please enter an Id" required="Yes" size="20" maxlength="20">
	</TD>
	</TR>
	
	
	<TR>
    <TD>Description:</TD>
    <TD><cfinput class="regularxl" type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	  <TR>
    <TD class="labelmedium">Order:</TD>
    <TD><cfinput type="Text"
       name="ListingOrder"      
	   id="ListingOrder"
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
	   <option value="#Budget.PostGradeBudget#">#Budget.PostGradeBudget#</option>
	    </cfloop>
	   </select>
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Parent:</TD>
    <TD>
	   <select name="PostGradeParent" id="PostGradeParent" class="regularxl">
	   <cfloop query="Parent">
	   <option value="#Parent.Code#">#Parent.Description#</option>
	    </cfloop>
	   </select>
    </TD>
	</TR>
	
	<tr><td colspan="2" height="6" valign="bottom" align="center"></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>

	<tr><td colspan="2" height="6" valign="bottom" align="center"></td></tr>	
		
	<tr><td colspan="2" valign="bottom" align="center">
	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
		
	</td></tr>
	
    	
</TABLE>

</cfoutput>

</CFFORM>

