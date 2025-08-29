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

<cfquery name="Category"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #CLIENT.LanPrefix#Ref_Resource R
	ORDER BY R.ListingOrder
</cfquery>


<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM #CLIENT.LanPrefix#Ref_Object
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Code?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_divscroll>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="5"></td></tr>
	
    <cfoutput>
    <TR>
    <TD style="padding-left:6px" class="labelmedium">Code:</TD>
    <TD>	
		
		<cfquery name="Requirement"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 ObjectCode
		FROM      ProgramAllotmentRequest
		WHERE     ObjectCode = '#URL.ID1#'
		</cfquery>
			
		<cfquery name="Budget"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 ObjectCode
		FROM      ProgramAllotmentDetail
		WHERE     ObjectCode = '#URL.ID1#'
		</cfquery>		
		
		<cfquery name="Execution"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 ObjectCode
		FROM      RequisitionLineFunding
		WHERE     ObjectCode = '#URL.ID1#'
		</cfquery>
				
		<cfquery name="Invoice"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 ObjectCode
		FROM      Accounting.dbo.TransactionLine
		WHERE     ObjectCode = '#URL.ID1#'
		</cfquery>		

	   <cfif Requirement.recordcount eq "0" and Budget.recordcount eq "0" and Execution.recordcount eq "0" and Invoice.Recordcount eq "0">	
  	     <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10" class="regularxl">	   
	   <cfelse>	   
	     <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10" disabled class="regularxl">	  	   
	   </cfif>
	   <input type="hidden" name="Codeold" value="#get.Code#" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD width="30%" style="padding-left:6px" class="labelmedium">Display:</TD>
    <TD>
  	   <cfinput type="text" name="codedisplay" value="#get.CodeDisplay#" message="Please enter a display code" required="No" size="10" maxlength="20" class="regularxl">
    </TD>
	</TR>
		
	<cfquery name="FundTypeList"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_FundType
		ORDER BY ListingOrder
	</cfquery>
		
	<cfloop query="FundTypeList">
	<tr>
	<td align="right" style="padding-right:5px" class="labelit">#Code#:</td>
	<TD>
	
		<cfquery name="Check"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_ObjectFundType
			WHERE Code = '#URL.ID1#'
			AND   FundType = '#Code#'
		</cfquery>
		
  	   <cfinput type="text" name="codedisplay_#currentrow#" value="#Check.CodeDisplay#" message="Please enter a display code" required="No" size="10" maxlength="20" class="regularxl">
    </TD>	
	</tr>
	</cfloop>
	
	<TR>
    <TD style="padding-left:6px;padding-top:4px"" valign="top" class="labelmedium">Description:</TD>
    <TD>
	
	<cf_LanguageInput
			TableCode       = "Ref_Object" 
			Mode            = "Edit"
			Name            = "Description"
			Value           = "#get.Description#"
			Key1Value       = "#get.Code#"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "50"
			Class           = "regularxl">
	
    </TD>
	</TR>
	
	<TR>
    <TD style="padding-left:6px" class="labelmedium">Relative Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" style="text-align:center" message="Please enter a order" validate="integer" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD style="padding-left:6px" class="labelmedium">Usage Class:</TD>
    <TD>
		<cfquery name="Check"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT TOP 1 ObjectCode
			FROM  ProgramAllotmentDetail
			WHERE objectCode = '#url.id1#'
		</cfquery>
					
		<cfquery name="Usage"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM  Ref_ObjectUsage
			<cfif Check.recordcount eq "1">
			WHERE Code = '#get.ObjectUsage#'
			</cfif>
		</cfquery>
	
	    <select name="objectusage" class="regularxl">
     	   <cfloop query="Usage">
        	<option value="#Code#" <cfif #Code# eq "#get.ObjectUsage#">selected</cfif>>#Description#
			</option>
         	</cfloop>
	    </select>
	</TD>
	</TR>
	
	<TR>
    <TD style="padding-left:6px" class="labelmedium">Resource:</TD>
    <TD>
		<select name="resource" class="regularxl">
     	   <cfloop query="Category">
        	<option value="#Category.Code#" <cfif #Category.Code# eq "#get.Resource#">selected</cfif>>#Category.Description#
			</option>
         	</cfloop>
	    </select>
		
    </TD>
	</TR>
		
	<TR>
    <TD style="padding-left:6px" height="20" class="labelmedium">Parent:</TD>
    <TD class="labelmedium">
	
		<cfdiv bind="url:ObjectParent.cfm?objectusage={objectusage}&resource={resource}&code=#url.id1#&parent=#get.ParentCode#" id="parent">
				
	</TD>
	</TR>
			
	<TR>
    <TD style="padding-left:6px" class="labelmedium">Procurement:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="rediol" name="Procurement" value="1" <cfif get.Procurement eq "1">checked</cfif>> Enabled
		<INPUT type="radio" class="radiol" name="Procurement" value="0" <cfif get.Procurement eq "0">checked</cfif>> Disabled
	</TD>
	</TR>
	
	<tr><td height="8"></td></tr>
	<tr><td colspan="2" class="labellarge">
		Requirement Preparation settings <font size="2" color="808080"><i>(only for: Edition Entry Mode => Details)</td>
	</tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
    	<TD width="150" style="padding-left:16px" class="labelmedium">Data entry:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="RequirementEnable" value="0" <cfif get.RequirementEnable eq "0">checked</cfif>>Disabled			
			<INPUT type="radio" class="radiol" name="RequirementEnable" value="1" <cfif get.RequirementEnable eq "1">checked</cfif>>Enabled
			<INPUT type="radio" class="radiol" name="RequirementEnable" value="2" <cfif get.RequirementEnable eq "2">checked</cfif>>Enabled, for budget manager only
		</TD>
	</TR>	
	
	<tr>
    	<TD style="padding-left:16px" class="labelmedium">Enable Source Unit:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="RequirementUnit" value="0" <cfif get.RequirementUnit eq "0">checked</cfif>>No
			<INPUT type="radio" class="radiol" name="RequirementUnit" value="1" <cfif get.RequirementUnit eq "1">checked</cfif>>Yes
		</TD>
	</TR>
	
	<tr>
    	<TD style="padding-left:16px" class="labelmedium">Apply support:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="SupportEnable" value="0" <cfif get.SupportEnable eq "0">checked</cfif>>No
			<INPUT type="radio" class="radiol" name="SupportEnable" value="1" <cfif get.SupportEnable eq "1">checked</cfif>>Yes
		</TD>
	</TR>
				
	<TR>
    	<TD style="padding-left:16px" class="labelmedium">Define by Period:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" onclick="document.getElementById('modematrix').disabled=true;document.getElementById('modematrixitem').disabled=false" name="RequirementPeriod" value="0" <cfif get.RequirementPeriod eq "0">checked</cfif>>No
			<INPUT type="radio" class="radiol" onclick="document.getElementById('modematrix').disabled=false;document.getElementById('modematrixitem').disabled=true" name="RequirementPeriod" value="1" <cfif get.RequirementPeriod eq "1">checked</cfif>>Yes
		</TD>
	</TR>
						
	<TR id="mode">
		    <TD valign="top" style="padding-top:6px;padding-left:16px" class="labelmedium">Requirement Dialog:</TD>
	    	<TD lass="labelmedium">
			   <table cellspacing="0" cellpadding="0">
			   <tr>
			   <td class="labelmedium" style="padding-left:0px">
			   <INPUT type="radio" class="radiol" name="RequirementMode" value="0" <cfif get.RequirementMode eq "0">checked</cfif>> Item Qty 1
			   </td>
			   <td class="labelmedium" style="padding-left:4px">
			   <INPUT type="radio" class="radiol" name="RequirementMode" value="1" <cfif get.RequirementMode eq "1">checked</cfif>> Item Qty 2
			    </td>
				<td class="labelmedium" style="padding-left:4px">
			   <INPUT type="radio" class="radiol" name="RequirementMode"  <cfif get.RequirementPeriod eq "0">disabled</cfif> id="modematrix" value="2" <cfif get.RequirementMode eq "2">checked</cfif>> Sub-item/Period Grid
			   </td>
			   <td class="labelmedium" style="padding-left:4px">
			   <INPUT type="radio" class="radiol" name="RequirementMode"  value="3"  id="modematrixitem" <cfif get.RequirementPeriod eq "1">disabled</cfif> <cfif get.RequirementMode eq "3">checked</cfif>> Item Grid
			   </td>			   
			   </tr>
			   </table>
			</TD>
	</TR>
			
	</cfoutput>
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<cfquery name="Check"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT ObjectCode
		FROM   ProgramAllotmentDetail
		WHERE  ObjectCode = '#URL.ID1#'
		
		UNION
		
		SELECT ObjectCode
		FROM   ProgramAllotmentAllocation
		WHERE  ObjectCode = '#URL.ID1#'
		
		UNION
		
		SELECT ObjectCode
		FROM   ProgramAllotmentRequest
		WHERE  ObjectCode = '#URL.ID1#'
		
	</cfquery>
	
	<cfif Check.recordcount gt 0>
		<tr>
			<td colspan="2" align="right" class="labelmedium">
				<font color="gray">
					<cf_tl id="Object is in use">
				</font>
			</td>
		</tr>
	</cfif>
		
	<tr>
	
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">	
	<cfif Check.recordcount eq 0>
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" value="Update">
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

</cf_divscroll>
	

