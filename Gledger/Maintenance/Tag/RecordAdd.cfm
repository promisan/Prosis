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
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Financial Tag" 
			  label="Add Financial Tag" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Entity" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Entity
</cfquery>

<cfquery name="Class" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_CategoryClass
</cfquery>

<cfquery name="MissionSelect" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
</cfquery>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

     <tr><td></td></tr>
	
	 <TR>
	 <TD width="80" class="labelmedium2">Entity:&nbsp;</TD>  
	 <TD width="90%">
	 	<select name="EntityCode" class="regularxxl">
		<cfoutput query="entity">
		<option value="#EntityCode#">#EntityDescription#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>	 
	  
	 <TR>
	 <TD width="80"  class="labelmedium2">Mission:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="Mission" class="regularxxl">
		<option value="">any</option>
		<cfoutput query="missionSelect">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	 
	 <TR>
	 <TD width="80"  class="labelmedium2">Class:&nbsp;</TD>  
	 <TD width="80%">
	 	<select name="CategoryClass" class="regularxxl">
		<cfoutput query="Class">
		<option value="#Code#">#Description#</option>
		</cfoutput>
		</select>
	 </TD>
	</TR>
	 	
	<TR>
	 <TD class="labelmedium2">Code:&nbsp;</TD>  
	 <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	 </TD>
	</TR>
		
    <TR>
    <TD class="labelmedium2">Description:&nbsp;</TD>
    <TD>
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50"
		class="regularxxl">				
    </TD>
	</TR>
			
	<cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   ObjectUsage,Code, Code+' '+Description as Description
		FROM     Ref_Object
		ORDER BY ObjectUsage
	</cfquery>
	
    <TR>
    <TD class="labelmedium2">Show for Object:&nbsp;<cf_space spaces="40"></TD>
    <TD>
	
	<cfselect name="Object1" group="ObjectUsage" query="ObjectList" style="width:350px" value="Code" display="Description" visible="Yes" 
	  enabled="Yes" class="regularxxl"></cfselect>
						
    </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium2">additional:&nbsp;</TD>
    <TD>
	
	<cfselect name="Object2" group="ObjectUsage" query="ObjectList" style="width:350px" value="Code" display="Description" visible="Yes" enabled="Yes" class="regularxl"></cfselect>
					
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
		
	<tr><td colspan="2" class="line"></td></tr>
  
	<tr>
	
	<td colspan="2" height="40" align="center">
	<input class="button10g"  type="button" name="Cancel" value="Close" onClick="window.close()">
	<input class="button10g"  type="submit" name="Insert" value="Save">
	</td>
	</tr>
	
</table>

</CFFORM>
