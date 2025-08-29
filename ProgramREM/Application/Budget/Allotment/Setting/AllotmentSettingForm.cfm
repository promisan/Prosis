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
<cfoutput>

<table width="100%" height="100%" border="0" class="formspacing">

	
<tr>
	<td class="labelit" style="padding-left:4px"><cf_tl id="Disable entry">:</td>
	<td colspan="3" class="labelmedium">
	
	<cfif mode eq "view">
	
		<cfif get.LockEntry eq "1">Locked<cfelse>Open</cfif>
	
	<cfelse>

		<input type="checkbox" class="radiol" id="LockEntry" name="LockEntry" value="1" <cfif get.LockEntry eq "1">checked</cfif>>
	
	</cfif>
	
	</td>
		
</tr>

<tr>
	<td class="labelit" style="padding-left:4px"><cf_tl id="Calculate release for allotment">:</td>
	<td colspan="3">
	
	<table cellspacing="0" cellpadding="0">
	<tr><td>
	
	<cfif mode eq "view">
	
		<cfif get.DueCalculation eq "1">Auto<cfelse>Manual</cfif>
	
	<cfelse>

		<input type="checkbox" class="radiol" onclick="if (this.checked) {document.getElementById('preset').disabled=false} else {document.getElementById('preset').disabled=true} " id="DueCalculation" name="DueCalculation" value="1" <cfif get.DueCalculation eq "1">checked</cfif>>
	
	</cfif>
	
	</td>
	
	<td style="padding-left:2px">
	
	<cfif mode eq "view">
	
	<cfelse>
	
	<input type="button" <cfif DueCalculation eq "0">disabled</cfif> style="height:18;font-size:10px" class="button10g" id="preset" value="Set Allocation" onclick="maintainRelease('#url.EditionId#','#url.Period#','program','#url.programCode#')">
	
	</cfif>
	
	</td>
	
	</tr></table>
	
	</td>
		
</tr>


<TR>
   <td style="padding-left:4px" class="labelit"><cf_tl id="Default Funding">:</td>
   <TD class="labelmedium">
   
   <table><tr><td>
   
   <cfif mode eq "view">
   
   	#get.Fund#
   
   <cfelse>
   
   <select name="Fund" class="regularxl">
	   <cfloop query="FundList">
		   <option value="#Fund#" <cfif fund eq get.Fund>selected</cfif>>#Fund#</option>
	   </cfloop>   
   </select>
   
   </cfif>
   
   </td>
   <td class="labelit" style="padding-left:4px">
   
   <cfif mode eq "view">   
   	  <cfif get.FundEnforce eq "1">enforced</cfif>   
   <cfelse>         
   	  <input name="FundEnforce" class="radiol" type="checkbox" value="1" <cfif get.FundEnforce eq "1">checked</cfif>>&nbsp;Enforce</option>
   </cfif>	
   
   </td>
   </table>
   
	</td>
</tr>	

<cfif get.BudgetEntryMode eq "0" and getProgram.EnforceAllotmentRequest eq "0">

<input type="hidden" name="AmountRounding" value="100">

<cfelse>

<TR>
   <td style="padding-left:4px" class="labelit"><cf_tl id="Requirement rounding">:</td>
   <TD class="labelmedium">
    <cfif mode eq "view">
   
	   	#get.AmountRounding#
   
   <cfelse>
   
	<input type="radio" class="radiol" name="AmountRounding" <cfif get.AmountRounding eq "1">checked</cfif> value="1">1
	<input type="radio" class="radiol" name="AmountRounding" <cfif get.AmountRounding eq "10">checked</cfif> value="10">10
	<input type="radio" class="radiol" name="AmountRounding" <cfif get.AmountRounding eq "100">checked</cfif> value="100">100	
	
	</cfif>
	</td>
</tr>	

</cfif>

<cfif mode eq "view">

<cfelse>

<!---
<tr><td class="labelmedium" style="height:24;padding-left:4px"><cf_UIToolTip tooltip="Amount will be added to the allotment transaction upon submission of the clearance"> <cf_tl id="Support Charges"></cf_UIToolTip></td>
     

</tr>
--->

</cfif>

