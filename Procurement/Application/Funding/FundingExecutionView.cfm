<cfparam name="url.value" default="">

<cf_screentop height="100%"
      html="No" 			
	  title="Fund Selection Dialog for #URL.Mission#" 
	  scroll="yes"
	  jQuery="Yes"
	  busy="busy10.gif"
	  flush="No">
	  
<script>
	parent.Prosis.busy('yes')
</script>	  
	  
<cf_presentationscript>	  
<cf_DialogProcurement>
				  
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>	

<cfquery name="Edition" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#URL.EditionId#' 
</cfquery>

<cfparam name="url.unithierarchy" default="">

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT MandateNo, Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif url.period eq "">
	<!--- periods to be considered --->
	<cfelse>
	AND       EditionId IN (
	                        SELECT  EditionId
							FROM    Ref_MissionPeriod
							WHERE   Mission = '#URL.Mission#'
							AND     Period  = '#URL.Period#'
							)  
	</cfif>						
</cfquery>

<cfset persel    = "">
<cfset peraccsel = "">
<cfset man       = "">

<cfloop query="Expenditure">

  <!--- ----------set the mandate for unit selection --------------------------------------- --->
  <!--- Attention : issue if the edition crosses several periods and has a different mandate --->
  <!--- ------------------------------------------------------------------------------------ --->
  
  <cfset man = MandateNo>
  
  <cfif MandateNo neq man>
     <cfset unit = "No">  
  </cfif>

  <cfif persel eq "">
     <cfset persel = "'#Period#'"> 
	 <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset persel = "#persel#,'#Period#'">
	 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
    
</cfloop>

<!--- check for full access to the inquiry --->

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT TOP 1 * 
        FROM   OrganizationAuthorization
		WHERE  UserAccount    = '#SESSION.acc#'
		AND    Mission        = '#URL.Mission#'
		AND    Role           = 'ProcReqInquiry'
		AND    ClassParameter = '#URL.EditionId#'	
		AND    OrgUnit is NULL
</cfquery>	
	
<cfif check.recordcount gte "1" or getAdministrator(url.mission) eq "1">
	
		<cfquery name="UnitList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Organization	         
			WHERE    Mission   = '#URL.Mission#'
			AND      MandateNo = '#man#'	
			<!--- 
			AND      OrgUnit IN (SELECT OrgUnit 
			                     FROM  Program.dbo.ProgramPeriod 
								 WHERE Mission   = '#URL.Mission#')						 
								 
								 --->
								 
			ORDER BY HierarchyCode	
		</cfquery>
			
<cfelse>

	<!--- pending provision for inquiry role --->
						
		<cfquery name="getRole" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AuthorizationRole
				WHERE  Role = 'ProcReqInquiry' 
		</cfquery>
		
		<cfquery name="UnitList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Organization Org	         
			WHERE    Mission   = '#URL.Mission#'
			AND      MandateNo = '#man#'	
			
			<!---
			
			AND      OrgUnit IN (SELECT OrgUnit 
			                     FROM  Program.dbo.ProgramPeriod 
								 WHERE Mission   = '#URL.Mission#')
								 
			--->
								 					
			<!--- grant only access to units to which you have access --->
			
			<cfif getRole.OrgUnitLevel eq "All">
			
				AND     OrgUnit IN (
				                    SELECT OrgUnit				                   
				                    FROM   OrganizationAuthorization A
									WHERE  A.UserAccount    = '#SESSION.acc#'
									AND    A.Mission        = '#URL.Mission#'
									AND    A.Role           IN ('ProcReqInquiry','BudgetOfficer','BudgetManager')
									AND    A.ClassParameter = '#URL.EditionId#'								
								   )	
								   						  		
			
			<cfelse>
						
				<!--- derrive the parent code and include all units under it --->
						
				AND     HierarchyRootUnit IN (
									
				                    SELECT OrgUnitCode 
				                    FROM   OrganizationAuthorization A, Organization O
									WHERE  O.OrgUnit        = A.OrgUnit
									AND    O.Mission        = Org.Mission
									AND    O.MandateNo      = Org.MandateNo
									AND    A.UserAccount    = '#SESSION.acc#'
									AND    A.Mission        = '#URL.Mission#'									
									AND    A.ClassParameter = '#URL.EditionId#'
									AND    A.Role            IN ('ProcReqInquiry','BudgetOfficer','BudgetManager')
									AND    O.MandateNo      = '#man#'
									
								   )		
								   
			</cfif>					   	
							 
			ORDER BY HierarchyCode	
			
		</cfquery>
		
		<cfif url.unithierarchy eq "">
		
			<cfset url.unithierarchy = unitList.hierarchycode>
			
		</cfif>
			
</cfif>		

<cfquery name="MissionPeriod" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	AND       Period  = '#URL.PlanningPeriod#'
</cfquery>		

<table style="width:100%;height:100%">

