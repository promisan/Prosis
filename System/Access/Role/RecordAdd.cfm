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
<cfquery name="Modules"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT SystemModule,Description
	FROM Ref_SystemModule
</cfquery>

<cfquery name="Owner"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Code,Description
	FROM Ref_AuthorizationRoleOwner
</cfquery>

<cf_screentop height="100%" jquery="Yes" label="Add Authorization Role" html="Yes" layout="webapp" banner="blue">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" target="process" name="dialog">

<table width="93%" class="formpadding formspacing" align="center">

	<tr><td height="8"></td></tr>
	
	<tr class="hide"><td><iframe name="process" id="process"></iframe></td></tr>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
  	   <input type="text" name="Role" id="Role" value="" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Area:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Area" value="" message="Please enter an area" required="Yes" size="20" maxlength="20"class="regularxl">
    </TD>
	</TR>
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a Description" required="Yes" size="50" maxlength="50"class="regularxl">
    </TD>
	</TR>	
	<TR>
    <TD class="labelmedium">Module:</TD>
    <TD class="labelmedium">
		<select name="SystemModule" id="SystemModule" size="1" style="background: ffffff;" class="regularxl">
		<cfoutput>
		<cfloop query="Modules">
		     <OPTION value="#Modules.SystemModule#" >#Modules.Description#
		</cfloop>
		</cfoutput>
		</SELECT> 		
    </TD>
	</TR>		
	
	<TR>
    <TD class="labelmedium">Owner:</TD>
    <TD class="labelmedium">
		<select name="RoleOwner" id="RoleOwner" size="1" style="background: ffffff;" class="regularxl">
		<OPTION value="" >All
		<cfoutput>
		<cfloop query="Owner">
		     <OPTION value="#Owner.Code#">#Owner.Description#
		</cfloop>
		</cfoutput>
		</SELECT> 
    </TD>
	</TR>		
	
	
	<TR>
    <TD class="labelmedium">Function:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="SystemFunction" value="" message="Please enter a Function" required="Yes" size="30" maxlength="30"class="regularxl">
    </TD>
	</TR>	

	<TR>
    <td class="labelmedium">Grant Level:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="OrgUnitLevel" id="OrgUnitLevel" value="Global" checked>Global
	  <input type="radio" name="OrgUnitLevel" id="OrgUnitLevel" value="Tree">Tree
	  <input type="radio" name="OrgUnitLevel" id="OrgUnitLevel" value="Parent">Parent
	  <input type="radio" name="OrgUnitLevel" id="OrgUnitLevel" value="All">All
    </td>
    </tr>
	
		
	<TR>
    <td class="labelmedium">Access Levels:</b></td>
    <TD class="labelmedium">  
	  <input type="radio" name="AccessLevels" id="AccessLevels" checked value="3">3
      <input type="radio" name="AccessLevels" id="AccessLevels" value="4">4
	  <input type="radio" name="AccessLevels" id="AccessLevels" value="5">5	 
    </td>
    </tr>
	
	<TR>
    <td class="labelmedium">Label List:</b></td>
    <TD class="labelmedium">  
	  <input type="text" class="regularxl" name="AccessLevelLabelList" id="AccessLevelLabelList" value="READ,EDIT (1),ALL (2)" size="50" maxlength="80">
    </td>
    </tr>

	<tr class="labelmedium"><td><cf_UIToolTip  tooltip="Additional parameter value to be defined when granting access to this user.">Parameter:</cf_UIToolTip></td>
	<td>
	<table cellspacing="0" cellpadding="0" class="formspacing">
	
		<script language="JavaScript">
		
		function other(val) {
		 se = document.getElementsByName("others")
		 count = 0
		 while (se[count]) {
		 
		 	if (val == "") {
		      se[count].className = "regular"
			 } else {
			  se[count].className = "hide"
			  document.getElementById("parametertable").value = ""
			 }
			 count++
		 }		  	   
		}
		</script>
	
			<TR>		   
		    <TD colspan="2" class="labelmedium">  
			  <input type="radio" name="Parameter" id="Parameter" onclick="other('x')" checked value="">N/A
			  <input type="radio" name="Parameter" id="Parameter" onclick="other('')"  value="">Custom
		      <input type="radio" name="Parameter" id="Parameter" onclick="other('x')" value="Owner">Owner
			  <input type="radio" name="Parameter" id="Parameter" onclick="other('x')" value="PostType">PostType
			  <input type="radio" name="Parameter" id="Parameter" onclick="other('x')" value="Journal">Journal
			  <input type="radio" name="Parameter" id="Parameter" onclick="other('x')" value="OrderClass">Order Class
		    </td>
		    </tr>
	
			<TR name="others" class="hide">
		    <td height="28">DSN:&nbsp;</td>
		    <TD> 
									
				<cfset ds = "AppsSystem">
				
				<!--- Get "factory" --->
				<CFOBJECT ACTION="CREATE"
				TYPE="JAVA"
				CLASS="coldfusion.server.ServiceFactory"
				NAME="factory">
				<!--- Get datasource service --->
				<CFSET dsService=factory.getDataSourceService()>
				<!--- Get datasources --->
				
				
				<!--- Extract names into an array 
				<CFSET dsNames=StructKeyArray(dsFull)>
				--->
				<cfset dsNames = dsService.getNames()>
				<cfset ArraySort(dsnames, "textnocase")> 
						
				<select name="parameterdatasource" id="parameterdatasource" class="regularxl">
					<option value="" selected >--- select ---</option>
					<CFLOOP INDEX="i"
					FROM="1"
					TO="#ArrayLen(dsNames)#">
					
					<CFOUTPUT>
					<option value="#dsNames[i]#" <cfif #ds# eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
					</cfloop>
				</select>
				
			
			</TD>
		    </TR>
					
			<TR name="others" class="hide">
			
				<td>Table:&nbsp;</td>		    	
				<td>
					    <cfinput type="Text"
					       name="parametertable"
					       value=""
					       autosuggest="cfc:service.reporting.presentation.gettable({parameterdatasource},{cfautosuggestvalue})"
					       maxresultsdisplayed="7"
						   showautosuggestloadingicon="No"
					       typeahead="Yes"
					       required="No"
					       visible="Yes"
					       enabled="Yes"      
					       size="40"
					       maxlength="50"
					       class="regularxl">
										   
				</TD>
				
			</TR>
		
			<TR name="others" class="hide">
	
				<td></td>
				<td>
				   <cfdiv id="lookup" 
				       bind="url:RecordField.cfm?id=&ID2={parametertable}&ds={parameterdatasource}">		
				</td>
		
			</TR>
	</table>
	</td>
	</tr>		
	
	<TR>
    <TD class="labelmedium">Memo:</TD>
    <TD class="labelmedium">
	   <cf_textarea name="RoleMemo" class="regular" style="width:95%;height:45;padding:3px"></cf_textarea>
    </TD>
	</TR>		
	
	<TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">Manual  <input type="hidden" name="RoleClass" id="RoleClass" value="Manual" >
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter an Order" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>	
		
	<tr><td colspan="2">
	<cf_dialogBottom option="add">	
	</td></tr>
		
</TABLE>

</CFFORM>

