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

<!--- ----------------------------------------------- --->
<!--- template used for start of the batch entry mode --->
<!--- ----------------------------------------------- --->

<cfparam name="url.mode"        default="regular">
<cfparam name="url.context"     default="regular">
<cfparam name="URL.Program"     default="P001">
<cfparam name="URL.Fund"        default="">
<cfparam name="URL.EditionId"   default="">
<cfparam name="URL.Version"     default="">
<cfparam name="URL.Method"      default="">
<cfparam name="URL.Status"      default="0">
<cfparam name="URL.View"        default="regular">
<cfparam name="URL.Width"       default="0">
<cfparam name="URL.ProgramCode" default="#URL.Program#">

<cfinclude template="../Request/RequestScript.cfm">

<cfif editionid neq "">

	<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentEdition
		WHERE    EditionId   = '#URL.EditionId#'
	</cfquery>

	<cfset url.version = edition.version>
	
</cfif>


<cfif url.version eq "">

	<cfquery name="getProgram" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Program
		WHERE    ProgramCode = '#URL.Program#'		
	</cfquery>

	<cfquery name="getVersion" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      DISTINCT A.Version
	FROM        Organization.dbo.Ref_MissionPeriod P INNER JOIN Program.dbo.Ref_AllotmentEdition A ON P.EditionId = A.EditionId
	WHERE       P.Mission = '#getProgram.Mission#' 
	AND         P.Period = '#URL.period#'
	</cfquery>
		
	<cfif getVersion.recordcount eq "1">	
		<cfset url.version = getVersion.Version>	
	<cfelse>
		<table align="center"><tr><td class="labelmedium">
	    Problem with version definition, please contact administrator.
		</td></tr></table>
		<cfabort>
	</cfif>		

</cfif>

<cfquery name="Version" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentVersion
		WHERE    Code  = '#URL.Version#' 
</cfquery>

  <cf_tl id="Budget Entry" var="1">
  <cfset vBudget = lt_text> 	
 
  <cf_tl id="Version" var="1">
  <cfset vVersion = lt_text> 	

  <cf_tl id="Planning Period" var="1">
  <cfset vPlanning = lt_text> 	
  
<cfif url.mode eq "Embed" or url.context eq "Embed">   

	<cf_screenTop height="100%" title="#vBudget# | #vVersion#: #url.version# | #vPlanning#: #URL.period#"  jquery="Yes" html="No" scroll="yes"> 

<cfelse> 

	<cf_screenTop label="#vBudget# | #vVersion#: <b>#url.version#</b> | #vPlanning#: <b>#URL.period#</b> " 
	 title="#vBudget# | #vVersion#: #url.version# | #vPlanning#: #URL.period#" 
	 height="100%" html="Yes" scroll="yes" layout="webapp" banner="gray" line="no" jquery="Yes">

</cfif> 

<cf_dialogREMProgram>

<cfset URL.Caller = "Internal">

<cfparam name="URL.Width" default="0">
<cfparam name="URL.ProgramCode" default="#URL.Program#">

<cfform style="height:100%" action="AllotmentEntrySubmit.cfm?context=#url.context#&Mode=#url.Mode#&Status=#URL.Status#&Caller=#URL.Caller#&Width=#URL.Width#&Method=#URL.Method#" method="POST" name="entry">

<cfquery name="Class" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     ProgramClass
	FROM       Program
	WHERE      ProgramCode = '#Program#'	   
</cfquery>

<cfset header = 1>

<cfif URL.Status eq "0">
	<cfset ActionString = "Save">
<cfelse>
	<cfset ActionString = "Clear">
</cfif>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       ProgramPeriod
	WHERE      ProgramCode = '#Program#'	   
	AND        Period      = '#url.period#'
</cfquery>

<cfif Check.recordcount eq "0">
  
  <cf_tl id="Tree or Program for this period #URL.Period# was not initiated." var="1" Class="Message">	
  <cfset vMessage = lt_text>
  <cf_message status="Notification" 
              message = "<cfoutput>#vMessage#</cfoutput>" 
			  return = "no">
  <cfabort>

