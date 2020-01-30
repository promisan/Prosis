
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Roster Edition" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_calendarScript>
			  
<cfquery name="Class"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ExerciseClass
</cfquery>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT R.PostType
    FROM Ref_PostType R
</cfquery>

<cfquery name="Owner"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ParameterOwner
	WHERE Owner IN (SELECT Owner FROM Applicant.dbo.Ref_StatusCode)
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" class="formpadding formspacing" align="center">

	<tr><td></td></tr>

    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="text" name="SubmissionEdition" id="SubmissionEdition" value="" message="Please enter a code" required="Yes" size="15" maxlength="10" class="regularxl">
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" name="EditionDescription" id="EditionDescription" value="" message="Please enter a description"  required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Acronym:</TD>
    <TD>
  	   <input type="text" name="EditionShort" id="EditionShort" value="" size="15" maxlength="15" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Class:</TD>
    <TD>
		<select name="ExerciseClass" id="ExerciseClass" class="regularxl">
		   <cfoutput query="Class">
        	<option value="#Class.ExcerciseClass#">#Class.ExcerciseClass#
			</option>
         	</cfoutput>
	    </select>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Owner:</TD>
    <TD>
		<select name="Owner" id="Owner" class="regularxl">
     	   <cfoutput query="Owner">
        	<option value="#Owner.Owner#">#Owner#
			</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="The level on which forecast is being performed. <br>NB:Both levels include the organizational context">Forecast Level</cf_UIToolTip>:</TD>
    <TD>
		<select name="ForecastLevel" id="ForecastLevel" size="1" class="regularxl">
			  
			<option value="Bucket" selected>Bucket</option>
			<option value="OccGroup">Occupational Group and Level</option>
		
	    </select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Post type:</TD>
    <TD>
		<select name="PostType" id="PostType" size="1" class="regularxl">
		<option value="">All</option>
	    <cfoutput query="PostType">
		<option value="#PostType#">
    		#PostType#
		</option>
		</cfoutput>
	    </select>
		
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">Nomination materials flow:</TD>
    <TD>
	
	<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode = 'CanSubmission'
	</cfquery>
		
		<cfselect name="EntityClass" id="EntityClass" class="regularxl">
		    <option value=""></option>
			<cfoutput query="Class">
				<option value="#EntityClass#">#EntityClassName#</option>
			</cfoutput>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Include in Candidate Search (Recruitment):</TD>
    <TD class="labelmedium">
		<table><tr class="labelmedium">
		<td><INPUT type="radio" name="EnableAsRoster" id="EnableAsRoster" value="0"></td>
		<td style="padding-left:5px">No</td>
		<td style="padding-left:10px"><INPUT type="radio" name="EnableAsRoster" id="EnableAsRoster" value="1" checked></td>
		<td style="padding-left:5px">Yes</td>
		</tr>
		</table>
	</TD>
	</TR>
	
	<TR>
    <TD style="cursor: pointer;" class="labelmedium" ><cf_UIToolTip tooltip="Allow Candidate to be added to a bucket manually.<br> This function is needed in case PHP module is not used">Add Candidates Manually:</cf_UIToolTip></TD>
    <TD class="labelmedium">
	   
		<table><tr class="labelmedium">
		<td><INPUT type="radio" name="EnableManualEntry" id="EnableManualEntry" value="0"></td>
		<td style="padding-left:5px">No</td>
		<td style="padding-left:10px"><INPUT type="radio" name="EnableManualEntry" id="EnableManualEntry" value="1" checked></td>
		<td style="padding-left:5px">Yes</td>
		</tr>
		</table>	   
	</TD>
	</TR>
	
	<TR valign="top">
    <TD class="labelmedium">Roster Search Mode:</TD>
    <TD>
	    <INPUT type="radio" name="RosterSearchMode" id="RosterSearchMode" value="3" checked> Default <br>
		<INPUT type="radio" name="RosterSearchMode" id="RosterSearchMode" value="1"> Limit recruitment search to associated bucket
		<INPUT type="radio" name="RosterSearchMode" id="RosterSearchMode" value="0"> Hide
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Effective:</TD>
	<TD>
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		AllowBlank="False" class="regularxl">	
  	</TD>
	</tr>
		
	<TR>
    <TD class="labelmedium">Expiration:</TD>
	<TD>
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default="#Dateformat(now()+360, CLIENT.DateFormatShow)#"
		AllowBlank="False" class="regularxl">	
  	</TD>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>
	<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>		
	</tr>
	
	</CFFORM>
	
</TABLE>
