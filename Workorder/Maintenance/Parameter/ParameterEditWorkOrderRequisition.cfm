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
<cfparam name="URL.ID1" default="">

<cfquery name="Get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE	Mission = <cfif url.id1 eq "">'#MissionList.Mission#'<cfelse>'#URL.ID1#'</cfif>
</cfquery>

<cfoutput query="get">

<table class="hide">
	<tr><td><iframe name="processParameterEditWorkOrderRequisitionSubmit" id="processParameterEditWorkOrderRequisitionSubmit" frameborder="0"></iframe></td></tr>
</table>

<cfform method="POST" name="formWorkOrderReq" action="ParameterEditWorkOrderRequisitionSubmit.cfm" target="processParameterEditWorkOrderRequisitionSubmit">

<table width="95%" class="formpadding" cellspacing="0" cellpadding="0" align="center">
	
	<input name="mission" id="mission" type="Hidden" value="#mission#">
	<tr><td height="5"></td></tr>			
	
	<tr><td class="labellarge" style="height:30" colspan="3">Requisition</b></td></tr>
	
	<TR>
	<td width="5%"></td>
    <td class="labelmedium" width="10%">Prefix:</b></td>
    <TD width="70%">		
		<cfinput type="Text" name="requisitionPrefix" value="#requisitionPrefix#" message="Please, enter a valid requisition prefix" required="Yes" maxlength="4" style="width:65px" class="regularxl">
	   </td>
    </tr>
	
	<TR>
	<td></td>
    <td class="labelmedium">Serial Number:</b></td>
    <TD>		
		<cfinput type="Text" name="requisitionSerialNo" value="#requisitionSerialNo#" message="Please, enter a valid requisition serial number" required="Yes" validate="integer" style="width:65px" class="regularxl">
	   </td>
    </tr>
	
	<tr><td height="10"></td></tr>
	<tr><td class="labellarge" style="height:30" colspan="8">WorkOrder</b></td></tr>
	
	<TR>
	<td></td>
    <td class="labelmedium">Prefix:</b></td>
    <TD>		
		<cfinput type="Text" name="workOrderPrefix" value="#workOrderPrefix#" message="Please, enter a valid workorder prefix" required="Yes" maxlength="4" style="width:65px" class="regularxl">
	   </td>
    </tr>
	
	<TR>
	<td></td>
    <td class="labelmedium">Serial Number:</b></td>
    <TD>		
		<cfinput type="Text" name="workOrderSerialNo" value="#workOrderSerialNo#" message="Please, enter a valid workorder serial number" required="Yes" validate="integer" style="width:65px" class="regularxl">
	   </td>
    </tr>		
		
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="3" class="line"></td></tr>
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="3" align="center">
	<cfinput type="Submit" 
	       class="button10s" 
		   style="width:100"
		   value="Save"
	       name="Update" 
		   onclick="if (confirm('Changing this parameters will affect the functioning of the system, do you want to continue ?')) { return true } return false">
	</td></tr>
	
	<tr><td height="5"></td></tr>
			
	</table>
	
	</CFFORM>	
	
</cfoutput>	