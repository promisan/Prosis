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
	
	<cf_UItree
		id="root"
		title="<span style='font-size:16px;color:gray;'>1111111</span>"	
		root="no"
		expand="Yes">
				   
		   <cfoutput query="MissionList" group="MissionType">
		   
		   	  <cf_UItreeitem value="#missiontype#"
			        display="<span style='font-size:19px;font-weight:bold' class='labelit'>#Missiontype#</span>"						
					parent="root"										
			        expand="Yes">			        
		   	
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
					     role             = "'ProcReqInquiry','BudgetOfficer','BudgetManager'" 		  
					     returnvariable   = "access">	
					
					 <cfif access eq "GRANTED" and Check.MissionStatus eq "0">
					 
					 		 <cf_UItreeitem value="#mission#"
						        display="<span style='font-size:17px;padding-top:5px;font-weight:bold' class='labelit'>#Mis#</span>"						
								parent="#missiontype#"										
						        expand="#exp#">					
											
							<cfoutput group="PlanningPeriod">
							
								<cfset pla = PlanningPeriod>
							
								<cfset p = "<span style='font-size:16px;padding-top:4px' class='labelit'>#PlanningPeriod#</span>"> 
								
								<cf_UItreeitem value="#Mission#_#PlanningPeriod#"
							        display="#p#"						
									parent="#mission#"										
							        expand="no">																	
								
									<cfoutput group="EditionId">
									
										<cfinvoke component   = "Service.Access"  
									     method           = "RoleAccess" 
									     mission          = "#Mis#"
									     role             = "'ProcReqInquiry','BudgetOfficer','BudgetManager'" 		
										 parameter        = "#editionid#"  
									     returnvariable   = "access">		
										 
										<cfif access eq "GRANTED">
										
											<cfif executionperiod eq "">
											  <cfset title = "<span style='font-size:13px' class='labelit'>#EditionDescription#*</span>">							
											<cfelse>
											  <cfset title = "<span style='font-size:13px' class='labelit'>#EditionDescription#</span>">										
											</cfif>
											
											<cf_UItreeitem value="#EditionId#"
										        display="#title#"						
												parent="#Mission#_#pla#"	
												target="content"
												href="FundingExecutionView.cfm?systemfunctionid=#url.idmenu#&mission=#mis#&planningperiod=#pla#&period=#executionperiod#&editionid=#editionid#&View=all"											
										        expand="no">									
																																			
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
											   
											   		<cf_UItreeitem value="#EditionId#_#Fund#"
												        display="<span class='labelit'>#Fund#</span>"						
														parent="#EditionId#"	
														target="content"
														href="FundingExecutionView.cfm?systemfunctionid=#url.idmenu#&mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#editionid#&View=Fund&Value=#fund#"											
												        expand="no">	
											   
											   		<cf_UItreeitem value="#EditionId#_#Fund#_doc"
												        display="<span class='labelit'>Documents</span>"						
														parent="#EditionId#_#fund#"	
														target="content"
														href="FundingExecutionDocument.cfm?systemfunctionid=#url.idmenu#&mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#editionid#&View=Fund&Value=#fund#"											
												        expand="no">											
											   
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
												  
												  <cf_UItreeitem value="#Edi#_#Code#"
												        display="<span class='labelit'>#description#</span>"						
														parent="#edi#"	
														target="content"
														href="FundingExecutionView.cfm?systemfunctionid=#url.idmenu#&mission=#mis#&planningperiod=#pla#&period=#per#&editionid=#edi#&View=group&Value=#code#"											
												        expand="no">										   
																							   
										  	      </cfloop>											   
											
												</cfif>
												
											</cfif>
								
								   </cfoutput>					
											
							</cfoutput>	
							
						<cfif getAdministrator("*") eq "1">
						
							<cf_UItreeitem value="audit_#mission#"
							        display="<span class='labelit'>Audit views</span>"						
									parent="#mission#"																		
							        expand="no">	
									
							<cf_UItreeitem value="Post_#mission#"
							        display="<span class='labelit'>Invalid Postings</span>"						
									parent="audit_#mission#"	
									target="content"
									href="FundingExecutionAudit.cfm?systemfunctionid=#url.idmenu#&mission=#mission#"											
							        expand="no">							
														
						</cfif>			
							
					</cfif>
								
			 </cfoutput>	
		 
		 </cfoutput>		
	
	</cf_UItree>
	 
 </cfif>
 
 </cfif>	
	
	   
