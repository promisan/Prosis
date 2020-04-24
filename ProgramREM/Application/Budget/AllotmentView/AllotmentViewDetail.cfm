
<cfparam name="URL.Portal"  default="0">
<!--- option to filter on a fund here --->
<cfparam name="URL.Period"  default="FY10">
<cfparam name="URL.Mode"    default="Budget">
<cfparam name="url.filter"  default="all">

<!--- 27/12/2009 provision to correct the item master if the item master
from some reason does no longer exist, take the default itemmaster for that object 
this will also properly correct the item master for OICT, as we will remove
the item master that were added temp for the OICT-M usage class --->

<cfquery name="Update" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	UPDATE   ProgramAllotmentRequest
	SET      ItemMaster = O.ItemMaster
	FROM     ProgramAllotmentRequest A, Purchase.dbo.ItemMasterObject O
	WHERE    A.ObjectCode = O.ObjectCode 
	AND      A.ItemMaster NOT IN (SELECT Code 
	                              FROM   Purchase.dbo.ItemMaster
								  WHERE  Code = A.ItemMaster) 
</cfquery>

<cfquery name="DisplayPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_Period 
	WHERE  Period = '#URL.Period#'
</cfquery>
 
<cfquery name="EditionSelect" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	 SELECT E.*, 
		       R.Description as VersionName
		FROM   Ref_AllotmentEdition E INNER JOIN 
		       Ref_AllotmentVersion R ON  R.Code = E.Version
			   LEFT OUTER JOIN Ref_Period P ON P.Period = E.Period
		WHERE  E.Mission     = '#URL.Mission#'		
		
		AND    (
		
		         <!--- select the periods to show for entry --->
		         E.Period IN (
		                    SELECT Period 
		                    FROM   Ref_Period 
							<!--- expiration date of period lies after the start date of the planning period --->
						    WHERE  DateExpiration  >= '#DisplayPeriod.DateEffective#'
							<cfif DisplayPeriod.isPlanningPeriodExpiry neq "">
							<!--- expiration date of period lies before the scope of the planning period --->
							AND    DateExpiration <= '#DisplayPeriod.isPlanningPeriodExpiry#'						
							</cfif>		
							
							<!--- period is NOT a planning period itself 
							Hanno 10/10/2012 : this needs review, better to drop the isPlanning period and
							let is be defined on the dbo.missionperiod level if a period is a plan period.
							The below prevents for example in OICT to show B14-15 to be recorded under
							plan period B12-13, which is not the intention hence it was removed.
														
							AND    Period NOT IN (SELECT PP.Period 
						                      FROM   Organization.dbo.Ref_MissionPeriod PP, 
											         Ref_Period RE
											  WHERE  PP.Mission   = '#url.mission#'
											  AND    PP.Period    = Re.Period
											  AND    PP.Period   != '#URL.Period#'
											  AND    Re.IsPlanningPeriod = 1)														  
											  
											  --->
											  					
							) 
												
				OR 
				
				   E.Period is NULL
			   )
			   
		AND    EditionClass  = 'Budget'				
			
		ORDER BY P.DateEffective,R.ListingOrder, R.Description
	  
</cfquery>

<cfif url.edition neq "">

	<cfquery name="check" dbtype="query">
		SELECT * 
		FROM   EditionSelect
		WHERE  EditionId = #url.edition#
	</cfquery>
	
	<cfif check.recordcount eq "0">
	 <cfset url.edition = editionselect.editionid>
	</cfif>

</cfif>

<cfquery name="Edition" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#URL.Edition#' 
</cfquery>

<cfparam name="URL.Version"         default="#Edition.Version#">
<cfparam name="URL.programgroup"    default="all">

<cfquery name="Parameter" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>
 
<cfparam name="CLIENT.Sort" default="OrgUnit">

<cfquery name="Setting" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ParameterMission
	  WHERE  Mission = '#Edition.Mission#' 
 </cfquery>
	 
<cfif Setting.defaultAllotmentView eq "1">
	<cfparam name="CLIENT.Lay"  default="Components">
