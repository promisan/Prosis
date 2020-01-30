
<cfoutput>

<table width="97%" cellspacing="3" cellpadding="3" align="center">
		
		<tr><td height="7"></td></tr>
				
		<tr><td height="3" colspan="2" class="labelit"><b>General Parameters</b></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Send an eMail to the claimant upon return">Notification to Claimant upon return:</a></td>
	    <TD><input type="radio" name="ReturnReminder" value="1" <cfif Get.ReturnReminder eq "1">checked</cfif>>Enabled
		  <input type="radio" name="ReturnReminder" value="0" <cfif Get.ReturnReminder eq "0">checked</cfif>>Disabled	  
	    </TD>
		</TR>
		
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Send another eMail if not submitted">-  Notification Interval:</a></td>
	    <TD><cfinput type="Text"
       name="ReturnReminderInterval"
       value="#get.ReturnReminderInterval#"
       range="1,15"
       validate="integer"
       size="1"
       maxlength="2"
       style="text-align:center"
         class="regular">			 
	  
	    </TD>
		</TR>
		
					
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Allows workflow actors to resubmit the claim on behalf of the claimant">Allow authorised actors to resubmit a claim:</a></td>
	    <TD><input type="radio" name="EnableActorSubmit" value="1" <cfif #Get.EnableActorSubmit# eq "1">checked</cfif>>Enabled
		  <input type="radio" name="EnableActorSubmit" value="0" <cfif #Get.EnableActorSubmit# eq "0">checked</cfif>>Disabled
	  
	    </TD>
		</TR>
			
		<TR>
	    <td width="260" class="labelit">&nbsp;&nbsp;&nbsp;Calculate Trip duration using Time Zones:</td>
	    <TD><input type="radio" name="EnableGMTTime" value="1" <cfif #Get.EnableGMTTime# eq "1">checked</cfif>>Enabled
		  <input type="radio" name="EnableGMTTime" value="0" <cfif #Get.EnableGMTTime# eq "0">checked</cfif>>Disabled
	  
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Set as Final Liquidation:</td>
	    <TD>
		</tr>
		
		<tr>
			<td align="right" class="labelit">Express claim:</td>
			<td width="30">
			 <input type="checkBox" name="FinalClaimExpress" value="1" <cfif #Get.FinalClaimExpress# eq "1">checked</cfif>>
	        </td>
		</tr>
		<tr>
			<td align="right" class="labelit">Detailed claim:</td>
			<td width="30">
			 <input type="checkBox" name="FinalClaimDetailed" value="1" <cfif #Get.FinalClaimDetailed# eq "1">checked</cfif>>
			</td>			
		</TR>
		
		<cfquery name="Class" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    EntityClass
		FROM      Ref_EntityClass
		WHERE     EntityCode = 'EntClaim'
		</cfquery>
				
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Allow Claimant to enforce this workflow:</td>
	    <TD><select name="WorkflowSelect">
		    <option>N/A</option>
	  	    <cfloop query="class">
			<option value="#EntityClass#" <cfif class.entityClass eq "#get.workflowselect#">selected</cfif>>#entityclass#</option>
			</cfloop>
			</select>
			&nbsp;Option available only if the default workflow (Application Settings) would otherwise be applied.
		
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Flag all claims as incomplete:</td>
	    <TD><input type="radio" name="EnforceIncomplete" value="1" <cfif #Get.EnforceIncomplete# eq "1">checked</cfif>>Enabled
		  <input type="radio" name="EnforceIncomplete" value="0" <cfif #Get.EnforceIncomplete# eq "0">checked</cfif>>Disabled
	  
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Enable 10 - 24 hour DSA rule:</td>
	    <TD><input type="radio" name="Enable10_24DSA" value="1" <cfif Get.Enable10_24DSA eq "1">checked</cfif>>Enabled
		  <input type="radio" name="Enable10_24DSA" value="0" <cfif Get.Enable10_24DSA eq "0">checked</cfif>>Disabled
	  
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Claim Validation Messages:</td>
	    <TD><input type="radio" name="ShowUserValidation" value="1" <cfif Get.ShowUserValidation eq "1">checked</cfif>>Show
		  <input type="radio" name="ShowUserValidation" value="0" <cfif Get.ShowUserValidation eq "0">checked</cfif>>Hide for Claimant
	  
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Enforce Stopover after:</td>
	    <TD>
				<cfinput type="Text"
					       name="StopOverHours"
					       value="#get.StopOverHours#"
					       validate="integer"
					       required="Yes"
					       visible="Yes"
					       enabled="Yes"
					       size="1"
					       maxlength="2"
					       class="amount"> Hours
	    </TD>
		</TR>
		
		<!---
		
		<TR>
	    <td>&nbsp;&nbsp;&nbsp;DSA location mode:</td>
	    <TD>
		<table cellspacing="0" cellpadding="0"><tr><td width="30">
		<input type="radio" name="DSAModeDefine" value="1" <cfif Get.DSAModeDefine eq "1">checked</cfif>>
		</td><td>
		Location at midnight, all stops
		<td></tr>
		<tr><td>
		  <input type="radio" name="DSAModeDefine" value="2" <cfif Get.DSAModeDefine eq "2">checked</cfif>>
		</td>
		<td>	  
		  Location at midnight, stopover/final destination only
	    </td></tr></table>
	    </TD>
		</TR>
		
		--->
			
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;DSA Rate after 120 days:</td>
	    <TD>
			<cfinput class="amount" type="Text" name="DSARate999" value="#get.DSARate999*100#" required="Yes" size="2" maxlength="2"> %
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Default Tolerance:</td>
	    <TD>
			<cfinput class="amount" type="Text" name="ClaimTolerance" value="#get.ClaimTolerance#" required="Yes" size="5" maxlength="5"> USD
	    </TD>
		
		</TR>
		<TR>
		<td class="labelit">&nbsp;&nbsp;&nbsp;Non Obligated Tolerance:</td>
	    <TD>
			<cfinput class="amount" type="Text" name="Nonobligatedthreshold" value="#get.Nonobligatedthreshold#" required="Yes" size="5" maxlength="5"> USD
	    </TD>
		
		</TR>
				
	
		
	</table>
	
	</cfoutput>

		