</cfif>

<cfoutput>
<table width="100%" height="100%"
    border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
<tr><td colspan="#Edition.recordcount+1#" style="padding:8px" height="30"> 
	<cfinclude template="../../Program/Header/ViewHeader.cfm">
</td></tr>

<cfinclude template="AllotmentSearch.cfm">

<!--- creates the table for data entry --->

<!--- -------------------------------------------------------------------------------------------- --->
<!--- set the correct plan period : added by Hanno to make the view being able to mix plan periods --->

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Period 
		WHERE    Period      = '#URL.Period#'
</cfquery>
		  
<cfloop index="EditionId" list="#EditionList#" delimiters=",">	  
	  				   
   <cfquery name="Edit" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT     *
	   FROM       Ref_AllotmentEdition
	   WHERE      EditionId = '#EditionId#'	   
    </cfquery>
		  				
	<!--- --------------------------------------------------------------- --->
  	<!--- determine the appropriate plan period to be used for an edition --->
	<!--- --------------------------------------------------------------- --->	
				 		  
	<cfif edit.period neq url.period>
		  
		  <cfquery name="LastPlanPeriodUsed" 
		   datasource="AppsProgram" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT     TOP 1 *
		   FROM       ProgramAllotmentDetail
		   WHERE      ProgramCode = '#url.program#'
		   AND        EditionId   = '#EditionId#'	
		   AND        Amount > 0
		   <!--- has a plan period higher than the current period --->
		   AND        Period IN (SELECT Period
		                         FROM   Ref_Period
								 WHERE  DateEffective > '#Period.DateEffective#'
								 AND   PeriodClass = '#Period.PeriodClass#')  		
		   ORDER BY	Created 							   
		  </cfquery>
		  		  
		  <!--- if for this edition/program we have a later plan period, we take this as the basis for 
		  showing data and for maintaining, we can also move this so we can show this as allotment --->
		  			  
		  <cfif LastPlanPeriodUsed.recordcount gte "1">
		  				  
		  	  <!--- we have a valid entry for this program in a later plan period which will then supersede --->				  
			  <cfparam name="e#editionId#planperiod" default="#LastPlanPeriodUsed.Period#">			 			  
			  <cfset planperiod = evaluate("e#editionId#planperiod")>	 
			 			  			  
		  <cfelse>
		  
		  	  <cfparam name="e#editionId#planperiod" default="#url.period#">	  
		  				  
		  </cfif>	 
		   
	<cfelse>
	
		<cfparam name="e#editionId#planperiod" default="#url.period#">	  	  				  
			  
	</cfif>
  	
</cfloop>

<cfinclude template="AllotmentPrepare.cfm"> 

<cfoutput>

	<script LANGUAGE = "JavaScript">	
	
		function searchobject() {		  
			filter = document.getElementById("criteria").value;
			ColdFusion.navigate('AllotmentListing.cfm?programcode=#URL.program#&Period=#URL.Period#&Version=#URL.Version#&EditionId=#URL.EditionId#&FileNo=#FileNo#&Fund=#URL.Fund#&keyword='+filter,'dListing');
		}
				
		function viewallot() { 		
	   		ptoken.location("AllotmentInquiry.cfm?context=#url.context#&Mode=#url.mode#&Program=#url.ProgramCode#&Version=#url.version#&period=#url.period#&caller=#URL.caller#&Width=#URL.Width#&method=#URL.Method#"	)	
		}	 
				    		
	</script>	
	
</cfoutput>

<tr>
<td height="100%" id="dListing" style="padding:10px">
   <cf_divscroll>    
   	  <cfinclude template="AllotmentListing.cfm">	
   </cf_divscroll>
</td>
</tr>

	<tr>
	<td height="20" style="padding:7px;border-top:1px solid silver"><cfset vsearch="No">
		<cfinclude template="AllotmentActions.cfm">
	</td>
	</tr>

</table>
</cfoutput>

</cfform>

<cf_screenbottom layout="webapp">
