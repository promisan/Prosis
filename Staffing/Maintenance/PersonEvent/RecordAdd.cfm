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

<cfquery name="Mission" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Mission M 
	WHERE  Operational = 1
	AND EXISTS (
		SELECT 'X'
		FROM   Employee.dbo.Ref_ParameterMission
		WHERE  Mission = M.Mission )	
	AND  EXISTS (
		SELECT 'X'
		FROM   Organization.dbo.Ref_MissionModule
		WHERE  Mission = M.Mission 
		AND    SystemModule = 'Staffing')
</cfquery>

<cf_screentop height="100%" 
			  label="Add Person Event" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog" >

<!--- Entry form --->

	<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	    <tr><td></td></tr>
	    <TR class="labelmedium">
	    <TD>Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"class="regularxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD>Name / Label:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50"class="regularxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD valign="top" style="padding-top:5px">Additional information:</TD>
    	<TD>
	  	   <textarea name="ActionInstruction" style="font-size:14px;padding:3px;width:100%;height:70px"></textarea>
    	</TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD>Order:</TD>
    	<TD>
	  	   <cfinput type="Text" name="ListingOrder" style="text-align:center" value="1" message="Please enter an order" required="Yes" size="2" maxlength="4" class="regularxl">
	    </TD>
		</TR>
				
		<TR class="labelmedium">
	    <TD>Record Position:</TD>
	    <TD>
	  		<input type="checkbox" class="radiol" name="ActionPosition" value="1">
	    </TD>
		</TR>
		
		<TR class="labelmedium">
	    <TD>Enable Portal:</TD>
	    <TD>
	  		<input type="checkbox" class="radiol" name="EnablePortal" value="0">
	    </TD>
		</TR>
		
	
		<TR class="labelmedium">
	    <TD>Record Period:</TD>
	    <TD>
		    <table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input type="radio" class="radiol" name="ActionPeriod" value="0" checked></td>
			<td style="padding-left:2px">No</td>
	  		<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="1"></td>
			<td style="padding-left:2px">Effective</td>
			<td style="padding-left:4px"><input type="radio" class="radiol" name="ActionPeriod" value="2"></td>
			<td style="padding-left:2px">Period (Effective and Expiration)</td>
			</tr>
			</table>
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Workflow:</TD>
	    <TD class="labelit">
		
		      <cfquery name="getWF" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_EntityClass
					WHERE 	EntityCode = 'PersonEvent'
					</cfquery>
					
				<select name="entityClass" id="entityClass" class="regularxl">
					<option value="">None</option>
					<cfoutput query="getWF">
					  <option value="#entityClass#">#entityClass# - #entityClassName#</option>
				  	</cfoutput>
				</select>
		
	  	   </TD>
		</TR>
		
	
		<TR class="labelmedium"><td colspan="2"><cf_tl id="Enabled for"></td></tr>
		<TR>
		<td width="100%" colspan="2" style="padding-left:50px">
			<table>
			
			<tr>
				<td>
				
				<table cellspacing="0" border="0" cellpadding="0">
									
				<cfset row = 0>
			  
				<cfoutput query="Mission">
				
				<cfset row = row+1>
				
				<cfif row eq "1">
				<tr class="labelmedium">
				</cfif>						
				
				<td width="100" style="height:20px">#Mission#:</td>					
				
				<td align="center" width="35"> 
				
				 <table width="100%" cellspacing="0" cellpadding="0">
				    <tr>
					<td align="center">			 
					 <input class="radiol" type="checkbox" name="Missions" value="#Mission#">
					  </td></tr></table>
				 
				 </TD>
							 
				 <cfif row eq "4">
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
			
		
	</table>

<cf_dialogBottom option="add">

</CFFORM>


