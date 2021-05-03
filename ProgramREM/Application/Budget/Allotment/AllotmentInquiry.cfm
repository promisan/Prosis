
<head>
	<cfoutput>
	<script type="text/javascript">
	  // Change cf's AJAX "loading" HTML
	  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy10.gif'/>";
	</script>
	</cfoutput>
</head>

<cfajaximport tags="cfchart,cfform">
<cf_listingscript>
<cfinclude template="AllotmentInquiryScript.cfm">
<cf_DialogREMProgram>
<cf_DialogProcurement>
<cf_dialogPosition>

<cfinvoke component="Service.Presentation.Presentation" 
      	  method="highlight" 
		  neutral="labelit"
		  class="highlight3 cellcontent"
		  returnvariable="stylescroll"/>

<cfparam name="url.mode"       default="regular">
<cfparam name="url.print"      default="0">
<cfparam name="url.execution"  default="hide">
<cfparam name="url.view"       default="regular">
<cfparam name="url.caller"     default="">

<cf_tl id="hidden" var="1">
<cfset vNoRights = lt_text>	

<cfset cltotals = "F7EDB9">
<cfset cltotal  = "F1EDDD">
<cfset cltotal1 = "E8F5FD">
<cfset cltotal2 = "F7EDB9">

<cfif url.print eq "1">
   <cfset html  = "No">
<cfelse>
   <cfset html = "Yes">
</cfif>


<!--- -------------------------------------------------------- --->
<!--- passing the programid instead of the period, programcode --->
<!--- -------------------------------------------------------- --->

<cfparam name="url.context"    default="#url.mode#">
<cfparam name="url.ProgramId"  default="">

<cfif url.ProgramId neq "">

	<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramPeriod
		WHERE    ProgramId = '#URL.ProgramId#'		
	</cfquery>
	
	<cfset url.program = get.ProgramCode>
	<cfset url.period  = get.Period>	

<cfelse>

	<cfparam name="URL.Program" default="">
	<cfparam name="URL.Period"  default="">
	
</cfif>

<cfif url.program neq "">

	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Organization.dbo.Organization
		WHERE OrgUnit IN (
				SELECT   OrgUnit
				FROM     ProgramPeriod
				WHERE    ProgramCode = '#URL.Program#'		
				AND      Period      = '#url.period#')
	</cfquery>
	
	<cfset url.mission = Program.mission>

</cfif>


<cfparam name="URL.Version" default="">

<cfif url.program eq "">
	Problem, contact administrator
    <cfabort>
</cfif>

<!--- ---------------------------------------------------- --->
<!--- --define planning period on the fly if not passed--- --->
<!--- ---------------------------------------------------- --->

<cfif url.period eq "">

	<cfquery name="Last" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     ProgramPeriod
		WHERE    ProgramCode = '#URL.Program#'
		ORDER BY ProgramId DESC	
	</cfquery>
	
	<cfif Last.recordcount eq "1">
			<cfset url.period = Last.Period>
	<cfelse>
	
		 <table align="center"><tr><td style="padding-top:40px" align="center" class="labelmedium">
	    Problem with period definition, please contact administrator
		</td></tr></table>
	       
			<cfabort>
	</cfif>			

</cfif>

<!--- -------------------------------------------------- --->
<!--- -define planning version on the fly if not passed- --->
<!--- -------------------------------------------------- --->

<cfif url.version eq "">

	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Program
		WHERE    ProgramCode = '#URL.Program#'		
	</cfquery>

	<cfquery name="Version" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      A.Version
	FROM        Organization.dbo.Ref_MissionPeriod P INNER JOIN Program.dbo.Ref_AllotmentEdition A ON P.EditionId = A.EditionId
	WHERE       P.Mission = '#url.mission#' 
	AND         P.Period = '#URL.period#'
	</cfquery>
	
		
	<cfif Version.recordcount eq "1">
		<cfset url.version = Version.Version>	
	<cfelse>
	
	   <table align="center"><tr><td style="padding-top:40px" align="center" class="labelmedium">
	    Problem with version definition, please contact administrator.
		</td></tr></table>
		<cfabort>
	</cfif>		

</cfif>

<!--- adjustment to set fund 19/11/2009 --->

<cfset url.fund = "">
<cfparam name="URL.Fund"    default="">
<cfparam name="URL.Width"   default="0">
<cfparam name="URL.Method"  default="">

