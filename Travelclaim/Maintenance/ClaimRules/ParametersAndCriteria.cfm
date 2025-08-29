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
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<cfoutput>

<table width="97%" cellspacing="2" cellpadding="2" align="center">

    <TR>
    <TD width="120">Code:</TD>
    <TD height="20">
	   <cfif #Get.Recordcount# eq "0">
  	   <input class="regular" type="text" name="Code" value="#Get.Code#" size="4" maxlength="4" class="regular">
	   <cfelse>
	   #Get.Code#
	   <input type="hidden" name="Code" value="#Get.Code#" size="4" maxlength="4" class="regular">
	   </cfif>
	   
	    <cfif #Get.Recordcount# eq "0">
		   <select name="ValidationClass">
		   <cfloop query="class">
		   <option value="#Code#" <cfif #Code# eq "#get.ValidationClass#">selected</cfif>>(#Description#)</option>
		   </cfloop>
		   </select>
	   <cfelse>
	  	   (#get.ValidationClass#)
		   <input type="hidden" name="ValidationClass" value="#Get.ValidationClass#" size="4" maxlength="4">
	   </cfif>
	   
    </TD>
	</TR>
	
			
	<TR>
    <TD>Description:</TD>
    <TD>
	
	<input class="regular" type="text" name="Description" value="#Get.Description#" size="80" maxlength="80">
	
	</TD>
	</TR>
	
	<TR>
    <TD width="120">Message to Claimant:</TD>
    <TD>
	
	<textarea style="width:98%" class="regular" rows="4" name="MessagePerson">#Get.MessagePerson#</textarea>
	
	</TD>
	</TR>
	
	<TR>
    <TD>Message for Reviewers:</TD>
    <TD>	
	<textarea style="width:98%" class="regular" rows="4" name="MessageAuditor">#Get.MessageAuditor#</textarea>	
	</TD>
	</TR>
		
	<TR>
    <TD>Color:</TD>
    <TD>	
	<input type="text" class="regular" name="Color" value="#Get.Color#" size="10" maxlength="10">	
	</TD>
	</TR>
	
	<TR>
    <TD>Script path:</TD>
    <TD>	
	<input type="text" class="regular" name="ValidationPath" value="#Get.ValidationPath#" size="60" maxlength="60">	
	</TD>
	</TR>
	
	<TR>
    <TD>Template:</TD>
    <TD>	
	<input type="text" class="regular" name="ValidationTemplate" value="#Get.ValidationTemplate#" size="40" maxlength="40">	
	</TD>
	</TR>
			
	<TR>
    <TD class="regular">Status</TD>
    <TD class="regular">
	   <input type="radio" name="operational" value="1" <cfif #get.Operational# neq "0">checked</cfif>>Activated
	   <input type="radio" name="operational" value="0" <cfif #get.Operational# eq "0">checked</cfif>>Deactivated    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Remarks</TD>
    <TD class="regular">
	   <input type="text" value="#get.Remarks#" name="remarks" style="width:98%" maxlength="100" class="regular">
	</TD>
	</TR>
		
	<cfquery name="Actor" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_DutyStationActor
		ORDER BY ListingOrder
	</cfquery>
		
	<cfquery name="Event" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ClaimEvent
	</cfquery>
	
	
	<cfset cnt = 0>
	
	<cfif get.WorkFlowEnabled eq "0">
	
	<!--- no actors involved --->
	
	<cfelse>
		
		<cfif #get.ValidationClass# neq "Threshold1" and
		     #get.ValidationClass# neq "Threshold2" and
			 #get.ValidationClass# neq "Rule2">
		
		<TR>
	    <TD>Actors</TD>
	    <TD>
			<table width="98%" align="center">
			
			<cfloop query="Actor">
			<cfset cnt = cnt+1>
			
			<cfquery name="Check" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  Ref_DutyStationValidation
				WHERE Mission = '#Mission#'
				AND   ValidationCode = '#Get.Code#'
				AND   ClearanceActor = '#ClearanceActor#'
			</cfquery>
			
			<tr>
			<td>#Mission#</td>
			<td>#ClearanceDescription#</td>
			<input type="hidden" name="Actor_#cnt#" value="#ClearanceActor#">
			<td align="center"><input type="checkbox" name="Selected_#cnt#" value="1" <cfif #Check.recordcount# eq "1">checked</cfif>></td>
			
			</tr>
			<tr><td colspan="3" class="linedotted"></td></tr>
			</cfloop>
			</table>
		</TD>
		</TR>
		
		<TR>
	    <TD>Enforce resolve:</TD>
    	<TD>
		   <input type="radio" name="enforce" value="1" <cfif get.Enforce neq "0">checked</cfif>>Yes
		   <input type="radio" name="enforce" value="0" <cfif get.Enforce eq "0">checked</cfif>>No
		</TD>
		</TR>
		
		<cfelseif get.ValidationClass eq "Threshold1">
		
			<cfquery name="Category" 
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ClaimCategory
			WHERE ListingOrder < '99' and ClaimAmount = 1
			</cfquery>
			
			<tr><td colspan="2" align="center"><b>Threshold</td></tr>		  
			<TR>
		    		
		    <TD colspan="2">
			
			<table width="100%" cellspacing="0" cellpadding="0">
					    
				<tr bgcolor="f4f4f4">
					   
						<td></td>
						<td></td>
						<td>Type</td>
						<td></td>
						<cfloop query="Actor">
						<td colspan="2">#ClearanceDescription#</td>
						</cfloop>
				</tr>		
										
				<cfloop query="Category">
					<tr><td colspan="10" bgcolor="D1D7D0"></td></tr>			
					<tr>
					   
						<td></td>
						<td></td>
						<td>#code#</td>
						<td>#description#</td>
						
						<cfset cde = "#Code#">
						
						<cfloop query="Actor">
						
							<cfset mis = "#Mission#">
							<cfset act = "#ClearanceActor#">
							<cfset des = "#ClearanceDescription#">
						
							<cfquery name="Check" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM  Ref_DutyStationValidation
							WHERE Mission = '#mis#'
							AND   ValidationCode = '#Get.Code#'
							AND   ClearanceActor = '#act#'
							AND   ClaimCategory  = '#cde#'
						   </cfquery>
						 		 
						
						    <cfset cnt = cnt+1>
										
							<input type="hidden" name="Actor_#cnt#" value="#act#">
							<input type="hidden" name="Category_#cnt#" value="#cde#">
							<td>
							<input type="checkbox" name="selected_#cnt#" onclick="toggle(#cnt#)" value="1" 
							<cfif #Check.recordcount# eq "1">checked</cfif>>
							</td>
							
							<td>
								<cfif #Check.recordcount# eq "1">
									<cfset cl = "amount">
								<cfelse>
									<cfset cl = "hide">
								</cfif>
												
								<cfinput type="Text"
							       name="amount_#cnt#"
							       value="#Check.ThresholdAmount#"
							       message="Please enter a valid amount"
							       validate="float"
							       required="No"
							       visible="Yes"
							       enabled="Yes"
							       size="6"
							       maxlength="8"
							       class="#cl#">
							</td>
						
						</cfloop>
						
					</tr>
										
				</cfloop>
					
			</table>
			</TD>
			</TR>		
			
			<TR>
		    <TD>Enforce resolve:</TD>
    		<TD>
			   <input type="radio" name="enforce" value="1" <cfif get.Enforce neq "0">checked</cfif>>Yes
			   <input type="radio" name="enforce" value="0" <cfif get.Enforce eq "0">checked</cfif>>No
			</TD>
			</TR>
		
		<cfelseif get.ValidationClass eq "Threshold2">	
		
			<cfquery name="Category" 
			datasource="AppsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Ref_ClaimCategoryIndicator C, 
			      Ref_Indicator R
			WHERE R.Code = C.IndicatorCode
			AND   C.EnableThreshold = 1
			</cfquery>
			
			<tr><td colspan="2" align="center"><b>Threshold</b></td></tr>		  
			<TR>
		    		
		    <TD colspan="2">
			
			<table width="100%" cellspacing="0" cellpadding="0">
					    
				<tr bgcolor="ffffff">
					   
						<td></td>
						<td></td>
						<td><b>Type</td>
						<td></td>
						<cfloop query="Actor">
						<td colspan="2"><b>#ClearanceDescription#</td>
						</cfloop>
				</tr>		
										
				<cfloop query="Category">
					
					<tr><td colspan="10" bgcolor="D1D7D0"></td></tr>			
					<tr>
					   
						<td></td>
						<td></td>
						<td>#ClaimCategory#</td>
						<td>#description#</td>
						
						<cfset cde = "#Code#">
						<cfset cat = "#ClaimCategory#">
						
						<cfloop query="Actor">
						
							<cfset mis = "#Mission#">
							<cfset act = "#ClearanceActor#">
							<cfset des = "#ClearanceDescription#">
						
							<cfquery name="Check" 
							datasource="AppsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM  Ref_DutyStationValidation
							WHERE Mission = '#mis#'
							AND   ValidationCode = '#Get.Code#'
							AND   ClearanceActor = '#act#'
							AND   IndicatorCode  = '#cde#'
							AND   ClaimCategory  = '#cat#'
						   </cfquery>
						 
						    <cfset cnt = cnt+1>
										
							<input type="hidden" name="Actor_#cnt#"      value="#act#">
							<input type="hidden" name="Indicator_#cnt#"  value="#cde#">
							<input type="hidden" name="Category_#cnt#"   value="#cat#">
							<td>
							<input type="checkbox" name="selected_#cnt#" onclick="toggle(#cnt#)" value="1" 
							<cfif #Check.recordcount# eq "1">checked</cfif>>
							</td>
							
							<td>
								<cfif #Check.recordcount# eq "1">
									<cfset cl = "amount">
								<cfelse>
									<cfset cl = "hide">
								</cfif>
												
								<cfinput type="Text"
							       name="amount_#cnt#"
							       value="#Check.ThresholdAmount#"
							       message="Please enter a valid amount"
							       validate="float"
							       required="No"
							       visible="Yes"
							       enabled="Yes"
							       size="6"
							       maxlength="8"
							       class="#cl#">
							</td>
						
						</cfloop>
						
					</tr>
										
				</cfloop>
					
			</table>
			</TD>
			</TR>		
			
			<TR>
		    <TD>Enforce resolve:</TD>
    		<TD>
			   <input type="radio" name="enforce" value="1" <cfif get.Enforce neq "0">checked</cfif>>Yes
			   <input type="radio" name="enforce" value="0" <cfif get.Enforce eq "0">checked</cfif>>No
			</TD>
			</TR>  
				
		<cfelseif get.ValidationClass eq "Rule2">
		
		<TR>
	    
		<TD valign="top" height="20">Actors</TD>
	    <TD>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			
		<cfloop query="Actor">
		
			<cfset mis = "#Mission#">
			<cfset act = "#ClearanceActor#">
			<cfset des = "#ClearanceDescription#">
		
			<tr bgcolor="f4f4f4">
				<td height="20">#mis#</td>
				<td>#des#</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>	
			<tr><td height="1" colspan="6" bgcolor="D1D7D0"></td></tr>
						
			<cfloop query="Event">
			
				<cfquery name="Check" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM  Ref_DutyStationValidation
					WHERE Mission = '#mis#'
					AND   ValidationCode = '#Get.Code#'
					AND   ClearanceActor = '#act#'
					AND   EventCode  = '#Code#'
				</cfquery>
				
				<tr>
				    <cfset cnt = cnt+1>
					<td></td>
					<td></td>
					<td>#code#</td>
					<td>#description#</td>
					<input type="hidden" name="Actor_#cnt#" value="#act#">
					<input type="hidden" name="Event_#cnt#" value="#Code#">
					<td>
					<input type="checkbox" name="selected_#cnt#" value="1" 
					<cfif Check.recordcount eq "1">checked</cfif>>
					</td>
					<td>
														
					</td>
				</tr>
				<tr><td colspan="6" bgcolor="D1D7D0"></td></tr>
				
				
				
			</cfloop>
			
		</cfloop>
		
		</table>
		</TD>
		</TR>		
		
		<TR>
	    <TD>Enforce resolve:</TD>
    	<TD>
		   <input type="radio" name="enforce" value="1" <cfif get.Enforce neq "0">checked</cfif>>Yes
		   <input type="radio" name="enforce" value="0" <cfif get.Enforce eq "0">checked</cfif>>No
		</TD>
		</TR>
			
		</cfif>
	
	</cfif>
	
	<tr><td  colspan="2" id="result"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" height="30" align="center">
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<cfif #Get.recordcount# eq "0">
    <input class="button10g" type="submit" name="Insert" value=" Add " onclick="doit('insert')">
	<cfelse>
	<!---
	<input class="buttonFlat" style="width:100" type="button" name="Delete" value=" Delete " onclick="doit('delete')">
	--->
	<input class="button10g" type="submit" name="Update" value=" Save " onclick="doit('modify')">
	</cfif>
	
	</td></tr>
	
</TABLE>

</cfoutput>

</cfform>