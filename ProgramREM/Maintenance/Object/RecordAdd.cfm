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
			  label="Object of Expenditure"  
			  layout="webapp" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="no"
			  systemfunctionid="#url.idmenu#">

<cfquery name="Usage"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ObjectUsage R
</cfquery>

<cfquery name="FundType"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_FundType
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Category"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #CLIENT.LanPrefix#Ref_Resource R
	ORDER BY R.ListingOrder
</cfquery>

<cf_divscroll>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="5"></td></tr>

    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="5" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Display:</TD>
    <TD>
  	   <cfinput type="text" name="codedisplay" value="" message="Please enter a display code" required="No" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
		
	<cfoutput query="FundType">
	<tr>
	<td class="labelit" align="right" style="padding-right:5px">#Code#:</td>
	<TD>
  	   <cfinput type="text" name="codedisplay_#currentrow#" value="" message="Please enter a display code" required="No" size="10" maxlength="20" class="regularxl">
    </TD>	
	</tr>
	</cfoutput>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
		
	<cf_LanguageInput
			TableCode       = "Ref_Object" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "40"
			Class           = "regularxl">
				
		 </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" message="Please enter a order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
    </TD>
	</TR>
			
	<TR>
    <TD class="labelit">Usage Class:</TD>
    <TD>
	    <select name="objectusage" class="regularxl">
     	   <cfoutput query="Usage">
        	<option value="#Code#" <cfif client.objectusage eq code>selected</cfif>>#Description#</option>
         	</cfoutput>
	    </select>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelit">Resource:</TD>
    <TD>
		<select name="resource" class="regularxl">
     	   <cfoutput query="Category">
        	<option value="#Code#">#Description#
			</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Parent:</TD>
    <TD>	
		<cfdiv bind="url:ObjectParent.cfm?objectusage={objectusage}&resource={resource}" id="parent">		
	</TD>
	</TR>
		
	
	<TR>
    <TD class="labelit">Procurement:</TD>
    <TD class="labelit">
	    <INPUT type="radio" class="radiol" name="Procurement" value="1"> Enabled
		<INPUT type="radio" class="radiol" name="Procurement" value="0" checked> Disabled
	</TD>
	</TR>
	
	<tr><td height="8"></td></tr>
	<tr><td colspan="2" class="labellarge">
		Budget Preparation settings <font size="2" color="808080"><i>(only for: Edition Entry Mode => Details)</td>
	</tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr><td></td><td colspan="1">
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<TR>
    	<TD width="100" class="labelit">Source Unit:</TD>
	    <TD>
		    <INPUT type="radio" class="radiol" name="RequirementUnit" value="0" checked>No
			<INPUT type="radio" class="radiol" name="RequirementUnit" value="1">Yes
		</TD>
		</TR>
		
		<tr>
    	<TD class="labelit">Support Calculation:</TD>
	    <TD class="labelit">
		    <INPUT type="radio" class="radiol" name="SupportEnable" value="0" checked>No
			<INPUT type="radio" class="radiol" name="SupportEnable" value="1">Yes
		</TD>
	   </TR>
					
		<TR>
	    	<TD class="labelit" width="150">Define by Period:</TD>
		    <TD class="labelit">
			    <INPUT type="radio" class="radiol" onclick="document.getElementById('modematrix').disabled=true" name="RequirementPeriod" value="0" checked>No
				<INPUT type="radio" class="radiol" onclick="document.getElementById('modematrix').disabled=false" name="RequirementPeriod" value="1">Yes
			</TD>
		</TR>
			
		
		<TR id="mode">
		    <TD valign="top" style="padding-top:5px" class="labelit">Dialog:</TD>
	    	<TD class="labelit">
			   <table cellspacing="0" cellpadding="0">
			   <tr><td  class="labelit">
			   <INPUT type="radio" class="radiol" name="RequirementMode" value="0" checked> Quantity
			   </td></tr>
			   <tr><td class="labelit">
			   <INPUT type="radio" class="radiol" name="RequirementMode" value="1"> Quantity AND Days
			   </td></tr>
			   <tr><td class="labelit">
			   <INPUT type="radio" class="radiol" id="modematrix" disabled name="RequirementMode" value="2"> Sub Item Matrix
			   </td></tr>
			    <tr><td class="labelit">
			   <INPUT type="radio" class="radiol" name="RequirementMode" value="3"> Item Matrix
			   </td></tr>
			   </table>
			</TD>
		</TR>
			
		</table>
	</td>
	</tr>	
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	<tr>
				
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

</cf_divscroll>


