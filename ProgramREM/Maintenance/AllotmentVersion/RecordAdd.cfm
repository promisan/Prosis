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

<cf_screentop title="Register Allotment Version" 
			  height="100%" 
			  layout="webapp" 
			  label="Register Allotment Version" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Mission"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission
	                   FROM   Ref_MissionModule 
					   WHERE  SystemModule = 'Program')
</cfquery>

<cfquery name="Usage"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ObjectUsage	
</cfquery>

<cfquery name="Class"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ProgramClass	
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
    	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Entity:</TD>
    <TD class="labelit">
		<select name="mission" class="regularxl">
		  <option value=""></option>
     	   <cfoutput query="Mission">
        	<option value="#Mission#">#Mission#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit">Program class:</TD>
    <TD class="labelit">
		<select name="ProgramClass" class="regularxl">
		  <option value="">Any</option>
     	   <cfoutput query="Class">
        	<option value="#Code#">#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>			

	<TR>
    <TD class="labelit">Object Usage:</TD>
    <TD>
		<select name="ObjectUsage" class="regularxl">
     	   <cfoutput query="Usage">
        	<option value="#Code#">#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	   
			
	<TR>
    <TD class="labelit">Listing Order:</TD>
    <TD class="labelit">
  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="1"
	       message="Please enter a number 1..9"
	       validate="integer"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="1"
	       class="regularxl">
    </TD>
	</TR>
		    
	</TD>
	</TR>
	
	<tr><td colspan="2">
	<cf_dialogBottom option="add">
	</td></tr>
		
</table>

</CFFORM>

