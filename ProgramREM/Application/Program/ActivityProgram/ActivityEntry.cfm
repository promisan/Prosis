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

<cf_screenTop height="100%" html="No" scroll="yes" jquery="yes">

<cf_calendarscript>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight";
	 }else{
		
     itm.className = "regular";		
	 }
  }
  
  function hourDayHighlight(day, hour, color){
  	$('#day_'+day).css('background-color', color);
	$('#hour_'+hour).css('background-color', color);
	$('#tdHourDay_'+hour+'_'+day).css('background-color', color);
  }
  
  function applyunit(org) {    
  	ptoken.navigate('setUnit.cfm?orgunit='+org,'process')
  }

</script>

<style>
	.k-content { background-color: rgba(255, 255, 255, 0) !important;}
</style>

<cf_dialogREMProgram>
<cf_dialogOrganization>

<cfif URL.ActivityID eq "">
	<cfset Update="no">
	<cf_tl id="Register New" var="1">
	<cfset Action="#lt_text#">
	<CFSET SubmitAction="ActivityEntrySubmit.cfm">
<cfelse>
	<cfset Update="yes">
	<cf_tl id="Edit" var="1">
	<cfset Action="#lt_text#">
	<CFSET SubmitAction="ActivityEntryUpdate.cfm?ActivityID=#URL.ActivityID#">
</cfif>

<cfform action="#SubmitAction#" method="POST" name="ActivityEntry">

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Period
	ORDER BY Period
</cfquery>


<cfparam Name="URL.Period" default="">
<cfparam Name="URL.ProgramCode" default="">
<cfparam Name="URL.ActivityID" default="">
<cfset URL.ActivityID = TRIM("#URL.ActivityID#")>

<!--- Query returning search results for activities  --->
<cfquery name="EditActivity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT A.*, O.Mission, 
	       O.OrgUnitName as OrganizationName, 
		   O.OrgUnitName, 
		   O.OrgUnitClass,
		   O.MandateNo,
		   O.OrgUnitCode
	FROM   ProgramActivity A left join Organization.dbo.#CLIENT.LanPrefix#Organization O on  A.OrgUnit = O.OrgUnit
	WHERE  A.ActivityID = '#URL.ActivityID#' 
	ORDER BY ActivityDate DESC
</cfquery>

<cfquery name="ActionParent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *	
    FROM   ProgramActivity
	WHERE  ProgramCode = '#URL.ProgramCode#'
	AND    ActivityPeriod = '#URL.Period#'
	AND    ActivityId != '#EditActivity.ActivityId#'
	ORDER BY ActivityDateStart DESC
</cfquery>

<table width="98%" align="center">

<tr><td>
	<cfinclude template="../Header/ViewHeader.cfm">
</td></tr>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT O.OrgUnitName, 
	       Pe.OrgUnit, 
		   O.OrgUnitCode, 
		   O.OrgUnitClass,
		   O.Mission, 
		   O.MandateNo, 
		   P.ProgramClass
    FROM ProgramPeriod Pe, Organization.dbo.#CLIENT.LanPrefix#Organization O, Program P
	WHERE Pe.ProgramCode = '#URL.ProgramCode#'
	AND Pe.Period = '#URL.Period#'
	AND Pe.Orgunit = O.OrgUnit
	AND P.ProgramCode = Pe.ProgramCode
</cfquery>

<tr><td>

