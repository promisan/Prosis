<!--- seect all editions which are used to match against an execution period for each mission --->

 <cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		<!--- main edition --->	
		
		SELECT  DISTINCT 
		        M.Mission,
			    M.Period AS ExecutionPeriod, 
			    M.PlanningPeriod, 		       
			    R.EditionId, 
			    R.Version, 
			    R.Description as EditionDescription,
			    S.MissionType
			   
		FROM    Ref_AllotmentEdition AS R 
			    INNER JOIN Organization.dbo.Ref_MissionPeriod AS M ON R.Mission = M.Mission AND R.Period = M.Period AND R.EditionId = M.EditionId 
			    INNER JOIN Organization.dbo.Ref_Mission S ON R.Mission = S.Mission 
				
		AND     R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE MissionStatus = '0')		


        <!--- alternate edition --->			   
		UNION   ALL
		
		SELECT  DISTINCT 
		        M.Mission,
			    M.Period AS ExecutionPeriod, 
			    M.PlanningPeriod, 		       
			    R.EditionId, 
			    R.Version, 
			    R.Description as EditionDescription,
			    S.MissionType
			   
		FROM    Ref_AllotmentEdition AS R 
			    INNER JOIN Organization.dbo.Ref_MissionPeriod AS M ON R.Mission = M.Mission AND R.Period = M.Period AND R.EditionId = M.EditionIdAlternate 
			    INNER JOIN Organization.dbo.Ref_Mission S ON R.Mission = S.Mission 
				
		AND     R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE MissionStatus = '0')		
			   
		UNION   ALL	   
		
		SELECT  DISTINCT M.Mission, 		      
			    NULL AS ExecutionPeriod, 
			    M.PlanningPeriod, 
			    R.EditionId, 
			    R.Version, 
			    R.Description,
			    S.MissionType
			   
		FROM    Ref_AllotmentEdition AS R 
			    INNER JOIN Organization.dbo.Ref_MissionPeriod AS M ON R.Mission = M.Mission AND R.EditionId = M.EditionId 
			   	INNER JOIN Organization.dbo.Ref_Mission S ON R.Mission = S.Mission
			   
		WHERE   R.Period IS NULL
		
		AND     R.Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE MissionStatus = '0')
		
		ORDER BY S.MissionType, M.Mission, PlanningPeriod, ExecutionPeriod	
						
						
</cfquery> 

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    OrganizationAuthorization
		WHERE   UserAccount = '#SESSION.acc#'
		AND     Role        IN ('ProcReqInquiry','BudgetOfficer','BudgetManager')	
</cfquery> 

<cfif (missionList.recordcount eq "0" or check.recordcount eq "0") and getAdministrator("*") eq "0">

	<table width="100%">
		<tr><td align="center" height="60" class="labelit"><font color="red">No access was granted (1).</font></td></tr>
	</table>

<cfelse>	
	
<cfquery name="MissionCheck" dbtype="query">
		SELECT DISTINCT Mission 
		FROM MissionList
</cfquery> 			

<cfset go = "0">

<cfoutput query="MissionList" group="Mission">	
		
	<cfquery name="Mission" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Mission
			WHERE  Mission     = '#mission#'		
	</cfquery> 
	
	<cfif Mission.MissionStatus eq "0">
	
		<cfinvoke component = "Service.Access"  
		 method             = "RoleAccess" 		
		 mission            = "#Mission#"   
		 role               = "'ProcReqInquiry','BudgetOfficer','BudgetManager'" 		  
		 returnvariable     = "access">	
		  		 		   
		<cfif Access eq "GRANTED">		   
		   <cfset go = "1">		   
		</cfif>
	 
	</cfif>
		   
</cfoutput>



<!--- no access --->

<cfif go eq "0">

	<table width="100%">
		<tr><td align="center" height="60" class="labelit"><font color="808080">No access granted (2).</font></td></tr>
	</table>