<cfelse>
	<cfparam name="CLIENT.Lay"  default="Program">
</cfif>

<cfparam name="URL.Lay"     default="">

<cfif URL.Lay eq "">
	<cfset URL.Lay = CLIENT.Lay>
<cfelse>
    <cfset client.Lay = URL.Lay>	
</cfif>

<cfparam name="URL.view"    default="All">
<cfparam name="URL.mode"    default="PRG">

<cfif url.mode eq "STA">
   <cfset url.view = "ALL">
   <cfset url.lay  = "Components">   
</cfif>

<cfparam name="URL.ID1"     default="Tree">

<cfquery name="Period" 
	datasource="AppsOrganization">
		SELECT *
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#url.mission#'
		AND    Period  = '#url.period#'			
</cfquery>

<cfparam name="URL.Mandate" default="#Period.MandateNo#">
<cfparam name="URL.Unit"    default="0">

<cfparam name="URL.ProgramGroup" default="all">
<cfset URL.ProgramGroup = TRIM("#URL.ProgramGroup#")>
	
 <cfquery name="Mandate" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM Ref_Mandate
	   WHERE Mission = '#URL.Mission#'
   </cfquery>
     
 <cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT OrgUnit, HierarchyRootUnit
	   FROM   Organization
	   WHERE  MandateNo = '#URL.Mandate#'
		 AND  Mission   = '#URL.Mission#'		 
		<cfif url.id1 neq "Tree">
		 AND  OrgUnit  = '#URL.ID1#' 
		</cfif>
		ORDER BY HierarchyCode
  </cfquery>
   
  <cfquery name="Root" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     #CLIENT.LanPrefix#Organization
	   WHERE    OrgUnitCode = '#Org.HierarchyRootUnit#'
	   AND      MandateNo   = '#URL.Mandate#'
	   AND      Mission     = '#URL.Mission#'
  </cfquery>   
        
  <!--- define program component status --->
          
   <cfset FileNo = round(Rand()*100)>
      
   <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ProgramGroup#FileNo#">
   <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Progress#FileNo#">	
  	 
   <!--- ------------------------------------------------ --->
   <!--- get user Authorization level for adding programs --->
   <!--- ------------------------------------------------ --->
      
   <cfinvoke component="Service.AccessGlobal"
	     Method="global"
    	 Role="AdminProgram"
	     ReturnVariable="ManagerAccess">	
		
    <cfinclude template="AllotmentViewPrepare.cfm">
	
	<cfparam name="url.fund" default="">
 	 		
    <CFIF ManagerAccess eq "EDIT" OR ManagerAccess eq "ALL">
	  <cfset BudgetCond = "">
    <cfelse>
	  <cfset BudgetCond = "AND Pe.OrgUnit in (SELECT OrgUnit FROM Organization.dbo.OrganizationAuthorization O WHERE O.UserAccount = '#SESSION.acc#' AND O.OrgUnit is not NULL AND O.Role = 'BudgetManager')">
	</cfif>  
		
   <!--- get user Authorization level for adding BUDGET information --->
   <!--- Check manager access first --->
   
       
   <cfif ManagerAccess eq "EDIT" or ManagerAccess eq "ALL">
      
       <cfset BudgetAccess = "Manager">
	   
   <cfelse>        
	        
	   <cfinvoke component="Service.Access"
			Method  = "Organization"
			Mission = "#url.mission#"
			OrgUnit = "#Org.OrgUnit#"
			Period  = "#URL.Period#"
			Role    =  "BudgetManager"
			ReturnVariable="BudgetAccess">	
															
	   		<!--- If no Manager access, check for officer access --->
			
			<cfif BudgetAccess neq "NONE">
			
		       <cfset BudgetAccess = "Manager">
			   
			<cfelse>   			
			
			   <cfinvoke component="Service.Access"
					Method="Organization"
					Mission = "#url.mission#"
					OrgUnit="#Org.OrgUnit#"
					Period="#URL.Period#"
					Role="BudgetOfficer"
					ReturnVariable="BudgetAccess">	
				
				<!--- adjusted to 7/10/2014 --->													
				<cfif BudgetAccess eq "ALL">
					<cfset BudgetAccess = "Manager">
				<cfelseif BudgetAccess eq "EDIT">
					<cfset BudgetAccess = "Officer">	
				</cfif>
				
			</cfif>	
						
	</cfif>		
	
	