<cfoutput>
	
	<script language="JavaScript1.2">		
	
	    function objectinfo(code) {
		
			se = document.getElementById("box"+code)
			if (se.className == "regular") {	
			   ptoken.navigate('AllotmentObjectDisplay.cfm?action=display&objectcode='+code,'box'+code)		   
			   se.className = "highlight"
			} else {
			   ptoken.navigate('AllotmentObjectDisplay.cfm?action=regular&objectcode='+code,'box'+code)
			   se.className = "regular" 
			}		
		}
	
		function printme() {
			ptoken.open("AllotmentInquiry.cfm?#CGI.Query_String#&print=1","allotment","left=10, top=10, width=800, height=800, toolbar=no, status=no, scrollbars=no, resizable=yes")
		}		
				
		function allotdrill(prg,per,edit) {
		  	ptoken.open("#SESSION.root#/ProgramREM/Application/Budget/Allotment/Clearance/AllotmentView.cfm?Program=" + prg + "&Period=" + per + "&Edition=" + edit, "_blank", "left=10, top=20, width=1100, height=950, toolbar=no, status=yes, scrollbars=no, resizable=yes");
			// if (ret == 1) {
		    // ColdFusion.navigate('AllotmentClear.cfm?programcode='+prg+'&period='+per+'&editionid='+edit,'box'+edit)		
			//   history.go()
			// }
		}  					
	
	</script>
		
</cfoutput>
	
	<cf_tl id="Version" var="1">
	<cfset vVersion=lt_text>
	
	<cf_tl id="Planning Period" var="1">
	<cfset vPlanning=lt_text>
	
	<cfquery name="VersionName" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentVersion
		WHERE    Code = '#URL.Version#'		
	</cfquery>
			
	<cfquery name="Param" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_ParameterMission
		WHERE      Mission = '#url.Mission#'	   
	</cfquery>
		
			
	<cfif url.print eq "1">	
		
		<cf_screenTop height="100%" systemModule="Program" jquery="Yes"  html="No" band="no" scroll="yes" banner="blue" title="Budget Entry | #vVersion#: #url.version# | #vPlanning#: #URL.period# | #Param.BudgetCurrency#">
	
	<cfelseif url.mode eq "Embed" or url.context eq "Embed">   
	
		<cf_screenTop height="100%" systemModule="Program" jquery="Yes" html="No" layout="webapp" band="no" banner="blue" scroll="yes" title="Budget Entry | #vVersion#: #url.version# | #vPlanning#: #URL.period# | #Param.BudgetCurrency#"> 
 
	<cfelseif url.mode eq "regular">
		
		<cf_tl id="Budget Requirement and Allotment Registration" var="vTitle">
	
		<cf_screenTop height="100%" 
	          option="#vVersion#: <b>#url.version# #versionname.description#</b> | #vPlanning#: <b>#URL.period# | #Param.BudgetCurrency#</b>" 
	          Label="#vTitle#"
			  html="#html#" band="no" systemModule="Program" FunctionName="AllotmentDialog" layout="webapp" banner="blue" menuAccess="context"				
			  scroll="yes" JQuery="yes">
					
	<cfelse>
		
		<cf_tl id="Budget Requirement and Allotment Registration" var="vTitle">
	
		 <cf_screenTop height="100%" 
              option="#vVersion#: <b>#url.version# #versionname.description#</b> | #vPlanning#: <b>#URL.period# | #Param.BudgetCurrency#</b>" 
              Label="#vTitle#"
		      html="#html#" band="no" systemModule="Program" FunctionName="AllotmentDialog" layout="webapp" banner="blue" bannerforce="Yes" 		   			
			  scroll="yes" JQuery="yes">
			  				   
	</cfif>  
	
<cfif url.version eq "">

    <cf_tl id="Problem, no allotment version defined" var="1">
	<cf_message message="#lt_text#" return="no">
	<cfabort>

</cfif>

<cfquery name="Version" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_AllotmentVersion E
	WHERE      Code = '#URL.Version#'
</cfquery>

<!--- redirection --->

<cfquery name="MissionPeriod" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_MissionPeriod
	WHERE    Mission = '#Program.Mission#'	
	AND      Period  = '#URL.Period#'
</cfquery>

<cfif MissionPeriod.PlanningPeriod neq "">		
	<cfset url.period = MissionPeriod.PlanningPeriod>
</cfif>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Period 
		WHERE    Period      = '#URL.Period#'
</cfquery>
	
<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Program P,ProgramPeriod Pe
		WHERE    P.ProgramCode = Pe.ProgramCode
		AND      P.ProgramCode = '#URL.Program#'
		AND      Pe.Period     = '#URL.Period#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Organization
	WHERE    OrgUnit = '#Program.OrgUnit#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Mission.Mission#'
