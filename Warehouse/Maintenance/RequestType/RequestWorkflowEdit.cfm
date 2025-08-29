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
<cfdiv id="editSection">

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	Ref_RequestWorkflow
	WHERE  	RequestType = '#URL.ID1#'
	AND		RequestAction = '#URL.ID2#'
	<cfif url.id2 eq ''>AND 1=0</cfif>
</cfquery>

<cfif URL.ID2 eq ''>
	<cf_screentop height="100%" label="Request Workflow" layout="webapp" option="Add new request workflow [#url.id1#]" user="no">
<cfelse>
	<cf_screentop height="100%" label="Request Workflow" layout="webapp" option="Maintain request workflow [#url.id1# - #url.id2#]" banner="yellow" scroll="yes" user="no">
</cfif>


<!--- edit form --->

<cfform action="RequestWorkflowSubmit.cfm?id1=#url.id1#&id2=#url.id2#" method="POST" name="frmRequestWorkflow" target="processRequestWorkflow">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

<tr class="hide"><td><iframe name="processRequestWorkflow" id="processRequestWorkflow" frameborder="0"></iframe></td></tr>

	<cfinput type="Hidden" name="requestType" value="#URL.ID1#">
	
	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD>Action:</TD>
    <TD colspan="2">
	   <table width="100%" cellspacing="0" cellpadding="0">
	    <tr><td>
		<cfinput type="text" name="requestAction" value="#get.requestAction#" message="Please enter a request action" required="Yes" size="10" maxlength="10" class="regularxl">
	   	<input type="hidden" name="requestActionOld" id="requestActionOld" value="#get.requestAction#" size="20" maxlength="20" readonly>
		</td>
		
	    <TD align="right">		
	  	   	<input type="radio" name="Operational" id="Operational" value="0" <cfif get.operational eq 0>checked</cfif>>Disabled
			<input type="radio" name="Operational" id="Operational" value="1" <cfif get.operational eq 1 or url.id2 eq ''>checked</cfif>>Enabled	
	    </TD>
		</table>
		
	</TR>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Name:</TD>
    <TD colspan="2">
  	   <cfinput type="text" name="requestActionName" value="#get.requestActionName#" message="Please enter a request action name" required="Yes" size="40" maxlength="50" class="regularxl">	   
    </TD>
	</TR>	
	
	<TR class="labelmedium">
		<TD>Workflow:</TD>
	    <TD colspan="2">
	  	   <cfquery name="getWF" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_EntityClass
				WHERE 	EntityCode = 'WhsRequest'
				</cfquery>
			<select name="entityClass" id="entityClass" class="regularxl">				
				<cfloop query="getWF">
				  <option value="#getWF.entityClass#" <cfif getWF.entityClass eq get.entityClass>selected</cfif>>#getWF.entityClass# - #getWF.entityClassName#</option>
			  	</cfloop>
			</select>
	    </TD>
	</TR>
	
	<tr class="labelmedium"><td valign="top" style="padding-top:5px">Custom Form: </td>
	    <td>
		<table cellspacing="0" cellpadding="0" class="formpadding">
		
		<TR class="labelit">
	    <TD valign="top" style="padding-top:3px;padding-left:1px;padding-right:5px">Path: /Warehouse/Application/</TD>
	    <TD>
									
		 	<cfset templateDirectory = "Warehouse/Application/">
			
		 	<cfinput type="Text" 
				name="customForm" 
				value="#get.customForm#" 
				message="Please enter a custom form" 
				onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#templateDirectory#'+this.value+'&container=templateValidationDiv&resultField=validateTemplate','templateValidationDiv')"
				required="No" 
				size="30" 
				maxlength="80" 
				class="regularxl">										
				
		 </TD>
		 <td valign="left" style="padding-left:4px">
		 	<cfdiv id="templateValidationDiv" bind="url:CollectionTemplate.cfm?template=#templateDirectory#&container=templateValidationDiv&resultField=validateTemplate">				
		 </td>
		</TR>
		
		<TR class="labelmedium">
	    <TD style="padding-left:1px;padding-right:10px">Condition:</TD>
	    <TD colspan="2">
			<cfinput type="Text" name="customFormCondition" value="#get.customFormCondition#" message="Please enter a custom form condition" required="No" size="20" maxlength="20" class="regularxl">
		  </TD>
		</TR>
				
		</table>
		</td>
	</tr>
			
	<cfif url.id2 neq "">
	<tr class="labelmedium">
		<td valign="top" style="padding-top:4px">Activated for:</td>
	</tr>
	<tr>	
		<td colspan="3">
			<cfdiv id="divWarehouses" bind="url:RequestWorkflowWarehouseAddMultiple.cfm?type=#url.id1#&action=#url.id2#">
		</td>
	</tr>
	</cfif>
				
	</cfoutput>
		
	<tr><td height="2"></td></tr>
	<tr>
		
	<td align="center" colspan="3" height="30">
	
	<cfif url.id2 eq ''>
		<cf_button type="submit" name="Save" id="Save" value="Save" onclick="return validateFileFields2(this)">
	<cfelse>
    	<cf_button type="submit" name="Update" id="Update" value="Update" onclick="return validateFileFields2(this)">
	</cfif>		
	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">

</cfdiv>