<cfelse>	 

	<cfif missioncheck.recordcount lte "5">
	    <cfset exp = "Yes">
	<cfelse>
		<cfset exp = "No">  
	</cfif>
			
	<cftree name="root"
		   font="calibri"
		   fontsize="11"		
		   bold="No"   
		   format="html"    
		   required="No">  
		   
		   <cfoutput query="MissionList" group="MissionType">
		   
		        <cftreeitem value="#missiontype#"
				        display="<span style='padding-top:3px;padding-bottom:3px;font-size:19px;color: gray;' class='labelmedium'>#Missiontype#</font>"
						parent="root"									
				        expand="yes">		
		   	
			   <cfoutput group="Mission">
			   
			   	    <cfquery name="Check" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_Mission
							WHERE  Mission     = '#mission#'		
					</cfquery>  
				
					<cfset mis = mission>
							
				    <!--- check access for tree --->
							
					<cfinvoke component   = "Service.Access"  
					     method           = "RoleAccess" 
					     mission          = "#Mis#"
					     role             = "'ProcReqInquiry','BudgetOfficer','BudgetManager'  " 		  
					     returnvariable   = "access">	
					
					 <cfif access eq "GRANTED" and Check.MissionStatus eq "0">
					
							<cftreeitem value="#mission#"
						        display="<font face='Calibri' size='4'>#Mis#</font>"
								parent="#missiontype#"																										
						        expand="#exp#">			
					
							<cfoutput group="PlanningPeriod">
							
								<cfset pla = PlanningPeriod>
							
								<cfset p = "<font face='Calibri'>Plan: <font face='Calibri' size='3'>#PlanningPeriod#"> 
												
								<cftreeitem value="#Mission#_#PlanningPeriod#"
							        display  = "#p#"
									parent   = "#Mission#"																						
							        expand   = "No">										
								
									<cfoutput group="EditionId">
									
										<cfinvoke component   = "Service.Access"  
									     method           = "RoleAccess" 
									     mission          = "#Mis#"
									     role             = "'ProcReqInquiry','BudgetOfficer','BudgetManager'" 		
										 parameter        = "#editionid#"  
									     returnvariable   = "access">		
										 
										<cfif access eq "GRANTED">
										
											<cfif executionperiod eq "">
											  <cfset title = "<font face='Calibri' size='2'  color='gray'>#EditionDescription#*">							
											<cfelse>
											  <cfset title = "<font face='Calibri' size='2'  color='gray'>#EditionDescription#">										
											</cfif>
									
											<cftreeitem value="#EditionId#"
									            display="#title#"
									            parent="#Mission#_#pla#"	
												target="content"
												href="FundingExecutionView.cfm?mission=#mis#&planningperiod=#pla#&period=#executionperiod#&editionid=#editionid#&View=all"												           			            
												queryasroot="No"
									            expand="No">	
												
												<!---
												<cftreeitem value="#EditionId#_All"
									            display="<font face='Calibri' size='2' color='black'>All"
									            parent="#EditionId#"						            
												target="content"
												href="FundingExecutionView.cfm?mission=#mis#&planningperiod=#pla#&period=#executionperiod#&editionid=#editionid#&View=all"			
									            queryasroot="No"
									            expand="No">	
												--->
												
												<!---
												<cftreeitem value="#EditionId#_Fund"
									            display="<font face='Calibri' size='3' color='gray'>Fund"
									            parent="#EditionId#"	
												queryasroot="No"
									            expand="No">	
												--->
												
												<cfquery name="Fund" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   *
													FROM    Ref_AllotmentEditionFund
													WHERE   EditionId = '#editionid#'	
												</cfquery> 		
												
												<!--- href="FundingExecutionView.cfm?mission=#mission#&period=#missionperiod#&editionid=#editionid#&View=Fund"	--->
												
											   <cfset per = executionperiod>
									           
											   <cfloop query="Fund">	
											   
											   		<cftreeitem value="#EditionId#_#Fund#"
											            display="<font face='Calibri' size='2' color='black'>#Fund#"
											            parent="#EditionId#"														           			            
														href="FundingExecutionView.cfm?mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#editionid#&View=Fund&Value=#fund#"					           			            									
														target="content"
														queryasroot="No"
											            expand="No">							   		
											  												
													<cftreeitem value="#EditionId#_#Fund#_document"
											            display="<font face='Calibri' size='2' color='black'>Documents"
											            parent="#EditionId#_#Fund#"											
														href="FundingExecutionDocument.cfm?mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#editionid#&View=Fund&Value=#fund#"					           			            
														target="content"
														queryasroot="No"
											            expand="No">																		
											   
											   </cfloop>
											   
											    <cfquery name="Group" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT   DISTINCT R.Code, R.Description, R.ListingOrder
													FROM     ProgramGroup P, Ref_ProgramGroup R
													WHERE    P.ProgramGroup = R.Code								
													AND      ProgramCode IN (SELECT ProgramCode 
													                         FROM   ProgramAllotmentDetail 
																			 WHERE  ProgramCode = P.ProgramCode
																			 AND    Period      = '#pla#'
																			 AND    EditionId = '#editionid#') 
																			    									
													ORDER BY R.Listingorder	
												</cfquery> 		
												
												<cfif Group.recordcount gte "1">						  
												
												<!---
												  <cftreeitem value="#EditionId#_Group"
											            display="<font face='Calibri' size='2' color='gray'>Group"
											            parent="#EditionId#"				           								
														queryasroot="No"
											            expand="Yes">	
														
														--->
													
												  <cfset edi = editionid>
												 								 								
												  <cfloop query="Group">
											   
												   <cftreeitem value="#Edi#_#Code#"
											            display="<font face='Calibri' size='2' color='6688aa'>#description#"
											            parent="#edi#"															
														href="FundingExecutionView.cfm?mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#edi#&View=group&Value=#code#"					           			            
														target="content"
														queryasroot="No"
											            expand="No">	
											   
										  	      </cfloop>
											   
											
												</cfif>
												
											</cfif>
								
								   </cfoutput>					
											
							</cfoutput>	
							
						<cfif getAdministrator("*") eq "1">
						
						<cftreeitem value="audit_#mission#"
						        display="<font face='Calibri' size='2' color='gray'>Audit Views"
								parent="#mission#"													
						        expand="No">		
							
						<cftreeitem value="Post_#mission#"
					    	    display = "<font face='Calibri' size='2' color='red'>Invalid Postings"
								parent  = "audit_#mission#"	
								target  = "content"								
								href    = "FundingExecutionAudit.cfm?mission=#mission#"						          												
						        expand  = "Yes">	
								
						</cfif>			
							
					</cfif>
								
			 </cfoutput>	
		 
		 </cfoutput>		
	
	 </cftree>
	 
 </cfif>
 
 </cfif>	
	
	   
