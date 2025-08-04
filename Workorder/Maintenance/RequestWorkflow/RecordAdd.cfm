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
			  label="Add Request Workflow" 
			  option="Record a request action" 
			  layout="webapp" 			  
			  banner="gray" 			 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
<table width="95%" class="formpadding formspacing" align="center">
	
	<cfinput type="Hidden" name="serviceDomainOld" value="">
	<cfinput type="Hidden" name="requestTypeOld" value="">
	<cfinput type="Hidden" name="requestActionOld" value="">

	<tr><td height="10"></td></tr>	
	
	<TR class="labelmedium">
	    <TD width="27%">Request Type *:</TD>
	    <TD colspan="3">
	  	   
		   <cfquery name="get" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_Request
				WHERE 	Operational = 1
			</cfquery>
				
			<cfset selectedFirstRequestType = "#get.code#">
			<select name="requestType" id="requestType" class="regularxl" onchange="ColdFusion.navigate('getPointerReference.cfm?ID1='+this.value,'PointerReference_IsAmendment_EditDiv')">
				<cfoutput query="get">
				  <option value="#get.code#">#get.code# - #get.description#</option>
			  	</cfoutput>
			</select>
			
	    </TD>
	</TR>
	
    <TR class="labelmedium">
	    <TD>Service Domain *:</TD>
	    <TD>
	  	   <cfquery name="get" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ServiceItemDomain
				ORDER BY listingOrder
				</cfquery>
			<cfset selectedFirstServiceItemDomain = "#get.code#">
			<select name="serviceDomain" id="serviceDomain" class="regularxl" onchange="ColdFusion.navigate('getServiceDomainClass.cfm?ID1='+this.value+'&ID2=','serviceDomainClassDiv')">
				<cfoutput query="get">
				  <option value="#get.code#">#get.code# - #get.description#</option>
			  	</cfoutput>
			</select>
	    </TD>
	</tr>
	<tr class="labelmedium">	
		<TD>Domain Class:</TD>
		 <TD>
			 <cfdiv id="serviceDomainClassDiv" bind="url:getServiceDomainClass.cfm?ID1=#selectedFirstServiceItemDomain#&ID2=">
	 	</TD>
	</TR>
	
	<tr><td colspan="4"><cfdiv id="PointerReference_IsAmendment_EditDiv" bind="url:getPointerReference.cfm?ID1=#selectedFirstRequestType#"></td></tr>
		
	<TR class="labelmedium">
	    <TD>Action Code *:</TD>
	    <TD>
	  	   <cfinput type="Text" name="requestAction" value="" message="Please enter an action code" required="Yes" size="20" maxlength="10" class="regularxl">
	    </TD>
	</tr>
	<tr class="labelmedium">	
		<TD>Action Name:</TD>
	    <TD>
	  	   <cfinput type="Text" name="requestActionName" value="" message="Please enter an action name" required="No" size="40" maxlength="50" class="regularxl">
	    </TD>
	</TR>
	
	<TR class="labelmedium">
		<TD>Custom Form:</TD>
	    <TD>
	  	   <select name="customForm" id="customForm" class="regularxl">
				<option value="">N/A</option>
				<option value="RequestService.cfm">RequestService.cfm</option>
				<option value="RequestDevice.cfm">RequestDevice.cfm</option>
				<option value="RequestPorting.cfm">RequestPorting.cfm</option>
				<option value="RequestTransfer.cfm">RequestTransfer.cfm</option>
				<option value="Termination.cfm">Termination.cfm</option>
			</select>
	    </TD>
	</tr>
	<tr class="labelmedium">	
		<TD>Custom Form Condition:</TD>
	    <TD>
	  	   <cfinput type="Text" name="customFormCondition" value="" message="Please enter a custom form condition" required="No" size="40" maxlength="20" class="regularxl">
	    </TD>
	</TR>
	
	<TR class="labelmedium">
		<TD>Workflow:</TD>
	    <TD colspan="3">
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
				  <option value="#get.entityClass#">#get.entityClass# - #get.entityClassName#</option>
			  	</cfoutput>
			</select>
	    </TD>
	</TR>
	
	<TR class="labelmedium">
		<TD>Enforce Expiration Date *:</TD>
	    <TD colspan="3">
	  	   	<input type="radio" class="radiol" name="PointerExpiration" id="PointerExpiration" value="0" checked>No
			<input type="radio" class="radiol" name="PointerExpiration" id="PointerExpiration" value="1">Yes	
	    </TD>
	</TR>	
	
	<TR class="labelmedium">
		<TD>Operational *:</TD>
	    <TD colspan="3">
	  	   	<input type="radio" class="radiol" name="Operational" id="Operational" value="0">No
			<input type="radio" class="radiol" name="Operational" id="Operational" value="1" checked>Yes	
	    </TD>
	</TR>		
		
	
	<tr><td colspan="4" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="4" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
	</td>	
	
	</tr>
		
	</CFFORM>
	
</table>

<cf_screenbottom layout="innerbox">