<CFIF BudgetAccess EQ "NONE">
	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		  
	  <tr>
	    <td height="60" align="center" class="labelit">		
		 <cf_tl id="No correct access was granted to you as a user for this unit and period" class="message">. <cf_tl id="Please contact your administrator">.
		</td>
		
	</tr>
	</table>	

<cfelse>

<table width="98%" align="center">

<tr class="line">
    <td>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
				
		<td class="labellarge" style="height:45px">
		
		<cfoutput>
	
			<cfif url.portal eq "0">
				#DisplayPeriod.Description# :	
				<b>			
				<cfif Len(Root.OrgUnitName) gt 40>&nbsp;#Left(Root.OrgUnitName, 40)#...  
				<cfelse>&nbsp;#Root.OrgUnitName#</cfif>		
				#Root.OrgUnitCode#					 
				<input type="hidden" name="orgunit" id="orgunit" value="#url.id1#">
															
			</cfif>
			
		</cfoutput>		
			
	    </td>
			
		<td style="width:3px">
		
			<input type="hidden" id="SystemFunctionId" value="<cfoutput>#url.systemfunctionid#</cfoutput>">
		
		</td>
	  		
		   <cfoutput query="DisplayPeriod">		   
		   												
				<td class="labelit" style="height:35">	
								
					<cf_tl id="Edition">:					  						
					<select id="editionselect" name="editionselect" style="width:200px"				    
					    class="regularxl"
						onChange="Prosis.busy('yes');reloadBudget(document.getElementById('page').value)">
						<cfloop query="editionselect">
						
							<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
								Method         = "budget"
								Mission        = "#URL.Mission#"
								Period         = "#URL.Period#"	
								EditionId      = "'#editionID#'"  
								Scope          = "some"
								Role           = "'BudgetManager','BudgetOfficer'"
								ReturnVariable = "ListingAccess">	
													
							<cfif ListingAccess neq "NONE">	  							
						
							<option value="#editionid#" <cfif editionid eq url.edition>selected</cfif>>#Description# <cfif period neq "">(#Period#)</cfif></option>
							
							</cfif>
							
						</cfloop>
					</select>
									
				</td>	
				
				<td>
				
				<cf_tl id="Filter">:					  						
					<select id="filterselect" name="filterselect" style="width:290px"				    
					    class="regularxl"
						onChange="Prosis.busy('yes');reloadBudget(document.getElementById('page').value)">
												
							<option value="all"><cf_tl id="All Requirements incl. transfers"></option>
							<option value="due" <cfif url.filter eq "due">selected</cfif>><cf_tl id="Requirements due for release"></option>
							<option value="transfer" <cfif url.filter eq "transfer">selected</cfif>><cf_tl id="Transferred amounts"></option>
							<option value="fund" <cfif url.filter eq "fund">selected</cfif>><cf_tl id="Enabled for funds covered by edition"></option>
							
					</select>
				
				</td>			
							
				<cfif Edition.Status neq "1">
					<td>	
					<img height="13" 
					     align="absmiddle" 
						 width="13" 
						 src="#SESSION.root#/images/key.gif" 
						 alt="Edition Locked for data entry" border="0">
					</td>	 
				</cfif>
							
		   </cfoutput>
		   
	   <td align="right" width="15%" style="padding-left:4px">
	   
	        <cfif url.id1 neq "tree">
	   		
				<cf_tl id="Excel" var="vExport">
				
				<cfinvoke component="Service.Analysis.CrossTab"  
					  method         = "ShowInquiry"
					  buttonName     = "Excel"
					  buttonText     = "#vExport#"
					  buttonClass    = "button10s"
					  buttonIcon     = "sqltable.gif"							  
					  reportPath     = "ProgramREM\Application\Budget\AllotmentView\"
					  SQLtemplate    = "AllotmentViewDetailExcel.cfm"
					  queryString    = "period=#URL.period#&edition=#URL.edition#&id1=#url.id1#"
					  dataSource     = "appsQuery" 
					  module         = "Program"
					  reportName     = "Facttable: Budget Preparation"
					  table1Name     = "Summary by Object Code"
					  table2Name     = "Requirement Details"
					  data           = "1"
					  filter         = ""
					  ajax           = "0"
					  olap           = "0" 
					  excel          = "1"> 						
					   
			</cfif>
				   
	   </td>	   
	   
	   </tr>
	   </table>
				
	</td>
		
	<td align="right">	
	
		<input type="hidden" name="page" id="page" value="1">
				
    </TD>
	 