<tr><td style="padding-left:4px" class="labelit" style="padding-top:0px"> <cf_tl id="Program Support Percentage">:</td>

    <td colspan="3" class="labelit">	
	
		<table><tr><td>
			
		<cfif mode eq "view">
					
			#get.SupportPercentage# 
		
		<cfelse>
					
		<input type="Text" id="SupportPercentage"
		   name="SupportPercentage" message="Please record a valid number 0..50" value="#get.SupportPercentage#" range="0,50" validate="integer" visible="Yes" maxlength="2" class="regularxl" style="text-align:center;width:30">
		
		</cfif>
		
		</td>
		<td>
		
		%
		</td>
		
		  <cfif get.supportObjectCode neq "" and get.SupportPercentage neq "">	
	
			<td id="calculate" style="height:20;padding-left:3px" class="labelit">
				<a href="javascript:ColdFusion.navigate('setSupportCost.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&objectcode='+document.getElementById('SupportObjectCode').value+'&percentage='+document.getElementById('SupportPercentage').value,'calculate')" 
				title="Generates donor support financial ledger charges based on the current execution and doner associations.">
				<font color="gray"><u><cf_tl id="Revalidate Support Costs"></u></font>
				</a>
			</td>
			
		  </cfif>		
		  
		</tr>
		
		</table>  
		
	</td>
 </tr>
 
 <tr><td class="labelit" style="padding-top:0px;padding-left:44px">- <cf_tl id="Object Code">:</td>		
		
    <td colspan="3" class="labelmedium">
		
			<cfif mode eq "view">				
										
				<cfquery name="object" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_Object
					WHERE    Code = '#get.SupportObjectCode#'				
				</cfquery>	
				
				<cfif Object.recordcount eq "0">
				
				 	<cf_tl id="N/A">
				 
				<cfelse>
				
					#Object.Code# #Object.Description# 
				
				</cfif>					
			
			<cfelse>
														
				<cfquery name="object" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_Object
					WHERE    ObjectUsage IN
				                          (SELECT   ObjectUsage
				                            FROM    Ref_AllotmentVersion V, Ref_AllotmentEdition E
				                            WHERE   E.Version = V.Code 
											AND     E.EditionId = '#url.editionid#')
					AND      SupportEnable = 0						
					ORDER BY HierarchyCode
				</cfquery>	
				
				<cfif object.recordcount eq "0">
				
					<cfquery name="object" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_Object
						WHERE    ObjectUsage IN
					                          (SELECT   ObjectUsage
					                            FROM    Ref_AllotmentVersion V, Ref_AllotmentEdition E
					                            WHERE   E.Version = V.Code 
												AND     E.EditionId = '#url.editionid#')										
						ORDER BY HierarchyCode
					</cfquery>	
									
				</cfif>
				
				<cfif get.supportObjectCode eq "">
				
					<cfset curr = parameter.supportObjectCode> 
					
				<cfelse>
						
					<cfset curr = get.supportObjectCode>
				
				</cfif>
								
			
				<select name="SupportObjectCode" style="width:260" id="SupportObjectCode" class="regularxl">
				    <option value="">n/a</option>
					<cfloop query="object">
						<option value="#code#" <cfif code eq curr>selected</cfif>>#code# #Description#</option>
					</cfloop>			
				</select>
				
			</cfif>	
			
			</td>
			
		</tr>		
					
		<cfif Parameter.EnableDonor eq "1">	

		<tr>
			<td class="labelit" style="padding-left:4px"><cf_tl id="Donor Auto Mapping">:</td>
			<td class="labelmedium" colspan="3">
			
			<cfif mode eq "view">
			
				<cfif get.ModeMappingTransaction eq "0">Conservative<cfelse>Opportunistic</cfif>
			
			<cfelse>
			
				<table>
				<tr>
				<td><input type="radio" class="radiol" id="ModeMappingTransaction" name="ModeMappingTransaction" value="0" <cfif get.ModeMappingTransaction eq "0">checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px"><cf_tl id="Conservative"></td>			
				<td><input type="radio" class="radiol" id="ModeMappingTransaction" name="ModeMappingTransaction" value="1" <cfif get.ModeMappingTransaction eq "1">checked</cfif>></td>
				<td class="labelmedium" style="padding-left:4px"><cf_tl id="Opportunistic"></td>	
				
				</tr>
				</table>
			
			</cfif>
				
		</tr>
		
		</cfif>			

	</td>
	
	</tr>
	

	
</table>

</cfoutput>