</cfquery>

 <cfif Parameter.BudgetAmountMode eq "0">
 	<cfset spac = "25">
 <cfelse>
	<cfset spac = "21">
 </cfif>
 
<cfif Mission.recordcount eq "0">
  
  <cf_tl id="Tree or Program for this preparation period #URL.Period# was not initiated" var="1" Class="Message">	
  <cfset vMessage = lt_text>
  <cf_message status="Notification" 
              message = "<cfoutput>#vMessage#</cfoutput>" 
			  return = "no">
  <cfabort>

</cfif>

<cfparam name="URL.ProgramCode" default="#URL.Program#">

<cf_ProgramPeriodEdition mission="#url.mission#" period="#url.period#" version="#url.version#">

<cfif Edition.recordcount eq "0">

  <cf_tl id="No allotment editions were defined for fund" var="1">
  <cfset vMessage2=lt_text>
  
  <cf_message message = "<cfoutput>#vMessage2#: #URL.Fund#.</cfoutput>"
  return = "back">
  <cfabort>

</cfif>

<cfset No = 0>
<cfset editionList = "">

<cfset objectfilter = "1">


<cfoutput query="Edition">

	<cfinvoke component = "Service.Process.Program.Position"  
	   method           = "CreatePosition" 
	   EditionId        = "#editionid#" 
	   Period           = "#url.period#">		
	
	 <cfif editionlist eq "">
	    <cfset editionlist = EditionId>
	 <cfelse>
	    <cfset editionlist = "#editionlist#,#EditionId#">
	 </cfif>
	 
	 <cfif BudgetEntryMode eq "0" and Program.EnforceAllotmentRequest eq "0">
	 	<cfset objectfilter = 0>
	 </cfif>
	 
	 <cfset No = No + 1>
	  
</cfoutput>


<!--- -------------------------------------------------------------------------------------------- --->
<!--- set the correct plan period : added by Hanno to make the view being able to mix plan periods --->
		  
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
								 AND    PeriodClass = '#Period.PeriodClass#')  		
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

<!--- --------------------------------------------------------------- --->	

<cfset editionstring = "#quotedValueList(Edition.EditionId)#">

<cfinclude template="AllotmentPrepare.cfm">

<cfset header = 1>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

<cfif url.mode neq "Embed" and url.context neq "Embed">
	<!--- banner menu --->
	<tr><td height="20" style="padding:3px">	
	<cfinclude template="AllotmentInquiryMenu.cfm"></td>
	</tr>	
</cfif>

<tr><td height="100%" style="padding-left:12px;padding-right:12px">

<cf_divscroll>

<table width="99%" height="100%" border="0"	 align="center">	  

<tr><td style="height:20px">

	<cfset url.attach   = "1">
	<cfset url.titleedit = "1">
	<cfinclude template="../../Program/Header/ViewHeader.cfm">

</td></tr>

<cfoutput>
	<script>	
						
		function viewallot(view) {   
	   		ptoken.location("AllotmentInquiry.cfm?view="+view+"&Mode=#url.mode#&Context=#url.context#&Program=#url.Program#&Version=#url.version#&period=#url.period#&caller=#URL.caller#&Width=#URL.Width#&method=#URL.Method#"	)	
		}	 
				    		
	</script>	
</cfoutput>
   
<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#url.Mission#'
</cfquery>

<tr class="hide"><td height="200" id="result"></td></tr>

<cf_menucontainer item="1" class="regular">
		 
	<cfif Program.Status eq "0" and CheckMission.workflowEnabled eq "1" and Program.ProgramClass neq "Program">
	
		 <font color="FF0000"><cf_tl id="Your new project record has not been cleared. Please contact your administrator">
					
	<cfelse>
		
	  	<cfinclude template="AllotmentInquiryCost.cfm">  
		
				
	</cfif>
		
</cf_menucontainer>

<cf_menucontainer item="2" class="hide"/>

</table>

</cf_divscroll>

</td></tr>

<tr><td style="height:12px"></td></tr>

</table>

<cfoutput>
   <input type="hidden" name="Program" id="Program"     value="#URL.Program#">
   <input type="Hidden" name="Fund" id="Fund"        value="#URL.Fund#">
</cfoutput>   

<cfif url.print eq "1">
   <script>
   window.print()
   </script>
<cfelse>
   <cf_screenbottom layout="webapp">
</cfif>
