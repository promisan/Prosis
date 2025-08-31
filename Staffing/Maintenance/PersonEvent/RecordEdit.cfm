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
	  label="Edit Person Event" 
	  scroll="Yes" 
	  layout="webapp" 
	  jquery="Yes"
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code = '#URL.ID1#'
</cfquery>

<cfoutput>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this event ?")) {	
	return true 	
	}	
	return false
	
}	

function instruction(cde,mis) {  	
	ProsisUI.createWindow('instruction', 'Instruction', '',{x:100,y:100,height:document.body.clientHeight-70,width:document.body.clientWidth-70,modal:true,center:true})    					
	ptoken.navigate('#SESSION.root#/Staffing/Maintenance/PersonEvent/InstructionDialog.cfm?code='+cde+'&Mission='+mis,'instruction') 			
}

</script>
</cfoutput>

<cfquery name="Mission" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Mission M
	WHERE  Operational = 1
	AND    EXISTS (
		SELECT 'X'
		FROM Employee.dbo.Ref_ParameterMission
		WHERE Mission = M.Mission )
	AND  EXISTS (
		SELECT 'X'
		FROM   Organization.dbo.Ref_MissionModule
		WHERE  Mission = M.Mission 
		AND    SystemModule = 'Staffing')
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

    <cfoutput>
	<tr><td></td></tr>
    <TR class="labelmedium22">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="20" maxlength="20" class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Name / Label:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50"class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD valign="top" style="padding-top:5px">Additional information:</TD>
    <TD>
  	   <textarea name="ActionInstruction" style="font-size:14px;padding:3px;width:100%;height:70px">#get.ActionInstruction#</textarea>
    </TD>
	</TR>
	
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter an order" style="text-align:center" required="Yes" size="2" maxlength="4" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Record Position:</TD>
    <TD>
  		<input type="checkbox" class="radiol" name="ActionPosition" value="1" <cfif get.ActionPosition eq 1>checked</cfif>>
    </TD>
	</TR>

	<TR class="labelmedium2">
    <TD>Enable Portal:</TD>
    <TD>
  		<input type="checkbox" class="radiol" name="EnablePortal" value="1" <cfif get.EnablePortal eq 1>checked</cfif>>
    </TD>
	</TR>


	<TR class="labelmedium2">
    <TD>Record Period:</TD>
    <TD>
	    <table>
		<tr class="labelmedium2">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="ActionPeriod" value="0" <cfif get.ActionPeriod eq 0>checked</cfif>></td>
		<td style="padding-left:2px">No</td>
  		<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="1" <cfif get.ActionPeriod eq 1>checked</cfif>></td>
		<td style="padding-left:2px">Effective</td>
		<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="2" <cfif get.ActionPeriod eq 2>checked</cfif>></td>
		<td style="padding-left:2px">Period (Effective and Expiration)</td>
		</tr>
		</table>
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Workflow:</TD>
    <TD>
	
	      <cfquery name="getWF" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_EntityClass
				WHERE 	EntityCode = 'PersonEvent'
				</cfquery>
				
			<select name="entityClass" id="entityClass" class="regularxxl">
				<option value="">None</option>
				<cfloop query="getWF">
				  <option value="#entityClass#" <cfif get.entityClass eq entityClass>selected</cfif>>#entityClass# - #entityClassName#</option>
			  	</cfloop>
			</select>
	
  	   </TD>
	</TR>
	
	</cfoutput>

	<TR class="labelmedium2"><td colspan="2"><cf_tl id="Entity">:</td></tr>
	<TR>
	<td width="100%" colspan="2">
		<table>
		
		<tr>
			<td style="padding-left:30px">
			
			<table>						
			<cfset row = 0>
		  
			<cfoutput query="Mission">
			
			<cfset row = row+1>
			
			<cfif row eq "1">
			<tr class="labelmedium2">
			</cfif>		
			
			<cfquery name="MissionCheck" 
				datasource="appsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT * 
				    FROM   Ref_PersonEventMission
					WHERE  PersonEvent = '#get.Code#'
					AND    Mission     = '#Mission#'
				</cfquery>				
			
			<td width="100" style="height:20px;padding-left:5px">
			<cfif MissionCheck.Recordcount eq "1">
				<a href="javascript:instruction('#get.code#','#mission#')">#Mission#</a>
			<cfelse>#Mission#</cfif>:				
					
			</td>					
			
			<td align="center" width="35"> 
			
			 <table width="100%">
			    <tr>				
				<td align="center">			 								 	
				<cfif MissionCheck.Recordcount eq "1">
					 <input type="checkbox" class="radiol" name="Missions" value="#Mission#" checked>
				<cfelse>
					 <input type="checkbox" class="radiol" name="Missions" value="#Mission#">
				</cfif>				  
				</td>												
				</tr>
				</table>
			 
			 </TD>
						 
			 <cfif row eq "6">
			 	</tr>
				<cfset row = 0>
			 </cfif>
			
			</cfoutput>
			
			</table>
		
			</td>	
			
		</tr>
		</table>
		
	</td>	
	</TR>	
	
	<tr><td colspan="2" class="line"></td></tr>
		
</TABLE>

<cf_dialogBottom option="edit">
	
</CFFORM>

