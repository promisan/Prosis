
<cfquery name="Ownership" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterOwner
		WHERE Owner = '#URL.Owner#'
</cfquery>

<cfoutput query="Ownership">

<CFFORM action="ParameterEditOwnerSubmit.cfm?owner=#url.owner#" method="post">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white" class="formpadding formspacing">

	<tr><td height="8"></td></tr>	
				
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td width="60%">Roster Operational:</td>
    <TD>
			
	<cfoutput>
	<input type="radio" name="Operational_#Owner#" <cfif Operational eq "1">checked</cfif> value="1">Active
	<input type="radio" name="Operational_#Owner#" <cfif Operational eq "0">checked</cfif> value="0">Disabled	
	</cfoutput>
	
    </td>
    </tr>
	
	
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"> <cf_UIToolTip
	  tooltip="eMail addressed used for any batch or automated mail messages from the roster">Batch eMail FROM address:</cf_UIToolTip></td>
    <TD>
	 
      <cfinput class="regularxl" type="text" name="DefaultEmailAddress_#Owner#" value="#DefaultEmailAddress#" size="30" maxlength="30"   style="text-align: center;" message="Please enter a valid email address" validate="email">
  
    </td>
    </tr>
	
	<!--- to be deactivated --->
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;">The period after which an unprocessed applications may be archived.</td>
    <TD>
	    <cfinput class="regularxl" type="text" name="ProcessDays_#Owner#" value="#ProcessDays#" size="3" maxlength="3" style="text-align: center;" message="Please enter a correct number" validate="integer"> days
    </td>
    </tr>
		
		
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td width="40%" style="cursor: pointer;">	
	The duration a Selected/ShortListed candidate is tagged as <b>[selected]</b> in roster searches and recruitment tracks:	
	</td>	
    <TD>
	 <table cellspacing="0" cellpadding="0">
	  <tr>
	  <td>
	  <cfinput class="regularxl" 
	           type="text" 
			   name="SelectionDays_#Owner#" 
			   value="#SelectionDays#" 
			   size="3" 
			   maxlength="3"   
			   style="text-align: center;" 
			   message="Please enter a correct number" 
			   validate="integer"> 
	  </td><td>&nbsp;days&nbsp;</td>
	  <td>
	  <input type="checkbox" name="SelectionDaysOverwrite_#Owner#" <cfif SelectionDaysOverwrite eq "1">checked</cfif> value="1">
	  </td>
	  <td>&nbsp;<cf_UIToolTip  tooltip="Trackowner overwrite validation">Allow Recruitment Owner overwrite</cf_UIToolTip></td>
	  </tr>  
	  </table>
    </td>
	      
    </tr>
	
	<TR class="labelmedium">
	<td width="20"></td>
    <td colspan="2" width="40%" style="cursor: pointer;">
	Exception script:
		<textarea class="regular" style="font-size:13px;padding:3px;width:90%;height:40" name="SelectionFilterScript_#Owner#">#SelectionFilterScript#</textarea>
	
	</tr>
	
	
	<!---	18/8/2009 discontinue this is now defined on the bucket level 
		
	 <!--- Field: Hours --->
    <TR>
	<td width="20"><img src="#SESSION.root#/images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;">
	<cf_UIToolTip
	  tooltip="Not operational : Will trigger an eMail to candidate once perriod has been exceeded and will reset the the status of the candidacy.">
	The period for which a cleared candidate will remain to be rostered:
	</cf_UIToolTip>
	</td>
	
    <TD>	  
      <cfinput class="regular" type="text" name="RosterDays_#Owner#" value="#RosterDays#" size="3" maxlength="3"   style="text-align: center;" message="Please enter a correct number" validate="integer"> days   
    </td>
    </tr>
	
	--->
	
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;">
	<cf_UIToolTip tooltip="Roster Edition Presentation"><font color="808080">Roster Presentation:</font> Hide Buckets with no candidates:</cf_UIToolTip>
	</td>
    <TD>
	
	<cfoutput>
	<input type="radio" name="HideEmptyBucket_#Owner#" <cfif #HideEmptyBucket# eq "1">checked</cfif> value="1">Yes
	<input type="radio" name="HideEmptyBucket_#Owner#" <cfif #HideEmptyBucket# eq "0">checked</cfif> value="0">No, show all buckets in Roster
	</cfoutput>
	
    </td>
    </tr>	
	
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><cf_UIToolTip tooltip="Roster Edition Presentation"><font color="808080">Roster Presentation:</font> Hide Buckets that are Position Specific:</cf_UIToolTip></td>
    <TD>
	
	<cfoutput>
	<input type="radio" name="HidePostSpecific_#Owner#" <cfif HidePostSpecific eq "1">checked</cfif> value="1">Yes, hide
	<input type="radio" name="HidePostSpecific_#Owner#" <cfif HidePostSpecific eq "0">checked</cfif> value="0">No, include all buckets in Roster
	</cfoutput>
	
    </td>
    </tr>	
	
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;">
	<cf_UIToolTip
	  tooltip="Allow search for a specific VA Number as part of the Roster search Function."><font color="808080">Roster Search:</font> Allow Roster Search for a specific VA
	</cf_UIToolTip>
	</td>
    <TD>
	
	<cfoutput>
	<input type="radio" name="EnableVARosterFilter_#Owner#" <cfif EnableVARosterFilter eq "1">checked</cfif> value="1">Enabled
	<input type="radio" name="EnableVARosterFilter_#Owner#" <cfif EnableVARosterFilter eq "0">checked</cfif> value="0">Disabled
	</cfoutput>
	
    </td>
    </tr>
			
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td><font color="808080">Roster Search:</font> Filter roster searches results for Post Specific Buckets (VA):</td>
    <TD>	
	<cfoutput>
	<input type="radio" name="RosterSearchBucketVA_#Owner#" <cfif RosterSearchBucketVA eq "1">checked</cfif> value="1">Yes
	<input type="radio" name="RosterSearchBucketVA_#Owner#" <cfif RosterSearchBucketVA eq "0">checked</cfif> value="0">No, hide
	</cfoutput>	
    </td>
    </tr>
		
	<cfquery name="Class" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_FunctionClass
	</cfquery>
		
	 <!--- Field: Editions --->
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;">
	<cf_UIToolTip
	  tooltip="Buckets can only be created for functions recorded under the selected class.<br> Refer also to Staffing table Position creation.">
	
	<cf_tl id="Allow only functional titles from class">
	</cf_UIToolTip>
	:</b></td>
    <TD>
	
	<cfset sel = FunctionClassSelect>
	<select name="FunctionClassSelect_<cfoutput>#Owner#</cfoutput>" class="regularxl">
	<cfloop query = "Class">
	 <option value="#FunctionClass#" <cfif #sel# eq "#Class.FunctionClass#">selected</cfif>>#FunctionClass#</option>  
    </cfloop>  
    </td>
    </tr>
		
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td colspan="2">
	<table width="100%" cellspacing="0" cellpadding="0"><tr class="labelmedium"><td width="170"><cf_tl id="Custom PHP Text">:</td>
	<td class="labelmedium">
	  root/custom/
      <cfinput class="regularxl" type="text" name="PathHistoryProfile_#Owner#" value="#PathHistoryProfile#" size="40" maxlength="80"   style="text-align: left;" message="Please enter a path">
	  </td>
	</table>  
     </td>
    </tr>
		
	<TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td colspan="2">
	<table width="100%"  cellspacing="0" cellpadding="0"><tr class="labelmedium"><td width="170"><cf_tl id="Custom VA Text">:</td>
	<td>
	  root/custom/
      <cfinput class="regularxl" type="text" name="PathVacancyText_#Owner#" value="#PathVacancyText#" size="40" maxlength="80"   style="text-align: left;" message="Please enter a path">
	</td>
	</table>  
     </td>
    </tr>
			
	<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_SubmissionEdition
	WHERE Owner = '#Owner#'
	</cfquery>
	
	 <!--- Field: Editions --->
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><font color="808080">Edition:</font><cf_tl id="Candidacy manually entered are associated to buckets in edition">:</td>
    <TD>
	
	<cfset val = "#DefaultRoster#">		
	<select name="DefaultRoster_#Owner#" class="regularxl">
		<cfloop query = "Edition">
			 <option value="#SubmissionEdition#" <cfif #val# eq "#SubmissionEdition#">selected</cfif>>#EditionDescription#</option>  
	    </cfloop>  
	<input type="checkbox" name="DefaultRosterAdd_<cfoutput>#Owner#</cfoutput>" <cfif #DefaultRosterAdd# eq "1">checked</cfif> value="1"><cf_tl id="Enabled">
		
    </td>
    </tr>
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><font color="808080">Edition:</font><cf_tl id="Buckets incepted through the recruitment track module are associated to this edition">:</td>
    <TD>
	
	<cfset val = "#DefaultSubmission#">
	
	<select name="DefaultSubmission_#Owner#" class="regularxl">
	<cfloop query = "Edition">
	 <option value="#SubmissionEdition#" <cfif #val# eq "#SubmissionEdition#">selected</cfif>>#EditionDescription#</option>  
    </cfloop>  
    </td>
    </tr>
	
	<!--- Field: Editions --->
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td><font color="808080">Roster Presentation:</font><cf_tl id="Show Recruitment request roster edition also under roster management">:</td>
    <TD>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>
		<cfoutput>
		<input type="radio" name="DefaultSubmissionShow_#Owner#" <cfif DefaultSubmissionShow eq "1">checked</cfif> value="1"><cf_tl id="Yes">
		<input type="radio" name="DefaultSubmissionShow_#Owner#" <cfif DefaultSubmissionShow eq "0">checked</cfif> value="0">No
		</cfoutput>
		</td>
		<td></td>
		</tr>
		</table>
    </td>
    </tr>
		
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><font color="808080">Roster Status:</font> <cf_tl id="Allow substantive clearer to propose candidates for other buckets">.</b></td>
    <TD>
	<cfoutput>
	<input type="radio" name="EnableRosterTransfer_#Owner#" <cfif EnableRosterTransfer eq "1">checked</cfif> value="1"><cf_tl id="Yes">
	<input type="radio" name="EnableRosterTransfer_#Owner#" <cfif EnableRosterTransfer eq "0">checked</cfif> value="0">No
	</cfoutput>
    </td>
    </tr>		
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><cf_UIToolTip tooltip="Automatically filter roster search results">
	<cf_tl id="Filter roster search results to candidates that meet the <b>minimum</b> bucket requirements">:
	</cf_UIToolTip>
	</b></td>
    <TD>
	<cfoutput>
	<input type="radio" name="RosterSearchMinimum_#Owner#" <cfif RosterSearchMinimum eq "1">checked</cfif> value="1"><cf_tl id="Yes">
	<input type="radio" name="RosterSearchMinimum_#Owner#" <cfif RosterSearchMinimum eq "0">checked</cfif> value="0">No
	</cfoutput>
    </td>
    </tr>		
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><cf_UIToolTip tooltip="Show current assignment information of a short listed candidates">
	<font color="808080">Candidate Presentation:</font><cf_tl id="Show the last assignment for a candidate as part of roster search listing">:</cf_UIToolTip></td>
    <TD>
	<cfoutput>
	<input type="radio" name="ShowLastAssignment_#Owner#" <cfif ShowLastAssignment eq "1">checked</cfif> value="1"><cf_tl id="Yes">
	<input type="radio" name="ShowLastAssignment_#Owner#" <cfif ShowLastAssignment eq "0">checked</cfif> value="0">No
	</cfoutput>
    </td>
    </tr>	
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td style="cursor: pointer;"><cf_UIToolTip tooltip="Show review actions that are pending in the recruitment track module for the short listed candidates">
	<font color="808080">Candidate Presentation:</font><cf_tl id="Show pending review action for candidate in recruitment track">:</cf_UIToolTip></td>
    <TD>
	<cfoutput>
	<input type="radio" name="ShowPendingReview_#Owner#" <cfif ShowPendingReview eq "1">checked</cfif> value="1"><cf_tl id="Yes">
	<input type="radio" name="ShowPendingReview_#Owner#" <cfif ShowPendingReview eq "0">checked</cfif> value="0">No
	</cfoutput>
    </td>
    </tr>	
	
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td><font color="808080">Candidate:</font><cf_tl id="Allow Candidate Review events to be initiated even when active event are not yet completed">:</td>
    <TD>
	<cfoutput>
	<input type="radio" name="AddReviewPointer_#Owner#" <cfif AddReviewPointer eq "1">checked</cfif> value="1"><cf_tl id="Yes">
	<input type="radio" name="AddReviewPointer_#Owner#" <cfif AddReviewPointer eq "0">checked</cfif> value="0">No
	</cfoutput>
    </td>
    </tr>
		
    <TR class="labelmedium">
	<td width="20"><img src="#SESSION.root#/Images/pointer.gif" alt="" border="0"></td>
    <td><font color="808080">Roster Status:</font><cf_tl id="Allow Roster Manager to direct Roster already cleared candidates">:</td>
    <TD>
	<cfoutput>
	<input type="radio" name="RosterCandidateManual_#Owner#" <cfif RosterCandidateManual eq "1">checked</cfif> value="1"><cf_tl id="Enabled">
	<input type="radio" name="RosterCandidateManual_#Owner#" <cfif RosterCandidateManual eq "0">checked</cfif> value="0">Disabled
	</cfoutput>
    </td>
    </tr>
		
	<tr><td height="39" colspan="7" align="center" valign="middle">
		<input type="button" value="Back" class="button10s"  onclick="menu()" style="height:22;width:100px">	
		<input type="submit" name="Update" value="Update" class="button10s" style="height:22;width:100px">
	</td></tr>
		
	</table>


</cfform>		

</cfoutput>	