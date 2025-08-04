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

<cf_screentop title="Edit Allotment Action"               
			  label="Allotment Action" 
			  height="100%" 
			  banner="yellow" 
			  layout="webapp"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AllotmentAction
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfquery name="qClass"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT EntityCode,EntityClass,EntityClassName
	FROM   Ref_EntityClass
	WHERE  EntityCode = 'EntAllotment'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
<cfoutput>
<table width="95%" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>

	<TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
    	   #Get.Code#
		   <input type="hidden" name="code" id="code" value="#Get.Code#">
   </TD>
	</TR>
	
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#Get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Workflow class:</TD>
    <TD>
		<select name="EntityClass" class="regularxxl">
		  <option value="">n/a</option>
     	   <cfloop query="qClass">
        	<option value="#EntityClass#" <cfif get.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>	
	
	<tr><td colspan="2">
	<cf_dialogBottom option="edit" allowdelete="0">
	</td></tr>
		
</table>
</cfoutput>

</CFFORM>

