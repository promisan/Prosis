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
<cfform action="RecordSubmit.cfm" method="POST">

<!--- edit form --->

<table width="95%" cellspacing="0" align="center" class="formpadding formspacing">

	<tr><td height="7"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD width="65%">
  	   <cfinput type="text" name="SubmissionEdition" value="#get.SubmissionEdition#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
       <input type="hidden" name="Codeold" value="#get.SubmissionEdition#" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" name="EditionDescription" value="#get.EditionDescription#" message="please enter a description" requerided=  "yes" size="50" 
	   maxlenght = "50" class= "regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Acronym:</TD>
    <TD>
  	   <cfinput type="Text" name="EditionShort" style="padding-top:1px;padding-left:3px" value="#get.EditionShort#" message="Please enter an acronym" required="No" size="15" maxlength="15" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Class:</TD>
    <TD>
		<select name="ExerciseClass" class="regularxl">
     	   <cfloop query="Class">
        	   <option value="#Class.ExcerciseClass#" <cfif #Class.ExcerciseClass# eq "#get.ExerciseClass#">selected</cfif>>#ExcerciseClass#</option>
         	</cfloop>
	    </select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Owner:</TD>
    <TD class="labelmedium">
	    #get.Owner#
	</TD>
	</TR>
	
	<cf_calendarscript>
	
	<TR>
    <TD class="labelmedium">Effective:</TD>
	<TD>
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default="#Dateformat(Get.DateEffective, CLIENT.DateFormatShow)#"
		AllowBlank="False" class="regularxl">	
  	</TD>
	</tr>
	
	<TR>
    <TD class="labelmedium">Expiration:</TD>
	<TD>
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default="#Dateformat(Get.DateExpiration, CLIENT.DateFormatShow)#"
		AllowBlank="False" class="regularxl">	
  	</TD>
	</tr>
	
	<TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="Grant access to this roster for VacOfficer of this PostType or deterimed by the Recruitment Track to limit search">Post Type</cf_UIToolTip>:</TD>
    <TD>
		<select name="PostType" size="1" class="regularxl">
		<option value="">All</option>
	    <cfloop query="PostType">
		<option value="#PostType#" <cfif Posttype eq get.Posttype>selected</cfif>>
    		#PostType#
		</option>
		</cfloop>
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
			<cfloop query="Class">
				<option value="#EntityClass#" <cfif Get.EntityClass eq Class.EntityClass>selected</cfif> >#EntityClassName#</option>
			</cfloop>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="The level on which forecast is being performed">Forecast Level</cf_UIToolTip>:</TD>
    <TD>
		<select name="ForecastLevel" size="1" class="regularxl">
			  
			<option value="Bucket" <cfif "Bucket" eq get.ForecastLevel>selected</cfif>>Bucket</option>
			<option value="OccGroup" <cfif "OccGroup" eq get.ForecastLevel>selected</cfif>>Occupational Group and Level</option>
		
	    </select>
		
    </TD>
	</TR>
	
	<TR>
    <TD style="cursor: pointer;" class="labelmedium">
	<cf_UIToolTip tooltip="Allow Recruitment track canddiate shortlisting from this roster">Enable Roster for Recruitment Track</cf_UIToolTip>:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" class="radiol" name="EnableAsRoster" value="0" <cfif "0" eq get.EnableAsRoster>checked</cfif>> No
		<INPUT type="radio" class="radiol" name="EnableAsRoster" value="1" <cfif "1" eq get.EnableAsRoster>checked</cfif>> Yes
	</TD>
	</TR>
	
	<TR>
    <TD style="cursor: pointer;" class="labelmedium"><cf_UIToolTip tooltip="Allow Candidate to be added to a bucket manually.<br> This function is needed in case PHP module is not used">Enable Manual Candidate Recording:</cf_UIToolTip></TD>
    <TD class="labelmedium">
	    <INPUT onclick="document.getElementById('manual').className='hide'" class="radiol" type="radio" name="EnableManualEntry" value="0" <cfif "0" eq get.EnableManualEntry>checked</cfif>> No
		<INPUT onclick="document.getElementById('manual').className='regular'" class="radiol" type="radio" name="EnableManualEntry" value="1" <cfif "1" eq get.EnableManualEntry>checked</cfif>> Yes
	</TD>
	</TR>
	
	<cfif get.EnableManualEntry eq "0">
		 <cfset cl = "Hide">
	<cfelse>
		 <cfset cl = "Regular">	 
	</cfif>
	
	<TR id="manual" class="#cl# labelmedium">
    <TD class="labelmedium">Default status when <b>manually</b> added:</TD>
    <TD>
	    <select name="DefaultStatus" class="regularxl">
     	   <cfloop query="OwnerStatus">
        	   <option value="#OwnerStatus.Status#" <cfif OwnerStatus.Status eq "#get.DefaultStatus#">selected</cfif>>#Meaning#</option>
         	</cfloop>
	    </select>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Edition Search Mode:</TD>
    <TD class="labelmedium">
	  <INPUT type="radio" class="radiol" name="RosterSearchMode" value="3" <cfif "3" eq "#get.RosterSearchMode#">checked</cfif>> default
	  <INPUT type="radio" class="radiol" name="RosterSearchMode" value="1" <cfif "1" eq "#get.RosterSearchMode#">checked</cfif>> Limit associated bucket
	  <INPUT type="radio" class="radiol" name="RosterSearchMode" value="2" <cfif "2" eq "#get.RosterSearchMode#">checked</cfif>> Limit exercise class    
      <INPUT type="radio" class="radiol" name="RosterSearchMode" value="0" <cfif "0" eq "#get.RosterSearchMode#">checked</cfif>> No
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="Operational" value="1" <cfif "1" eq "#get.Operational#">checked</cfif>>
	</TD>
	</TR>	
		
	</cfoutput>
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="35">

		<input style="width:160;height:25" class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input style="width:160;height:25" class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input style="width:160;height:25" class="button10g" type="submit" name="Update" value=" Update ">
		
	</td></tr>
	
</table>

</cfform>