<tr><td style="padding-bottom:8px" valign="top">
		 
	<table style="height:100%;padding:10px;width:100%">
	
		<input type="hidden" name="view" id="view">
		<input type="hidden" name="value" id="value">
			
		<tr>
			
			<td height="32" colspan="1">
			
				<cfoutput>
			
				<table width="100%">
	
				<tr class="line">
									
				<td>
				
					<table border="0">
					<tr>
					
						<cfset myurl = "ptoken.navigate('FundingExecutionBox.cfm?man=#man#&hierarchy='+document.getElementById('applyhierarchy').checked+'&view='+document.getElementById('view').value+'&value='+document.getElementById('value').value+'&find='+document.getElementById('findsearch').value+'&mission=#mission#&planningperiod=#planningperiod#&period=#period#&editionid=#editionid#&currency='+document.getElementById('currency').value+'&unithierarchy='+document.getElementById('orgunit').value,'content')">
																
						<td style="height:40px;padding-left:3px">
											
						   <cfoutput>
								
							<select name="orgunit" id="orgunit" class="regularxxl" style="background-color:f1f1f1;width:398px;border:0px;"
			           			onchange="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('FundingExecutionBox.cfm?man=#man#&hierarchy='+document.getElementById('applyhierarchy').checked+'&view='+document.getElementById('view').value+'&value='+document.getElementById('value').value+'&find='+document.getElementById('findsearch').value+'&mission=#mission#&planningperiod=#planningperiod#&period=#period#&editionid=#editionid#&currency='+document.getElementById('currency').value+'&unithierarchy='+this.value,'content')">
			
								<cfif getAdministrator(url.mission) eq "1" or check.recordcount gte "1">
									<option value="">All</option>
								</cfif>	
							
								<cfloop query="UnitList">		
													 		
									<cfset l = len(HierarchyCode)-2>
									<cfif l lt 0><cfset l = 0></cfif>						
									<option value="#HierarchyCode#">#RepeatString("&nbsp;",l)##OrgUnitCode# #OrgUnitName#</option>
								  												
								</cfloop>		
							
							</select>
								
						   </cfoutput>									  			 						
							
					   </td>						
																			
						<td style="padding-left:5px">	
						
							<table>
								<tr><td>								
								<input type="checkbox" 
								    onclick="#myurl#" class="radiol" name="applyhierarchy" id="applyhierarchy" value="1" checked>							
								</td>							
								<td style="padding-left:5px;padding-right:5px" class="labelmedium2"><cf_tl id="Roll-up projects"></td>						
								</tr>
							</table>
						
						</td>					
											
						<cfinvoke component="Service.Access"  
							Method         = "budget"		
							Mission        = "#url.mission#"
							Period         = "#URL.PlanningPeriod#"	
							EditionId      = "#URL.editionid#"  
							Scope          = "Parent"
							Role           = "'BudgetManager'"
							ReturnVariable = "BudgetAccess">													
				
						<cfif ((BudgetAccess is "ALL" or BudgetAccess is "EDIT") 
						    and Edition.AllocationEntryMode eq "2")> 	
						
						    <td style="padding-left:4px">|</td>
							<td align="center" style="padding-left:4px" class="labelmedium">
													
							<cf_tl id="Released" var="1">					
							
							<a href="javascript:Allocation('#url.editionid#','#url.PlanningPeriod#')">#lt_text#&nbsp;(a2)</a>
							
							<cf_space spaces="42">
													   
							</td>
							 
						</cfif> 
															
						<td class="labelmedium2" style="padding-left:4px;padding-right:4px;border-left:1px solid silver">
							<!---<a href="javascript:printme()"><font color="0080C0">Printable&nbsp;version</a> --->
							<span id="printTitle" style="display:none;"><span style="font-weight:bold; font-size:25px;"><cf_tl id="Budget Execution" var="1">#ucase("#lt_text# #url.mission# #url.PlanningPeriod#")#</span></span>
							<cf_tl id="Printable Version" var="1">
							<cf_button2 
								mode		= "icon"
								type		= "Print"
								title       = "#lt_text#" 
								id          = "Print"					
								imageheight		= "20px"
								imagewidth		= "20px"
								printTitle	= "##printTitle"
								printContent = ".clsPrintContent"
								printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
						</td>	
										
					</tr>
					</table>			
				</td>	
					
				<!--- check global access for the mission --->
										
				</tr>
				
				</table>
				
				</cfoutput>
									
			</td>
		</tr>
		
		<cfinclude template="FundingExecutionScript.cfm">	
			
		<tr><td valign="top" class="clsPrintContent">
		
		<cf_divscroll overflowy="scroll" id="content" style="height:99%">	
												
				<cfinclude template="FundingExecutionBox.cfm">						
						
			</cf_divscroll>	 
			
			</td>
			</tr>
	
	</table>

</td></tr>

</table>
  
<script>
	parent.Prosis.busy('no')
</script>	