</tr>
  
<tr><td class="line" colspan="2"></td></tr>
       	
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

       <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Allotment#FileNo#">	
	   <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	
	   
	   <!--- generate a program base table which included global and parent programs to be shown --->
	   
	   <!--- 30/7/2010 changed to show a better structure in this view as well --->
	   
	   <cfif url.view eq "ALL">
		   <cfset full = "0">			  
	   <cfelse>
	   	   <cfset full = "1">			  
	   </cfif>	   	     
	   	   
	   <!--- generate a base set of programs for this selection to be potentially shown ---> 
	   <cfinclude template="../../Tools/GenerateProgramPeriod.cfm"> 
	   
	   <cfparam name="url.filter" default="all">
	      
	   <!--- generate a consolidated table in the screen --->	  	  				
	 	   
		<cfquery name="ProgramSet" 
         datasource="AppsQuery" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
		 		 		 
         SELECT Pe.*, 
		        LockEntry,			
								
				(
				
					<!--- identify if budget needs review --->
				
					SELECT TOP 1 EE.EntryMethod
		   			FROM    Program.dbo.ProgramAllotmentDetail EPAD, 
					        Program.dbo.Ref_AllotmentEdition EE
					WHERE   EPAD.Status = '0'  <!--- pending clearance --->
						AND EE.EditionId      = EPAD.EditionId
						AND EE.EditionId      = '#URL.Edition#' 		
						AND EE.EditionClass   = 'Budget' 		
						AND EPAD.Period       = PE.Period		
						AND EPAD.ProgramCode  = PE.ProgramCode						
						AND EPAD.TransactionType = 'Standard'
						AND EPAD.Amount <> 0)
						
						<!--- removed hanno 14/1/2013
					   #PreserveSingleQuotes(BudgetCond)# 
					   --->
				   
				   as EntryMethod,			
				  		
		        <cfloop query="Resource">Allot.Ceiling_#CurrentRow#, Allot.Resource_#CurrentRow#,</cfloop>Allot.Total
				
		 INTO    dbo.tmp#SESSION.acc#Allotment#FileNo#
				 
		 FROM    #PER# Pe LEFT OUTER JOIN 				 
				 <!--- prepared table with financial data --->				 
                 #SESSION.acc#AllotmentProgramViewTmp_#FileNo# Allot ON Pe.ProgramCode = Allot.ProgramCode	
				 	       				
	     WHERE   Pe.RecordStatus != '9' 
		 
		 <cfif EditionCheck.ProgramClass neq "">				
		 AND     (Pe.ProgramClass = '#EditionCheck.ProgramClass#' or Pe.ProgramClass = 'Program')
		 </cfif>	
		 
		 <!--- we filter program codes if the funding of the program matches the funding of the edition or if
		 the fund of the program is NOT enforced --->
		 
		 <cfif url.filter eq "fund">
		 
		 AND     Pe.ProgramCode IN (
		 
					 SELECT 	PA.ProgramCode
					 FROM       Program.dbo.ProgramAllotment AS PA INNER JOIN
			                    Program.dbo.Ref_AllotmentEditionFund AS R ON PA.EditionId = R.EditionId AND PA.Fund = R.Fund 
					 WHERE      PA.Period    = '#URL.Period#'
					 AND        PA.EditionId = '#url.edition#'		
					 AND        PA.FundEnforce = 1	
					 
					 UNION ALL
					 
					 SELECT     ProgramCode
					 FROM       Program.dbo.ProgramAllotmentDetail AS PAD INNER JOIN
			                    Program.dbo.Ref_AllotmentEditionFund AS R ON PAD.EditionId = R.EditionId AND PAD.Fund = R.Fund
					 WHERE      PAD.Period = '#URL.Period#'
					 AND        PAD.EditionId = '#url.edition#'
										
										 
					 UNION ALL
					 
					 SELECT    ProgramCode
					 FROM      Program.dbo.Program
					 WHERE     ProgramClass = 'Program'

					 )
		 
		 </cfif>	
		 
	     AND     Pe.Period        = '#URL.Period#'		
		 
		 <cfif url.find neq "">
		 
		 AND   (Pe.Reference LIKE '%#url.find#%' 
		        OR Pe.ProgramCode LIKE '%#url.find#%' 
				OR Pe.ProgramName LIKE '%#url.find#%')
		 
		 </cfif>
		 
		 
		 <cfif URL.ProgramGroup neq "All" and URL.ProgramGroup neq "">	
			AND       Pe.ProgramCode IN (SELECT ProgramCode 
			                            FROM   Program.dbo.ProgramGroup 
										WHERE  ProgramGroup = '#URL.ProgramGroup#'
										AND    ProgramCode  = Pe.ProgramCode) 
			</cfif>
			
			
		 	   			
		 <cfif url.mode eq "PRG">		
				 
		   <cfif url.id1 neq "Tree">
		  		   
		    AND  OrgUnit IN (SELECT OrgUnit 
			                 FROM   Organization.dbo.Organization
							 WHERE  Mission = '#URL.Mission#'  
							 AND    HierarchyCode >= '#HStart#' 
							 AND    HierarchyCode < '#HEnd#'							
							) 
							
			 AND  Pe.ProgramCode IN (SELECT ProgramCode 
							        FROM    Program.dbo.Program 
									WHERE   ProgramCode = Pe.ProgramCode
									AND     (ProgramAllotment = 1 or ProgramScope IN ('Parent','Global')))				
		   </cfif>	
		 
		 <cfelseif url.mode eq "STA">		 		
												 
				<cfif getAdministrator("*") eq "0">
			    <!--- limit access to relevant programs only --->
                AND (
				    Pe.OrgUnit IN (SELECT OrgUnit 
				                   FROM   Organization.dbo.OrganizationAuthorization 
								   WHERE  UserAccount = '#SESSION.acc#'
								   AND    Role IN ('BudgetOfficer','BudgetManager')
								   AND    OrgUnit is not NULL
								  )
					 OR
					 Pe.Mission IN (SELECT Mission 
				                    FROM   Organization.dbo.OrganizationAuthorization 
								    WHERE  UserAccount = '#SESSION.acc#'
								    AND    Mission = Pe.Mission
								    AND    Role IN ('BudgetOfficer','BudgetManager')
								    AND    OrgUnit is NULL
								  )		
					 OR
					 Pe.ProgramCode IN (SELECT ProgramCode 
					                    FROM   Program.dbo.ProgramAccessAuthorization			  	   
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    ProgramCode = Pe.ProgramCode
										AND    Role IN ('BudgetOfficer','BudgetManager')
								     )		
					)		
				</cfif> 				
				
				<!--- projects pending for clearance --->
				
				AND Pe.ProgramCode IN (
					
						SELECT ProgramCode
			   			FROM    Program.dbo.ProgramAllotmentDetail EPAD, 
						        Program.dbo.Ref_AllotmentEdition EE
						WHERE   EPAD.Status IN ('0')  <!--- pending clearance --->
							AND EE.EditionId         = EPAD.EditionId
							AND EE.EditionId         = '#URL.Edition#' 		
							AND EE.EditionClass      = 'Budget' 		
							AND EPAD.Period          = PE.Period		
							AND EPAD.ProgramCode     = PE.ProgramCode						
							AND EPAD.TransactionType = 'Standard'
							AND EPAD.Amount <> 0
						)		
		 
		    <cfif url.id1 eq "0">							
						
			AND Pe.ProgramCode IN (SELECT DISTINCT EP.ProgramCode
				   			       FROM   Program.dbo.ProgramAllotmentDetail EPAD, 
					                      Program.dbo.Ref_AllotmentEdition EE, 
							              Program.dbo.ProgramPeriod EP
							       WHERE  EPAD.Status     IN ('0') <!--- pending clearance --->
							       AND    EE.EditionId    = EPAD.EditionId
							       AND    EE.EditionId    = '#URL.Edition#' 		
							       AND    EE.EditionClass = 'Budget' 		
							       AND    EP.Period       = '#URL.Period#'		
								   AND    EP.ProgramCode  = Pe.ProgramCode
							       AND    EP.ProgramCode  = EPAD.ProgramCode		
								   AND    EPAD.TransactionType = 'Standard'					
							       AND    EPAD.Amount <> 0
								   
					                      <!--- #PreserveSingleQuotes(BudgetCond)# --->
							)	
					 
			 </cfif>				
		 
		 </cfif>
		 
		 ORDER BY ListingOrder    
		 		 
        </cfquery>	
				
		<cfquery name="qProgramSet" 
         datasource="AppsQuery" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
         	SELECT * 
			FROM   dbo.tmp#SESSION.acc#Allotment#FileNo#
		</cfquery>     
		
				
		       
		<!---	<cfoutput>KK:#cfquery.executionTime#<br></cfoutput>	--->
		
		<!--- --------added 30/7/2010--------- --->		
		<!--- roll-up for the program / global --->
		<!--- -------------------------------- --->
		
		<cfif url.view neq "ALL">
				
			<!--- aggregrate the global program code --->
									
			    <cfquery name="Base" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   left(ProgramHierarchy,7) as Hierarchy, 
				         <cfloop query="Resource">
						 sum(Ceiling_#currentrow#)  as Ceiling_#currentrow#,
			             sum(Resource_#currentRow#) as Resource_#currentrow#, 
			             </cfloop>
						 sum(Total) as Total	
				FROM     userQuery.dbo.tmp#SESSION.acc#Allotment#FileNo#
				WHERE    Class != 'Next'	 
				GROUP BY left(ProgramHierarchy,7)
				</cfquery>										
					
			<cfloop query="Base">
					
				<cfquery name="Program" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE userQuery.dbo.tmp#SESSION.acc#Allotment#FileNo#
					SET    <cfloop query="Resource">
					       ceiling_#currentrow#  = '#evaluate('Base.Ceiling_#currentrow#')#',
					       resource_#currentrow# = '#evaluate('Base.Resource_#currentrow#')#',
					       </cfloop>
					       Total = '#Total#'			
					WHERE  ProgramHierarchy = '#Hierarchy#'	 
				</cfquery>						
							
			</cfloop>
										
		</cfif>			
					
		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">	
				
		<cfset cond = "AND O.OrgUnit = '#URL.ID1#'">	
						
		<tr>
			<td>		
															
			<cfif url.mode eq "PRG">														
				<cfinclude template="AllotmentViewOrganization.cfm">	
			<cfelseif url.mode eq "Main">															
				<cfinclude template="AllotmentViewProgram.cfm">		
			<cfelse>													
				<cfinclude template="AllotmentViewStatus.cfm">			
			</cfif>		
			
			</td>
		</tr>			
		
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentProgramView_#FileNo#"> 
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentProgramViewTmp_#FileNo#"> 		
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentOrgView#FileNo#"> 	
		<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#AllotmentOrgViewTmp#FileNo#"> 							
		<cf_droptable dbName="AppsQuery" tblName="tmp#SESSION.acc#Allotment#FileNo#">			
			
</table>

</td></tr>

</table>
	
</cfif>

<cfset AjaxOnLoad("doHighlight")>

<script>
	parent.Prosis.busy('no')
	Prosis.busy('no')
</script>