<table width="99%" align="center" class="formpadding formspacing">

  <tr class="line">
    <td width="100%" style="height:30;font-size:20px;font-weight:200" class="labellarge" colspan="2" align="left" valign="middle">
	<cfoutput>
    	#Action# <cf_tl id="ongoing program activity"></b>
	</cfoutput>
    </td>
  </tr> 	     
   			
	<cfoutput>
		<input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">		
	</cfoutput>

    <!--- Field: Activity Date --->

	<cfif Update eq "Yes">
		<cfset DefaultDate=#EditActivity.ActivityDate#>
		<cfset DefaultDateStart=#EditActivity.ActivityDateStart#>
	<cfelse>
		<cfset DefaultDate=now()>
		<cfset DefaultDateStart=now()>
	</cfif>
		 	
    <!--- Field: Activity Description--->
	<TR class="labelmedium">
        <td valign="top"><cf_tl id="Activity">:</td>
		<cfoutput>
        <TD class="regular">
		
		<cf_LanguageInput
			TableCode       = "ProgramActivity" 
			Mode            = "Edit"
			Name            = "ActivityDescription"
			Value           = "#EditActivity.ActivityDescription#"
			Key1Value       = "#URL.ProgramCode#"
			Key2Value       = "#URL.Period#"
			Key3Value       = "#URL.ActivityID#"
			Type            = "Text"
			cols            = "68"
			rows            = "3"
			Class           = "regularxl">
		</cfoutput>
	</TR>
	
	<TR class="labelmedium">
    <TD style="min-width:200px"><cf_tl id="Short Description">:</TD>
    <TD class="labelit">
	
		<cfinput class="regularxl" name="ActivityDescriptionShort" value="#EditActivity.ActivityDescriptionShort#" type="text" size="30" maxlength="50" required="no">
		
	</TD>
	</TR>
	
	<cfif Program.ProgramClass eq "Project">
			
	    <TR class="labelmedium">
	    <TD><cf_tl id="Start date">:</TD>
	    <TD>
		
			  <cf_intelliCalendarDate9
			FieldName="ActivityDateStart" 
			Default="#Dateformat(defaultdateStart, CLIENT.DateFormatShow)#"
			class="regularxl"
			AllowBlank="False">	
				
		</TD>
		</TR>
		
		<cfelse>
		
		<input type="hidden" name="ActivityDateStart" id="ActivityDateStart">
	
	</cfif>
		
	<TR class="labelmedium">
    <TD><cf_tl id="Ongoing until">:</TD>
    <TD class="labelit">
	
		  <cf_intelliCalendarDate9
		FieldName="ActivityDate" 
		Default="#Dateformat(defaultdate, CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="False">	
			
	</TD>
	</TR>
		
    <!--- Field: Reference--->
    <TR class="labelmedium">
    <TD><cf_tl id="Reference">:</TD>
    <TD>
	
		<cfinput class="regularxl" name="Reference" value="#EditActivity.Reference#" type="text" size="20" maxlength="20" required="no">
		
	</TD>
	</TR>
	
	<cfif EditActivity.ActivityPeriod eq "">
	   <cfset per = URL.Period>
    <cfelse>
       <cfset per = EditActivity.ActivityPeriod>
	</cfif>
			
	<cfif Program.ProgramClass eq "Project">
			
    <!--- Field: Period --->
    <TR class="labelmedium">
    <TD><cf_tl id="Activity period">:</TD>
    <TD class="labelit">
	 	   	
    	<select name="Period" class="regularxl" message="Please select a program period" required="Yes">
	    <cfoutput query="Period">
		<option value="#Period#" <cfif #per# eq #Period#> SELECTED</cfif>>
		#Period#
		</option>
		</cfoutput>
	    </select>		
	</TD>
	</TR>
	
	<cfelse>
	
	<input type="hidden" name="Period" id="Period" value="<cfoutput>#per#</cfoutput>">
	
	</cfif>
		
	<!--- Field: Organization--->
	<TR class="labelmedium">
    <TD><cf_tl id="Responsible unit">:</TD>
		
    <TD>
	<cfset vOrgUnit = EditActivity.OrgUnit>
	<cfset vOrgUnitName = EditActivity.OrgUnitName>
	<cfset vOrgUnitClass = EditActivity.OrgUnitClass>
	<cfset vOrgUnitCode = EditActivity.OrgUnitCode>
	<cfset vOrgUnitMission = EditActivity.Mission>
	<cfset vOrgUnitMandateNo = EditActivity.MandateNo>
	<cfif url.activityid eq "">
		<cfset vOrgUnit = Program.OrgUnit>
		<cfset vOrgUnitName = Program.OrgUnitName>
		<cfset vOrgUnitClass = Program.OrgUnitClass>
		<cfset vOrgUnitCode = Program.OrgUnitCode>
		<cfset vOrgUnitMission = Program.Mission>
		<cfset vOrgUnitMandateNo = Program.MandateNo>
	</cfif>
	<cfoutput>
		<table>
		<tr>
		<td><input type="text" name="orgunitname" id="orgunitname" value="#vOrgUnitName#" class="regularxl" size="50" maxlength="40" readonly></td>
		<td style="padding-left:3px">
			<input type="button" style="cursor:pointer;height:25;width:40" class="button10g" name="search" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass', '#vOrgUnitMission#', '#vOrgUnitMandateNo#')"> 
			<input type="hidden" name="orgunit" id="orgunit" value="#vOrgUnit#">
			<input type="hidden" name="orgunitcode" id="orgunitcode" value="#vOrgUnitCode#">
		    <input type="hidden" name="mission" id="mission" value="#vOrgUnitMission#">
			<input type="hidden" name="orgunitclass" id="orgunitclass" value="#vOrgUnitClass#" class="disabled" size="20" maxlength="20" readonly> 
		</td></tr>
		</table>
	
	</cfoutput>

	
	</TD>
	</TR>	
	
	<cf_verifyOperational module="Staffing" Warning="No">
	
    <cfif Operational eq "1">
 			
		<cfquery name="Location" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    *
	    FROM     Location
		WHERE    Mission = '#Program.Mission#'
		ORDER BY LocationName
		</cfquery>
		
		<TR class="labelmedium">
	    <TD><cf_tl id="Location">:</TD>
	    <TD class="labelit">
										
			<cfquery name="LocationList" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   N.Code,N.Name,L.LocationCode,L.Description,N.Continent,LocationDefault
				FROM     Ref_PayrollLocation L, 
				         System.dbo.Ref_Nation N,
						 Ref_PayrollLocationMission M
				WHERE    L.LocationCountry = N.Code
				AND      M.LocationCode = L.LocationCode
				AND      M.Mission = '#Program.Mission#'	
				AND      M.BudgetPreparation = 1	
				AND      N.Code != 'UUU'			
				ORDER BY N.Name,L.LocationCode,L.Description
			</cfquery>
			
			<cfif LocationList.recordcount eq "0">
			
				<cfquery name="LocationList" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   Code,Name,LocationCode,L.Description,Continent,'' as LocationDefault
					FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
					WHERE    L.LocationCountry = N.Code		
					AND      N.Code != 'UUU'			
					ORDER BY Name, LocationCode,Description
				</cfquery>			
			
			</cfif>
		
		   	<select name="LocationCode" size="1" class="regularxl">
			<option><cf_tl id="n/a"></option>
		    <cfoutput query="LocationList">
			<option value="#LocationCode#" <cfif EditActivity.LocationCode eq LocationCode>selected</cfif>>
	    		#Description#
			</option>
			</cfoutput>
		    </select>
		</TD>
		</TR>
	
	</cfif>
	
	<cfquery name="ClassAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT F.*, 
		       A.ProgramCode as Selected
		FROM   Ref_ActivityClass F LEFT OUTER JOIN
	           ProgramActivityClass A ON F.Code = A.ActivityClass AND A.ActivityId = '#URL.ActivityID#'	   	
		WHERE  F.Code IN (SELECT Code 
		                  FROM   Ref_ActivityClassMission 
						  WHERE  Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.ProgramCode#'))	   
	</cfquery>	
	
	<cfif ClassAll.recordcount gte "1">
			
	<TR class="labelmedium">
    <td valign="top" style="padding-top:4px"><cf_tl id="Classification">:</td>
    <td class="labelit">		
		<cfinclude template="ActivityEntryClass.cfm"> 	
	</td>
	</TR>
	
	</cfif>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Order">:</TD>
    <TD class="labelit">
	
		<cfinput class="regularxl" name="ListingOrder" value="#EditActivity.ListingOrder#" type="text" size="2" maxlength="4" required="yes" style="text-align:center;">
		
	</TD>
	</TR>
   
   <TR class="labelmedium">
    <td width="130" valign="top" style="padding-top:5px;"><cf_tl id="Activity Week schedule">:</td>
    <td valign="top" style="padding-top:2px;">
		<cfinclude template="ActivitySchemaView.cfm">	
	 </td>
   </tr>	
   
   <cfif EditActivity.ActivityId neq "">
		
	<TR class="labelmedium">
    <td width="130"><cf_tl id="Attachments">:</td>
    <td>
	
	 <cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#EditActivity.ProgramCode#" 
		Filter="#EditActivity.ActivityId#"
		Insert="yes"
		width="100%"
		box="att#EditActivity.ActivityId#"
		Remove="yes"
		Highlight="no"
		Listing="yes">
			
	 </td>
	 </tr>		
	 
	 </cfif>
   
   
   <tr><td height="5"></td></tr>	 
   <tr><td colspan="2" class="line"></td></tr>	 
   <tr><td height="5"></td></tr>
   <tr><td height="38" colspan="2" align="center">
   	 <cfoutput>
	 	<cf_tl id="Back" var="vCancel">
		<cf_tl id="Save"   var="vSave">
        <input type="button" name="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
	    &nbsp;
	    <input class="button10g" type="submit" name="Submit" value="#vSave#">	  
	 </cfoutput>
   </td></tr>
  
  </table>
   
 </td></tr>
 
 <tr><td id="process"></td></tr>
 
 </table>
   
</CFFORM>

<cf_screenbottom html="No">
