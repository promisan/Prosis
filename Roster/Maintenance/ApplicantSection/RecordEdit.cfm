
<cfparam name="url.idmenu" default="">

<cfif url.id1 eq "">
	<cf_tl id="Add Navigation Section" var="vTitle">
<cfelse>
	<cf_tl id="Edit Navigation Section" var="vTitle">
</cfif>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="#vTitle#" 
			  menuAccess="Yes" 
			  jquery="yes"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ApplicantSection
		<cfif url.id1 neq "">
			WHERE 	Code = '#URL.ID1#'
		<cfelse>
			WHERE 	1=0
		</cfif>
</cfquery>

<cf_tl id="Do you want to remove this section?" var="1">
<cfoutput>
	<script>
	
		function askDelete(id) {
			if (confirm("#lt_text#")) {	
				ptoken.navigate('RecordPurge.cfm?id='+id,'divRemove');
			}
		}	
		
		function toggleElement(ct,sel) {
			if($(sel).first().is(':visible')) {
				$(sel).css('display','none');
			}else{
				$(sel).css('display','');
			}
		}
		
	</script>
</cfoutput>

<cfform action="RecordSubmit.cfm?id1=#url.id1#" method="POST" enablecab="Yes" name="dialog">

	<table width="95%" align="center" class="formpadding formspacing">
	
	    <cfoutput>
	    <TR>
	    <TD class="labelmedium" width="30%"><cf_tl id="Code">:</TD>
	    <TD class="labelmedium">
			<cfif url.id1 neq "">
			   	#get.Code#
		  	   	<input type="hidden" name="Code" id="Code" value="#get.Code#" size="10" maxlength="10" class="regularxl">
			<cfelse>
				<input type="Text" name="Code" id="Code" value="#get.Code#" size="10" maxlength="10" class="regularxl">
			</cfif>
			<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Trigger Group">:</TD>
	    <TD><cfinput type="Text" name="TriggerGroup" value="#get.TriggerGroup#" message="Please enter a Trigger Group" required="no" size="10" maxlength="20" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Description">:</TD>
	    <TD><cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="no" size="30" maxlength="50" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" title="Please enter a description tooltip" style="cursor:pointer"><cf_tl id="Tooltip">:</TD>
	    <TD><cfinput type="Text" name="DescriptionTooltip" value="#get.DescriptionTooltip#" message="Please enter a description tooltip" required="no" size="50" maxlength="100" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" valign="top" style="padding-top:4px;"><cf_tl id="Instruction">:</TD>
	    <TD valign="top" style="padding-top:4px;">
	  	   <cf_textarea name="Instruction" class="regularxl" rows="5" style="padding:3px;font-size:13px;width:90%;border:1px solid ##C0C0C0;">
			   	#get.Instruction#	
		   </cf_textarea>
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Instruction Image">:</TD>
	    <TD><cfinput type="Text" name="InstructionImage" value="#get.InstructionImage#" required="no" size="50" maxlength="50" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Condition">:</TD>
	    <TD><cfinput type="Text" name="ShowCondition" value="#get.ShowCondition#" required="no" size="50" maxlength="200" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Topic Id">:</TD>
	    <TD><cfinput type="Text" name="TemplateTopicId" value="#get.TemplateTopicId#" required="no" size="10" maxlength="20" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Template URL">:</TD>
	    <TD><cfinput type="Text" name="TemplateURL" value="#get.TemplateURL#" required="no" size="50" maxlength="100" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Passtru Condition">:</TD>
	    <TD><cfinput type="Text" name="TemplateCondition" value="#get.TemplateCondition#" required="no" size="50" maxlength="100" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Progress Checkbox">:</TD>
	    <TD class="labelmedium">
	  	  	<INPUT type="radio" name="ProgressCheckbox" id="ProgressCheckbox" value="0" onclick="toggleElement(this,'.clsProgress');" <cfif get.ProgressCheckbox eq "0" or url.id1 eq "">checked</cfif>> No
			<INPUT type="radio" name="ProgressCheckbox" id="ProgressCheckbox" value="1" onclick="toggleElement(this,'.clsProgress');" <cfif get.ProgressCheckbox eq "1">checked</cfif>> Yes
	    </TD>
		</TR>
		
		<cfset vProgressShow = "">
		<cfif get.ProgressCheckbox eq 0 or url.id1 eq "">
			<cfset vProgressShow = "display:none;">
		</cfif>
		
		<TR>
	    <TD class="labelmedium clsProgress" style="padding-left:20px; #vProgressShow#"><cf_tl id="Icon Done">:</TD>
	    <TD class="clsProgress" style="#vProgressShow#">
	  	  	<cfinput type="Text" name="ProgressIconDone" value="#get.ProgressIconDone#" required="no" size="50" maxlength="50" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium clsProgress" style="padding-left:20px; #vProgressShow#"><cf_tl id="Icon Pending">:</TD>
	    <TD class="clsProgress" style="#vProgressShow#">
	  	  	<cfinput type="Text" name="ProgressIconPending" value="#get.ProgressIconPending#" required="no" size="50" maxlength="50" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Order">:</TD>
	    <TD><cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" required="yes" message="Please enter a valid listing order" validate="integer" size="2" maxlength="4" style="text-align:center;" class="regularxl"></TD>
		</TR>
		
		<TR>
	    <TD  class="labelmedium"><cf_tl id="Reset On Update">:</TD>
	    <TD class="labelmedium">
	  	  	<INPUT type="radio" name="ResetOnUpdate" id="ResetOnUpdate" value="0" onclick="toggleElement(this,'.clsReset');" <cfif get.ResetOnUpdate eq "0" or url.id1 eq "">checked</cfif>> No
			<INPUT type="radio" name="ResetOnUpdate" id="ResetOnUpdate" value="1" onclick="toggleElement(this,'.clsReset');" <cfif get.ResetOnUpdate eq "1">checked</cfif>> Yes
	    </TD>
		</TR>
		
		<cfset vResetShow = "">
		<cfif get.ResetOnUpdate eq 0 or url.id1 eq "">
			<cfset vResetShow = "display:none;">
		</cfif>
		
		<TR>
	    <TD class="labelmedium clsReset" style="padding-left:20px; #vResetShow#"><cf_tl id="Parent">:</TD>
	    <TD class="clsReset" style="#vResetShow#">
	  	  	<cfinput type="Text" name="ResetOnUpdateParent" value="#get.ResetOnUpdateParent#" required="no" size="5" maxlength="10" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" valign="top" style="padding-top:4px;"><cf_tl id="Owners">:</TD>
	    <TD class="labelmedium" valign="top" style="padding-top:4px;">
	  	  	<cfinclude template="SectionOwners.cfm">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Obligatory">:</TD>
	    <TD class="labelmedium">
	  	  	<INPUT type="radio" name="Obligatory" id="Obligatory" value="0" <cfif get.Obligatory eq "0" or url.id1 eq "">checked</cfif>> No
			<INPUT type="radio" name="Obligatory" id="Obligatory" value="1" <cfif get.Obligatory eq "1">checked</cfif>> Yes
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Operational">:</TD>
	    <TD class="labelmedium">
	  	  	<INPUT type="radio" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>> No
			<INPUT type="radio" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1" or url.id1 eq "">checked</cfif>> Yes
	    </TD>
		</TR>
		
		</cfoutput>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
			
		<tr>
		<td align="center" colspan="2" valign="bottom">
		<table class="formspacing"><tr><td>
			<cfoutput>
				<cf_tl id="Delete" var="1">
		    	<input class="button10g" style="width:150px;" type="Button" name="Delete" value="      #lt_text#      " onclick="askDelete('#url.id1#')">
				</td>
				<td>
				<cf_tl id="Save" var="1">
		    	<input class="button10g" style="width:150px;" type="submit" name="Update" value="      #lt_text#      ">
			</cfoutput>
			</td></tr></table>
		</td>	
		</tr>
		
	</table>	

</cfform>

<cfdiv id="divRemove">
