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
<script>
	_cf_loadingtexthtml='';	
</script>

<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ReviewCycle
		<cfif url.id1 eq "">
			WHERE 	1=0
		<cfelse>
			WHERE 	CycleId = '#URL.ID1#'
		</cfif>

</cfquery>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#" method="POST" name="frmReviewCycle">

<table width="95%" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>

    <cfoutput>
	
	<cfif url.id1 neq "">
		<TR>
	    <TD class="labelmedium" height="28"><cf_tl id="Review Cycle Id">:</TD>
	    <TD class="labelmedium">#get.CycleId# / #get.Mission#
		<input name="Mission" id="Mission" type="Hidden" value="#get.Mission#">
	    </TD>
		</TR>
	
	<cfelse>
	
		<TR>
	    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
	    <TD class="labelmedium">
			
				<cfquery name="Mis" 
				datasource="appsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_ParameterMission
					WHERE 	Mission IN (SELECT Mission 
		                  				FROM   Organization.dbo.Ref_MissionModule 
						  				WHERE  SystemModule = 'Program')
				</cfquery>
		  	   	<cf_tl id = "Please, select a valid entity" var = "1">
			    <cfselect name="Mission" query="Mis" value="Mission" display="Mission" selected="#get.Mission#" required="Yes" class="regularxl" message="#lt_text#">
				</cfselect>
			
	    </TD>
		</TR>
	
	</cfif>
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Period">:</TD>
	    <TD class="labelmedium">
	  	   <cf_securediv id="divPeriod" bind="url:getPeriod.cfm?id1=#url.id1#&period=#get.period#&mission={Mission}">
	    </TD>
	</TR>
	
	<tr>
	    <TD class="labelmedium"><cf_tl id="Label">:</TD>
	    <TD class="labelmedium">	  	   
		    <cfinput type="text" 
		       name="CycleName" 
			   value="#get.CycleName#" 
			   message="Please enter a description." 
			   required="yes" 
			   size="30" 
		       maxlength="30" 
			   class="regularxl">
	    </TD>
	</tr>	
	
	<tr>
	    <TD class="labelmedium"><cf_tl id="Description">:</TD>
	    <TD class="labelmedium">	  	   
		    <cfinput type="text" 
		       name="Description" 
			   value="#get.Description#" 
			   message="Please enter a description." 
			   required="yes" 
			   size="50" 
		       maxlength="50" 
			   class="regularxl">
	    </TD>
	</tr>	
	
	<tr>
		<td class="labelmedium"><cf_tl id="Cycle Effective Period">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
				<cf_securediv id="divEffectiveDate" bind="url:setDate.cfm?id1=#url.id1#&period=#get.period#&name=Effective&blank=0">
			</td>	
			<td style="padding-left:5;padding-right:5px">-</td>
			<td>
				<cf_securediv id="divExpirationDate" bind="url:setDate.cfm?id1=#url.id1#&period=#get.period#&name=Expiration&blank=0">
			</td>
			</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Cycle Budget coverage">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
				<cf_securediv id="divEffectiveDateBudget" bind="url:setDate.cfm?id1=#url.id1#&period=#get.period#&name=BudgetEffective&blank=0">
			</td>	
			<td style="padding-left:5;padding-right:5px">-</td>
			<td>
				<cf_securediv id="divExpirationDateBudget" bind="url:setDate.cfm?id1=#url.id1#&period=#get.period#&name=BudgetExpiration&blank=0">
			</td>
			</tr>
			</table>
		</td>
	</tr>
	
	
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Workflow Class">:</TD>
	    <TD class="labelmedium">
		
			<cfquery name="getClass" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT	*
					FROM	Ref_EntityClass 
					WHERE	EntityCode = 'EntProgramReview'
			</cfquery>
	  	   
		    <cf_tl id = "Please, select a valid class" var = "1">
		    <cfselect name="EntityClass" query="getClass" value="EntityClass" display="EntityClass" selected="#get.EntityClass#" required="Yes" class="regularxl" message="#lt_text#">
			</cfselect>
	    </TD>
	</TR>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Multiple Entries">:</td>
		<td class="labelmedium">
		    <table><tr class="labelmedium">
			<td><input name="EnableMultiple" id="EnableMultiple" class="radiol" type="Radio" value="1" <cfif get.EnableMultiple eq 1 >checked</cfif>></td>
			<td style="padding-left:4px">Yes</td>
			<td style="padding-left:9px"><input name="EnableMultiple" id="EnableMultiple" class="radiol" type="Radio" value="0" <cfif get.EnableMultiple eq 0 or url.id1 eq "">checked</cfif>></td>
			<td style="padding-left:4px">No</td>
			</tr></table>
		</td>
	</tr>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Operational">:</td>
		<td class="labelmedium">
		    <table><tr class="labelmedium">
			<td><input name="operational" id="operational" class="radiol" type="Radio" value="1" <cfif get.operational eq 1 or url.id1 eq "">checked</cfif>></td>
			<td style="padding-left:4px">Yes</td>
			<td style="padding-left:9px"><input name="operational" id="operational" class="radiol" type="Radio" value="0" <cfif get.operational eq 0>checked</cfif>></td>
			<td style="padding-left:4px">No</td>
			</tr></table>			
		</td>
	</tr>
			
	</cfoutput>
	
	<tr><td height="2"></td></tr>	
	
	<tr>
			<td colspan="2" class="labelmedium" style="height:30"><cf_tl id="Applies only to programs associated to group">:</td>
		</tr>
	
	<tr>
		<td colspan="2">
			<cf_securediv id="divDetailgroup" bind="url:Group.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission={Mission}">
		</td>
	</tr>	
	
	<tr><td height="10"></td></tr>	
	
	<tr>
		<td colspan="2">
			<cf_securediv id="divDetail" bind="url:Profile/Profile.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission={Mission}">
		</td>
	</tr>	
					
	<tr>
		
	<td align="center" colspan="2">
		<cf_tl id="Save" var="vSave">
		<cfoutput>
	    	<input class="button10g" style="height:30" type="submit" name="Save" id="Save" value="#vSave#" onclick="return validateFields();">
		</cfoutput>
	</td>	
	</tr>
	
</TABLE>

</cfform>

<cf_screenbottom layout="innerbox">
