<cfoutput>

<cfparam name="URL.ProgramId"    type="string" default="">
<cfparam name="URL.ProgramCode"  type="string" default="0">
<cfparam name="URL.Period"       type="string" default="0">

<cfif url.programId neq "">

	<cfquery name="Check" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Program P, ProgramPeriod Pe
	 WHERE  P.ProgramCode = Pe.ProgramCode 
	 AND    Pe.ProgramId = '#URL.ProgramId#'	
	</cfquery>
	
	<cfset url.ProgramCode = check.programCode>
	<cfset url.Period = check.period>
	<cfset url.ProgramLayout = check.ProgramClass>
	
<cfelse>

	<cfquery name="Check" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Program P, ProgramPeriod Pe
	 WHERE  P.ProgramCode  = Pe.ProgramCode 
	 AND    P.ProgramCode  = '#URL.ProgramCode#'	
	 AND    Pe.Period      = '#URL.Period#'  
	</cfquery>

</cfif>
		 
<cfif check.recordcount eq "0">

	<cf_message message="This record no longer exists in the database.">
	<cfabort>
	
</cfif>	 

<cfparam name="URL.ProgramLayout" type="string" default="#Check.ProgramClass#">
<cfparam name="URL.AuditId" type="string" default="0">

<cfset Width = "#CLIENT.width-250#">

<cfquery name="Parameter" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Check.Mission#'
</cfquery>

<cfquery name="Mission" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT DISTINCT O.Mission
 FROM   ProgramPeriod P INNER JOIN
        Organization.dbo.Organization O ON P.OrgUnit = O.OrgUnit
 WHERE  ProgramCode = '#Check.ProgramCode#'
 AND    Period = '#Check.Period#'	
</cfquery>


<cfquery name="Parent"					<!--- get default values for entry fields:  if URL.EditCode eq "" values will be empty --->
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
    SELECT *
    FROM #CLIENT.LanPrefix#Program
	WHERE ProgramCode = '#Check.PeriodParentCode#'
</cfquery>

<cfif Parent.ProgramNameShort neq "">

	<cfset label = Parent.ProgramNameShort>
	
<cfelse>

	<cf_tl id="Program Details" var="lbl">
	<cfset label = "#lbl#">
		
</cfif>

<cfset url.mission = mission.mission>

<cf_screenTop height="100%" 
      band="No" 
	  layout="webapp" 	   
	  banner="blue" 
	  bannerforce="Yes"
	  menuAccess="Context" 
	  SystemModule="Program"
	  FunctionClass="Window"
	  FunctionName="Program"
      label="#label# #Mission.Mission#"  
	  jQuery="Yes">
		

<cf_layoutScript>
<cfajaximport tags="cfform">

<cfoutput>
	<script>
		function doProjectValidations() {
			ptoken.navigate('#session.root#/ProgramREM/Application/Program/ProgramViewValidation.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&ProgramId=#check.ProgramId#', 'divValidations');
		}
	</script>
</cfoutput>
		
<cf_tl id="ActionPlanDetail" var="1" edit="0">
<cfset tActionPlanDetail = "#Lt_text#">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  
				
<cf_layout type="border" id="mainLayout" width="100%">	
			
	<cf_layoutArea 
			name       ="left" 
			position   ="left" 
			collapsible="true"
			size       ="240px"  
			overflow   ="scroll">
			
			<table width="100%">
				<tr>
					<td>
						<cfinclude template="ProgramViewMenu.cfm">			
						<cfinclude template="ProgramViewScript.cfm">
					</td>
				</tr>
			</table>	
		
	</cf_layoutArea>
	
	
			
	<cf_layoutArea 
			name="center" 
			position="center">
										
			<cfswitch expression="#URL.ProgramLayout#">
			
				<cfcase value="Program">
								
				    <iframe src="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Mission=#Mission.Mission#&Period=#Check.Period#&mid=#mid#" name="right" id="right" width="100%" height="100%" scrolling="no" frameborder="0" framespacing="0" target="_self"></iframe>
				  
				</cfcase>
				
				<cfcase value="Component">
				
				    <cfif Parameter.DefaultOpenProgram eq "Activity">										
					  <iframe src="../Activity/Progress/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Mission=#Mission.Mission#&Period=#Check.Period#&mid=#mid#" name="right" frameborder="0" id="right" scrolling="no" width="100%" height="100%" framespacing="1" target="_self"></iframe>									  
					<cfelse>					
						<cfif Parameter.EnableIndicator eq "1">
						<iframe src="Indicator/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Mission=#Mission.Mission#&Period=#Check.Period#&Layout=#URL.ProgramLayout#&mid=#mid#" name="right" frameborder="0" id="right" width="100%" height="100%" framespacing="0" scrolling="no" target="_self"></iframe>
						<cfelse>						
						<iframe src="ActivityProgram/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Mission=#Mission.Mission#&Period=#Check.Period#&Layout=#URL.ProgramLayout#&mid=#mid#" name="right" frameborder="0" id="right" width="100%" height="100%" framespacing="0" scrolling="no" target="_self"></iframe>
						</cfif>
						
					</cfif>
					
				</cfcase>
							
				<cfcase value="Project">
					
					<cfif Parameter.DefaultOpenProgram eq "Activity">
					  <iframe src="../Activity/ActivityMain.cfm?Mission=#Mission.Mission#&width=#Width#&ProgramCode=#Check.ProgramCode#&Period=#Check.Period#&Size=Small&output=1&mid=#mid#" name="right" frameborder="0" id="right" scrolling="no" width="100%" height="100%" framespacing="1" target="_self"></iframe>															
					<cfelseif Parameter.DefaultOpenProgram eq "Require">
					  <iframe src="Resource/ResourceView.cfm?Mission=#Mission.Mission#&width=#Width#&ProgramCode=#Check.ProgramCode#&Period=#Check.Period#&Size=Small&output=1&mid=#mid#" name="right" frameborder="0" id="right" scrolling="no" width="100%" height="100%" framespacing="1" target="_self"></iframe>															
					<cfelseif Parameter.DefaultOpenProgram eq "Summary">
					   <iframe src="Summary/Summary.cfm?Mission=#Mission.Mission#&width=#Width#&ProgramCode=#Check.ProgramCode#&Period=#Check.Period#&Size=Small&output=1&mid=#mid#" name="right" frameborder="0" id="right" scrolling="no" width="100%" height="100%" framespacing="1" target="_self"></iframe>										
					<cfelse>
					  	<iframe src="Events/EventsView.cfm?Mission=#Mission.Mission#&width=#Width#&ProgramCode=#Check.ProgramCode#&Period=#Check.Period#&Size=Small&output=1&mid=#mid#" name="right" frameborder="0" id="right" scrolling="no" width="100%" height="100%" framespacing="1" target="_self"></iframe>				
					</cfif>						
					
				</cfcase>			
			
			</cfswitch>

	</cf_layoutArea>
	
	<cf_layoutarea size="220"  position="right" name="validationbox" initcollapsed="Yes" collapsible="Yes">
		
		<cf_divscroll>
			<cfdiv id="divValidations" style="margin:5px;"> 	  
		</cf_divscroll>	
					
	</cf_layoutarea>	

</cf_layout>						

</cfoutput>

<cfset AjaxOnLoad("function(){ doProjectValidations(); }")>

<cf_screenbottom layout="webapp">
