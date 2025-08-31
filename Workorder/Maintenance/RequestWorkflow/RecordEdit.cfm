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

<cfquery name="getWF"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	R.*, 
			T.Description as requestTypeDescription, 
			S.Description as serviceDomainDescription,
			(select C.EntityClassName from Organization.dbo.Ref_EntityClass C where R.entityClass = C.entityClass AND C.EntityCode = 'WrkRequest') as EntityClassName,
			T.TemplateApply
	FROM 	Ref_RequestWorkflow R,
			Ref_Request T,
			Ref_ServiceItemDomain S
	WHERE 	R.requestType = T.Code	
	AND		R.serviceDomain  = S.Code
	AND		R.ServiceDomain  = '#URL.ID1#'
	AND		R.RequestType    = '#URL.ID2#'
	AND		R.RequestAction  = '#URL.ID3#'
</cfquery>

<cfquery name="validateDeleteUpdate" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT TOP 1 RequestId
	FROM	Request
	WHERE	ServiceDomain = '#URL.ID1#'
	AND		RequestType = '#URL.ID2#'
	AND		RequestAction = '#URL.ID3#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Edit Service Request Action" 
			  layout="webapp" 			  
			  enforcebanner="yellow" 
			  option="Maintain service request action settings"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	
<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
		
	<cfinput type="hidden" name="serviceDomainOld" value="#URL.ID1#">
	<cfinput type="hidden" name="requestTypeOld" value="#URL.ID2#">
	<cfinput type="hidden" name="requestActionOld" value="#URL.ID3#">

	<tr><td height="10"></td></tr>
	
	<TR>
	    <TD class="labelmedium" width="25%">Request Type *:</TD>
	    <TD colspan="3" class="labelmedium">
		   <cfif validateDeleteUpdate.recordCount gt 0>
		   		<cfinput type="Hidden" name="requestType" value="#URL.ID2#">
				
				<cfquery name="get" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_Request
					WHERE 	Code = '#url.id2#'
					</cfquery>
				
		   		<cfoutput>#getWF.requestType# #get.Description#</cfoutput>
				
		   <cfelse>
		  	   <cfquery name="get" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_Request
					WHERE 	Operational = 1
					</cfquery>
				<select name="requestType" id="requestType" class="regularxl">
					<cfoutput query="get">
					  <option value="#get.code#" <cfif get.code eq getWF.requestType>selected</cfif>>#get.code# - #get.description#</option>
				  	</cfoutput>
				</select>
			</cfif>
	    </TD>
	</TR>
	
	<cfif trim(getWF.templateApply) eq "RequestApplyService.cfm">
	
	<TR>
		<TD class="labelmedium">Action Mode *:</TD>
	    <TD colspan="3" class="labelmedium" style="height:22px">
		    <table>
			<tr>
			<td>
	  	   	<input type="radio" class="radiol" name="IsAmendment" id="IsAmendment" value="0" <cfif getWF.IsAmendment eq 0>checked</cfif>>
			</td><td style="padding-left:4px" class="labelmedium">Generates a NEW Service</td>
			<td style="padding-left:7px">
			<input type="radio" class="radiol" name="IsAmendment" id="IsAmendment" value="1" <cfif getWF.IsAmendment eq 1>checked</cfif>>
			</td><td style="padding-left:4px" class="labelmedium">Amends an existing Service line</td>	
			</tr>
			</table>
	    </TD>
	</TR>
	
	<cfelse>
	
		<input type="Hidden" name="IsAmendment" id="IsAmendment" value="1">
		
	</cfif>
	
    <TR>
	    <TD class="labelmedium">Service Domain *:</TD>
	    <TD class="labelmedium">
		   <cfif validateDeleteUpdate.recordCount gt 0>
		   		<cfinput type="Hidden" name="serviceDomain" value="#URL.ID1#">
		   		<cfoutput>#getWF.serviceDomain#</cfoutput>
		   <cfelse>
		  	   <cfquery name="get" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_ServiceItemDomain
					ORDER BY listingOrder
					</cfquery>
				<select name="serviceDomain" id="serviceDomain" class="regularxl" onchange="ColdFusion.navigate('getServiceDomainClass.cfm?ID1='+this.value+'&ID2=','serviceDomainClassDiv')">
					<cfoutput query="get">
					  <option value="#get.code#" <cfif get.code eq getWF.serviceDomain>selected</cfif>>#get.code# - #get.description#</option>
				  	</cfoutput>
				</select>
			</cfif>
	    </TD>
	</tr>
	<tr>	
		<TD class="labelmedium">Associated Domain Class:</TD>
		<TD>
		  <cfdiv id="serviceDomainClassDiv" bind="url:getServiceDomainClass.cfm?ID1=#getWF.serviceDomain#&ID2=#getWF.serviceDomainClass#">
	 	</TD>
	</TR>		
	
	<TR>
	    <TD class="labelmedium">Action Code *:</TD>
	    <TD class="labelmedium">
		   <cfif validateDeleteUpdate.recordCount gt 0>
		   		<cfinput type="Hidden" name="requestAction" value="#URL.ID3#">
		   		<cfoutput>#getWF.requestAction#</cfoutput>
		   <cfelse>
		  	   <cfinput type="Text" name="requestAction" value="#getWF.requestAction#" message="Please enter an action code" required="Yes" size="10" maxlength="10" class="regularxl">
		   </cfif>
	    </TD>
	</tr>	
	<tr>
		<TD class="labelmedium">Action Name:</TD>
	    <TD>
	  	   <cfinput type="Text" name="requestActionName" value="#getWF.requestActionName#" message="Please enter an action name" required="No" size="40" maxlength="50" class="regularxl">
	    </TD>
	</TR>	
	
	<cfif trim(getWF.templateApply) eq "RequestApplyService.cfm">
	<TR>
		<TD class="labelmedium">Domain Reference No *:</TD>
	    <TD colspan="3" class="labelmedium">
	  	   	<input type="radio" class="radiol" name="PointerReference" id="PointerReference" value="0" <cfif getWF.PointerReference eq 0>checked</cfif>>No
			<input type="radio" class="radiol" name="PointerReference" id="PointerReference" value="1" <cfif getWF.PointerReference eq 1>checked</cfif>>Manual Entry	
			<input type="radio" class="radiol" name="PointerReference" id="PointerReference" value="2" <cfif getWF.PointerReference eq 2>checked</cfif>>Dropdown on associated domain class		
	    </TD>
	</TR>
	<cfelse>
		<input type="Hidden" name="PointerReference" id="PointerReference" value="0">
	</cfif>
	
	<TR>
		<TD class="labelmedium">Input Form Custom:</TD>
	    <TD class="labelmedium">
		   <select name="customForm" id="customForm" class="regularxl">
				<option value=""></option>
				<option value="RequestService.cfm" <cfif trim(getWF.customForm) eq "RequestService.cfm">selected</cfif>>RequestService.cfm</option>
				<option value="RequestDevice.cfm" <cfif trim(getWF.customForm) eq "RequestDevice.cfm">selected</cfif>>RequestDevice.cfm</option>
				<option value="RequestPorting.cfm" <cfif trim(getWF.customForm) eq "RequestPorting.cfm">selected</cfif>>RequestPorting.cfm</option>
				<option value="RequestTransfer.cfm" <cfif trim(getWF.customForm) eq "RequestTransfer.cfm">selected</cfif>>RequestTransfer.cfm</option>
				<option value="Termination.cfm" <cfif trim(getWF.customForm) eq "Termination.cfm">selected</cfif>>Termination.cfm</option>
			</select>
	    </TD>
	</tr>
	<tr>	
		<TD class="labelmedium">Form condition:</TD>
	    <TD class="labelmedium">
	  	   <cfinput type="Text" name="customFormCondition" value="#getWF.customFormCondition#" message="Please enter a custom form condition" required="No" size="10" maxlength="20" class="regularxl">	   	
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium">Trigger Clearance Workflow:</TD>
	    <TD colspan="3" class="labelmedium">
	  	   <cfquery name="get" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_EntityClass
				WHERE 	EntityCode = 'WrkRequest'
				</cfquery>
			<select name="entityClass" id="entityClass" class="regularxl">
				<option value=""></option>
				<cfoutput query="get">
				  <option value="#get.entityClass#" <cfif get.entityClass eq getWF.entityClass>selected</cfif>>#get.entityClass# - #get.entityClassName#</option>
			  	</cfoutput>
			</select>
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium">Enforce Expiration Date *:</TD>
	    <TD colspan="3" class="labelmedium">
	  	   	<input type="radio" class="radiol" name="PointerExpiration" id="PointerExpiration" value="0" <cfif getWF.PointerExpiration eq 0>checked</cfif>>No
			<input type="radio" class="radiol" name="PointerExpiration" id="PointerExpiration" value="1" <cfif getWF.PointerExpiration eq 1>checked</cfif>>Yes	
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium">Operational *:</TD>
	    <TD colspan="3" class="labelmedium">
	  	   	<input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif getWF.operational eq 0>checked</cfif>>No
			<input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif getWF.operational eq 1>checked</cfif>>Yes	
	    </TD>
	</TR>
	
	<tr><td colspan="4" class="line"></td></tr>
	
	<tr>		
		<td align="center" colspan="4" height="30">
			<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">				
			<cfif validateDeleteUpdate.recordCount eq 0><input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()"></cfif>
		    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</td>		
	</tr>
	
</table>
	
</CFFORM>

<cf_screenbottom layout="innerbox">