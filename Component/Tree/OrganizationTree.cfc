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
<cfcomponent>

<cfproperty name="OrganizationTree" type="string" displayname="Organization Tree">
 
 <!---
  
<cffunction name="getNodes" access="remote" returntype="array">

   <cfargument name="path"       type="String" required="false" default=""/>
   <cfargument name="value"      type="String" required="true" default=""/>
   
   <!--- mission mandate to pass to the href positions --->
   <cfargument name="mission"    type="String" required="true" default=""/>
   <cfargument name="mandateno"  type="String" required="true" default=""/>
   
   <cfargument name="template"   type="String" required="true" default=""/>
   <cfargument name="id"         type="String" required="true" default=""/>
   <cfargument name="treelabel"  type="String" required="true" default=""/>
   
   <!--- mission/mandate to retrieve unit tree information, default the pass --->
   <cfargument name="treemis"    type="String" required="true" default="#mission#"/>
   <cfargument name="treeman"    type="String" required="true" default="#mandateno#"/>
  
   <!--- if filter is passed as ID4 to the link string --->
   <cfargument name="filter"    type="String" required="false" default=""/>
   
   <!--- values for level field
            : parent show only parent level of the tree 
			: full show all nodes, no matter the role limitation
   --->
   <cfargument name="level"         type="String"   required="false" default="">
   <cfargument name="selectedunit"  type="numeric"  required="false" default="0">
   <cfargument name="querystring"   type="string"   required="false" default="none">
   <cfargument name="selectiondate" type="string"   required="false" default="">
      
   <cfif querystring eq "none">
	   <cfset querystring = "">
   </cfif>        
   
   <cfset querystring = replace(querystring,"!","=","ALL")> 
   
   <!--- set up return array --->
      
      <cfset var result= arrayNew(1)/>
      <cfset var s =""/>	
	  
	  <cfset vInit = GetTickCount()> 
					
	  <cfquery name="Vendor" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   Ref_ParameterMission
		  WHERE  TreeVendor = '#Mission#'				  		 			 
	  </cfquery>  		
	  
	   <cfquery name="Entity" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   Ref_Mission
		  WHERE  Mission = '#Mission#'					 
	  </cfquery>  	
	  
	   <cfset PreviousTick = vInit>
	  <cf_TickLog Init = "#vInit#" memo="#selectiondate#" step=0>	
	  
	  <cfif selectiondate neq "">
	  
		<CF_DateConvert Value="#selectiondate#">
		<cfset sdte = dateValue>
	  				
	  </cfif>		
	  	  
	  <cfif value eq "">
	  
	  	    <cfif id eq "DON">
			
				<cfset s = structNew()/>
				
				<cf_tl id="Summary" var="sum">
				
				<cfset s.value     = "all">
				<cfset s.img       = ""> 									
				<cfset s.display   = "<span class='labelmedium'>#sum#</span>">					
			    <cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=summary&period=#filter#&#querystring#">
				<cfset s.target    = "right">
				<cfset s.leafnode  = "Yes">
				<cfset arrayAppend(result,s)/>
											
				<cfset s = structNew()/>				
				<cf_tl id="Tranche Inquiry" var="tranche">
				
				<cfset s.value     = "tranche">
				<cfset s.display   = "<span class='labelmedium'>#Tranche#</span>">					
			    <cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=tranche&period=#filter#&#querystring#">
				<cfset s.leafnode  = "Yes">
				<cfset s.target    = "right">
				<cfset arrayAppend(result,s)/>									
							
			</cfif>
	  	  	   		
		    <cfset s = structNew()/>
            <cfset s.value     = "tree">
			<cfset s.img       = ""> 
						
			<cfif id eq "PRG">
				<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">
			</cfif>
			
			<cfif id is "MAN">
			
				<cfquery name="Mandate" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
					  FROM   Ref_Mandate
					  WHERE  Mission   = '#Mission#'
					  AND    mandateNo = '#MandateNo#'
				</cfquery>
			
				<cfset s.display   = "<span style='height:60px;font-size:18px' class='labellarge'><font size='2' color='808080'>Expiry:</font> <font>#dateformat(mandate.dateexpiration,CLIENT.DateFormatShow)#">	 
			    <cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">				
			
			<cfelse>

				<!--- static tree --->
				<cfset s.display   = "<span class='labelmedium'>#treelabel#</span>">	
				
				<cfif id eq "DON">
				
				  <cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=contribution&period=#filter#&#querystring#">
			  	  <cfset s.target    = "right">
				
				</cfif>
							
			</cfif>			
						
			<cfif id is "ORG" or id is "DON" or id is "ATT" or id is "FIN" or id is "CUS" or id is "MAN" or id is "PRG">
				<cfset s.expand    = "true">								
						
			</cfif>
			
			<cfif id is "MAN" and Mandate.dateExpiration lt now()>
			
				<cfset s.expand = "false">
			
			</cfif>
			
            <cfset arrayAppend(result,s)/>
						
	  <cfelse>		
	  
	  	<cfset l = len(value)>
        <cfset val = mid(value,5,l-4)>
		
		<!--- staffing table listing only --->
		
		<cfif (level neq "Full" and (id eq "ORG" or id eq "DON" or id eq "ATT" or id eq "PRG" or id eq "CUS") OR vendor.recordcount gte 1)>
				  
				<cfset accessList = "">
				
				<!--- select list of items --->
				
				<cfif SESSION.isAdministrator eq "Yes" or findNoCase(mission,SESSION.isLocalAdministrator)>
				
					<cf_TickLog Init = "#vInit#" step=1>
				
					<cfquery name="Access" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT *
						  FROM   Organization O  
					   	  WHERE  O.Mission     = '#Mission#'
						  AND    O.MandateNo   = '#MandateNo#'
						  
						  <!--- 1/7/2012 : not sure what this is about 
						  
						  <cfif Vendor.recordcount gt "0">
							  
							    AND    O.OrgUnit IN (SELECT Pe.OrgUnit 
								                     FROM   Program.dbo.ProgramPeriod Pe 
													 WHERE  Pe.OrgUnit = O.OrgUnit)					  
						  </cfif>
						  
						  --->
						  
						  <cfif value eq "tree">
						  	  	AND (ParentOrgUnit IS NULL or ParentOrgUnit = '')
						  <cfelse>
						  	  	AND ParentOrgUnit = '#val#'			
						  </cfif>
						  
						  <cfif selectiondate neq "">
						  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
					  	  </cfif>							  
						  							
					</cfquery>
									
				<cfelse>
				
					<!--- check global --->

					<cf_TickLog Init = "#vInit#" step=3>
					
					<cfquery name="MissionCheck" 
					  datasource="AppsOrganization" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT DISTINCT Mission 
						FROM   Organization.dbo.OrganizationAuthorization OA  <!--- no link needed this is done below --->
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    Mission = '#mission#'
						
							<cfif id is "ORG">
							AND    Role IN ('HRPosition', 'HRLoaner', 'HRLocator','HROfficer','HRAssistant','HRInquiry')							
							<cfelseif id is "ATT">
							AND    Role IN ('Timekeeper', 'HROfficer')
							<cfelseif id is "DON">
						    AND    Role IN ('ContributionOfficer','ContributionManager') 															
							<cfelseif id is "PRG">
						    AND    Role IN ('ProgressOfficer','BudgetOfficer','BudgetManager','ProgramOfficer','ProgramManager','ProgramAuditor') 									
							<cfelseif id eq "CUS">
						    AND    Role IN ('WorkOrderProcessor')  		
							</cfif>
							AND    (OrgUnit = '0' OR OrgUnit is NULL)	

					</cfquery>							

					<cf_TickLog Init = "#vInit#" step=4>					
					
					<cfif MissionCheck.recordcount gte "1">						
					
						<cf_TickLog Init = "#vInit#" step=5>		
								
						<cfquery name="Access" 
						  datasource="AppsOrganization" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						      SELECT *
							  FROM   Organization O
						   	  WHERE  O.Mission     = '#Mission#'
							  AND    O.MandateNo   = '#MandateNo#'
							  
							  <!--- removed for FMS as it was hiding too much for buyer 							  
							  <cfif Vendor.recordcount gt "0">								  
							  AND    O.OrgUnit IN (SELECT Pe.OrgUnit 
								                   FROM   Program.dbo.ProgramPeriod Pe 
									    		   WHERE  Pe.OrgUnit = O.OrgUnit)					  
							  </cfif>							  
							  --->
							  
							   <cfif selectiondate neq "">
							  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
						  	  </cfif>	
								
	   					  </cfquery>						
															
				    <cfelse>
								
						<cfquery name="Access" 
						  datasource="AppsOrganization" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						      SELECT DISTINCT A.OrgUnit, 
							         O.OrgUnitCode, 
									 O.ParentOrgUnit, 
									 O.Mission, 
									 O.MandateNo
							  FROM   OrganizationAuthorization A, 
							         Organization O
						   	  WHERE  A.UserAccount = '#SESSION.acc#' 
							  AND    A.Mission     = '#Mission#'
							  AND    O.OrgUnit     = A.OrgUnit
							  AND    O.Mission     = '#Mission#'
							  
								  <cfif id eq "ORG">
								  AND    A.Role IN ('HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry') 								  
								  <cfelseif id is "ATT">
								  AND    Role IN ('Timekeeper', 'HROfficer')
								  <cfelseif id is "DON">
								  AND    Role IN ('ContributionOfficer','ContributionManager') 
								  <cfelseif id eq "PRG">
								  AND    A.Role IN ('ProgressOfficer','BudgetOfficer','BudgetManager','ProgramOfficer','ProgramManager','ProgramAuditor')  					  								  								  								 
								  <cfelseif id eq "CUS">
								  AND    A.Role IN ('WorkOrderProcessor')  					
								  </cfif>		
								  
							 <cfif selectiondate neq "">
							  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
						  	  </cfif>		  						  
								  
							</cfquery>							
						
						</cfif>
						
				</cfif>		
								
				<cf_TickLog Init = "#vInit#" step=9>			
				<cfset i = 0>
				<cfset j = 0>
				
				<!--- 8/8/2013 get also the parents as otherwise the tree is orphaned --->
												
				<cfloop query="Access">
					
					<cfset i = i + 1>	
					
					    <cfif accessList eq "">
							<cfset accessList = "'#OrgUnit#'">
						<cfelse>
							<cfset accessList = "#accessList#,'#OrgUnit#'">
					    </cfif>								
									    
					    <cfquery name="Check" 
					      datasource="AppsOrganization" 
					      username="#SESSION.login#" 
					      password="#SESSION.dbpw#">
					      SELECT  DISTINCT OrgUnitCode, 
						          ParentOrgUnit, 
								  Mission, 
								  MandateNo
						  FROM    Organization
					   	  WHERE   OrgUnit = '#OrgUnit#' 						  
					    </cfquery>				    
											
						<cfset Parent = Check.ParentOrgUnit>
						<cfset Miss   = Check.Mission>
						<cfset Mand   = Check.MandateNo>
						
						<cfloop condition="Parent neq ''">
						   	  
						   <cfset j = j + 1>
						      	  
						   <cfquery name="LevelUp" 
							datasource="AppsOrganization" 
							maxrows=1 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					          SELECT OrgUnit, ParentOrgUnit 
					          FROM   Organization
					          WHERE  OrgUnitCode = '#Parent#'
							  AND    Mission     = '#Miss#'
							  AND    MandateNo   = '#Mand#' 
							  
							  <cfif selectiondate neq "">
							  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
						  	  </cfif>	
							  
					  	   </cfquery>									
										
						   <cfif LevelUp.recordcount eq "1">
						   
						   	   <cfif accessList eq "">
									<cfset accessList = "'#LevelUp.OrgUnit#'">
							   <cfelse>
							        <cfset accessList = "#accessList#,'#LevelUp.OrgUnit#'">
							   </cfif>
													       		
							</cfif>
						   <cfif Parent neq LevelUp.ParentOrgUnit>
						   		<cfset Parent = LevelUp.ParentOrgUnit>
						   <cfelse>
						   		<cfset Parent = "">
						   </cfif>	
						   
						</cfloop>
								
				</cfloop>			
														
		</cfif>		
		
        <!--- if arguments.value is empty the tree is being built for the first time --->
	
		<cfquery name="Node" 
	     datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT TreeOrder, 
		      	OrgUnitName, 
			  	OrgUnitNameShort, 
			  	OrgUnit, 
				( SELECT DateExpiration
				  FROM   Ref_Mandate
				  WHERE  Mission   = P.Mission
				  AND    MandateNo = P.MandateNo
				 ) as MandateExpiration,				 
				 
				 ( SELECT count(*)
				   FROM   OrganizationName
				   WHERE  OrgUnit = P.OrgUnit				 
				   -- AND    LanguageCode = '#client.languageId#'
				  ) as hasLabels, 
				
				<cfif id eq "DON">
				
				  (SELECT  count(*) 
   				   FROM    Program.dbo.Contribution C INNER JOIN Organization.dbo.Organization CO ON C.OrgUnitDonor = CO.OrgUnit		
				   WHERE 	CO.Mission     = '#TreeMis#'
		 		   AND  	CO.MandateNo   = '#TreeMan#'	  		   
				   AND      CO.HierarchyCode LIKE P.HierarchyCode+'%'	
				   AND      C.Mission = '#mission#'
				   			   
				   <cfif filter neq "">				   
				   AND     EXISTS (SELECT 'X' 
				                   FROM   Program.dbo.ContributionLine CL,
								          Program.dbo.ContributionLinePeriod CLP
								   WHERE  CLP.ContributionLineId = CL.ContributionLineId 
								   AND    CL.ContributionId      = C.ContributionId
								   AND    Period = '#filter#') 
				   </cfif>
				   
				   AND     C.ActionStatus <> '9') as Counted, 
				 
				<cfelse>
				
				   0 as Counted,
				   
				</cfif>		
						
			  	OrgUnitCode,
				OrgUnitClass,
			  	Mission,
				MandateNo,
				DateEffective,
				DateExpiration,
			  	ParentOrgUnit,
				HierarchyCode 
	     
		 FROM 	#Client.LanPrefix#Organization P
		 
	   	 WHERE 	Mission     = '#TreeMis#'
		  AND  	MandateNo   = '#TreeMan#'
		  
		  <cfif value is "tree">
		      <cfif level eq "Parent">
			  <!--- we show also the units defined as autonomouse 11/7/2013 --->
			  AND  	(ParentOrgUnit is NULL OR ParentOrgUnit = '' or Autonomous = 1) 	
			  <cfelse>
			  AND  	(ParentOrgUnit is NULL OR ParentOrgUnit = '') 			  
			  </cfif>
		  <cfelse>
		     AND  	ParentOrgUnit = '#val#'   
		  </cfif>		  
		 	 		  
		 <cfif (level neq "Full" and (id eq "ORG" or id eq "DON" or id eq "PRG" or id eq "ATT" or id eq "CUS") OR vendor.recordcount gte 1)>
		  		    			 
			 	<cfif accesslist neq "" and (id eq "ORG" or id eq "CUS" or id eq "ATT" or id eq "DON" or id eq "PRG")>				
						AND OrgUnit IN (#PreserveSingleQuotes(AccessList)#)	
				</cfif>						 
				 
		</cfif>		
		
		<cfif selectiondate neq "">
		  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#		 
		</cfif>			
		 
		 ORDER BY TreeOrder, OrgUnitName, HierarchyCode  
	   </cfquery>	
	   	   
	   <cfquery name="Select" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   * 			
			 FROM     Organization O
			 WHERE    OrgUnit = '#selectedunit#'			 							
	    </cfquery>	

    	<cf_TickLog Init = "#vInit#" step=13>
			
	   <cfset expandhierarchy = select.hierarchycode>	
   			           
       <cfoutput query="Node">	   
		   	   
	   		<cfset orglabel = orgunitname>
			<cfset orgshort = orgunitnameshort>
						
			<cfif hasLabels gte "1" and selectiondate neq "">
			
				<cfquery name="Log" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">					 
				     SELECT   TOP 1 * 
				     FROM     OrganizationName
					 WHERE    OrgUnit      = '#OrgUnit#'
					 AND      LanguageCode = '#client.languageid#'
					 AND      DateExpiration >= #sdte# 				 
					 ORDER BY DateExpiration DESC							 					
			    </cfquery>	
				
				<cfif Log.recordcount gte "1">
				
					<cfset orglabel = Log.orgunitname>
					<cfset orgshort = Log.orgunitnameshort>
				
				</cfif>			
			
			</cfif>
				   
		   	<cfquery name="Detail" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT   TOP 1 OrgUnit 
			     FROM     Organization
				 WHERE    Mission    = '#treemis#'
				 AND      MandateNo  = '#treeman#'
				 AND      ParentOrgUnit = '#orgUnitCode#'					 	
		    </cfquery>	
			
			<cfquery name="Class" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT   * 
				 FROM     Ref_OrgUnitClass
				 WHERE    OrgUnitClass = '#OrgUnitClass#'								
		    </cfquery>	
           
            <cfset s = structNew()/>
            <cfset s.value     = "node#orgunitcode#">
			
			<cfif class.ListingIcon eq "">				
				<cfset s.img       = "">
			<cfelse>
				<cfset s.img       = "#SESSION.root#/#class.listingicon#">
			</cfif>
			
			<cfset s.parent    = "#mission#"> 
			<cfif Detail.recordcount eq "0" or Level eq "Parent"> 
				<cfset s.leafnode=true/>
			</cfif>
			
			<!--- default --->
			<cfset cl = "black">	
			
			<cfif entity.missionstatus eq "0">
			    <cfif selectiondate neq "">
				   <cfif DateEffective lte sdte and DateExpiration gte sdte>
				       <cfset cl = "black">
				   <cfelse>
				   	   <cfset cl = "red">
				   </cfif>				
				</cfif>						
			</cfif>
			
			<cfif id eq "PRG" or id eq "CUS">
					
			    <cfif orgshort eq "">

					<cfif len(orgLabel) gt "29">
						<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orglabel#'>#left(orgLabel,29)#..</span>">
					<cfelse>
						<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orgLabel#'>#orgLabel#</span>">
					</cfif>
														
				<cfelse>
				
					<cfif len(orgshort) gt "29">
						<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orgLabel#'>#left(orgshort,29)#..</span>">
					<cfelse>
						<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orgLabel#'>#orgshort#</span>">
					</cfif>
											  
				</cfif>	
				
			<cfelseif id eq "ATT">
						
				<cfif len(orgLabel) gt "40">
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;' class='labelit' title='#orgLabel#'>#left(orgLabel,40)#..</span>">
				<cfelse>
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;' class='labelit' title='#orgLabel#'>#orgLabel#</span>">
				</cfif>				
			
			<cfelseif id eq "DON">
						
				<cfif len(orgLabel) gt "34">
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;' class='labelit' title='#orgLabel#'>#left(orgLabel,34)#.. <cfif counted gt 0>[#counted#]</cfif></span>">
				<cfelse>
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;' class='labelit' title='#orgLabel#'>#orgLabel# <cfif counted gt 0>[#counted#]</cfif></span>">
				</cfif>
				
			<cfelse>
			
				<cfif len(orgLabel) gt "34">
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orgLabel#'>#left(orgLabel,34)#..</span>">
				<cfelse>
					<cfset s.display   = "<span style='padding-top:3px;padding-bottom:3px;color: #cl#;' class='labelit' title='#orgLabel#'>#orgLabel#</span>">
				</cfif>				
			
			</cfif>
						
			<cfset arg = replace(querystring,"|","&","ALL")>
			<cfset arg = replace(arg,"!","=","ALL")>			
			
			<!--- check hierarchy --->
									
			<cfif len(hierarchycode) gte len(expandhierarchy) or 
			    select.mission neq mission or 
				select.mandateno neq mandateno>

					<cfset s.expand    = "false">
			
			<cfelse>
			
				<cfset sel = left(expandhierarchy,len(hierarchycode))>
								
					<cfif sel eq hierarchycode>
						<cfset s.expand    = "true">
					<cfelse>
						<cfset s.expand    = "false">
					</cfif>		
			
			</cfif>
			
			<cfif id eq "DEF">			  
				<cfset s.href      = "javascript:ptoken.navigate('#template#?#arg#&org=#orgunit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#','listresult')">				
			<cfelseif id eq "ATT">
				<cfset s.href      = "#template#?id=#id#&ID0=#OrgUnit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">	
				<cfif SESSION.isAdministrator eq "Yes" or findNoCase(mission,SESSION.isLocalAdministrator)>
				    <cfset s.expand    = "false">	
				<cfelseif access.recordcount lte "20">
				    <cfset s.expand    = "true">	
				<cfelse>
					<cfset s.expand    = "false">	
				</cfif>
			<cfelseif id eq "ORG">
				<cfset s.href      = "javascript:ptoken.open('#template#?id=#id#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#','right')">
				<cfset s.target    = "right">	
			<cfelseif id eq "CUS">
				<cfset s.href      = "javascript:ptoken.navigate('#template#?id=#id#&org=#orgunit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#&#arg#','listcustomer')">
			<cfelseif id eq "DON">
				<cfset s.href      = "#template#?#arg#&mode=DON&ID1=#OrgUnit#&ID2=#mission#&period=#filter##querystring#">
				<cfset s.target    = "right">		
			<cfelseif id eq "PRG">
				<cfset s.href      = "#template#?mode=PRG&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">		
			<cfelseif id eq "PRA">
				<cfset s.href      = "javascript:ptoken.navigate('#template#?mode=PRG&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#','right')">					
			<cfelse>
				<cfset s.href      = "#template#?id=#id#&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">	
			</cfif>
			
			<cfset s.title     = "aaaaa">			
						
			 <cfif value eq "Tree">			 
				 <cfif Node.recordcount lte "3">				
				 	  <cfset s.expand    = "true">
				 </cfif>	   
		    </cfif>
												
            <cfset arrayAppend(result,s)/>			
			
       </cfoutput>
	   
	   </cfif>	   
	  	   
   <cfreturn result/>     
   
</cffunction>

--->

<cffunction name="getNodesV2" access="remote"  returnFormat="json" output="false" secureJSON = "yes" verifyClient = "yes">

		<cfargument name="path"       type="String" required="false" default=""/>
		<cfargument name="value"      type="String" required="true" default=""/>

<!--- mission mandate to pass to the href positions --->
		<cfargument name="mission"    type="String" required="true" default=""/>
		<cfargument name="mandateno"  type="String" required="true" default=""/>

		<cfargument name="template"   type="String" required="true" default=""/>
		<cfargument name="id"         type="String" required="true" default=""/>
		<cfargument name="treelabel"  type="String" required="true" default=""/>

<!--- mission/mandate to retrieve unit tree information, default the pass --->
		<cfargument name="treemis"    type="String" required="true" default="#mission#"/>
		<cfargument name="treeman"    type="String" required="true" default="#mandateno#"/>

<!--- if filter is passed as ID4 to the link string --->
		<cfargument name="filter"    type="String" required="false" default=""/>
		
		<!--- values for level field
		         : parent show only parent level of the tree
		         : full show all nodes, no matter the role limitation
		--->
		<cfargument name="level"         type="String"   required="false" default="">
		<cfargument name="selectedunit"  type="numeric"  required="false" default="0">
		<cfargument name="querystring"   type="string"   required="false" default="none">
		<cfargument name="selectiondate" type="string"   required="false" default="">

		<cfif querystring eq "none">
			<cfset querystring = "">
		</cfif>

		<cfset querystring = replace(querystring,"!","=","ALL")>

		<!--- set up return array --->

		<cfset var result= arrayNew(1)/>
		<cfset var s =""/>

		<cfset vInit = GetTickCount()>

		<cfquery name="Vendor"
				datasource="AppsPurchase"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  TreeVendor = '#Mission#'
		</cfquery>

		<cfquery name="Entity"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Mission
			WHERE  Mission = '#Mission#'
		</cfquery>

		<cfset PreviousTick = vInit>
		<cf_TickLog Init = "#vInit#" memo="#selectiondate#" step=0>

		<cfif selectiondate neq "">

			<CF_DateConvert Value="#selectiondate#">
			<cfset sdte = dateValue>

		</cfif>

		<cfif value eq "">

			<cfif id eq "DON">

				<cfset s = structNew()/>

				<cf_tl id="Summary" var="sum">

				<cfset s.value     = "all">
				<cfset s.img       = "">
				<cfset s.display   = "<span class='labelmedium'>#sum#</span>">
				<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=summary&period=#filter#&#querystring#">
				<cfset s.target    = "right">
				<cfset s.leafnode  = "Yes">
				<cfset arrayAppend(result,s)/>

				<cfset s = structNew()/>
				<cf_tl id="Tranche Inquiry" var="tranche">

				<cfset s.value     = "tranche">
				<cfset s.display   = "<span class='labelmedium'>#Tranche#</span>">
				<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=tranche&period=#filter#&#querystring#">
				<cfset s.leafnode  = "Yes">
				<cfset s.target    = "right">
				<cfset arrayAppend(result,s)/>

			</cfif>

			<cfset s = structNew()/>
			<cfset s.value     = "tree">
			<cfset s.img       = "">

			<cfif id eq "PRG">
				<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">
			</cfif>

			<cfif id is "MAN">

				<cfquery name="Mandate"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_Mandate
						WHERE  Mission   = '#Mission#'
						AND    mandateNo = '#MandateNo#'
				</cfquery>

				<cfset s.display   = "<span style='height:30px;font-size:18px' class='labellarge'>Expiry:#dateformat(mandate.dateexpiration,CLIENT.DateFormatShow)#</span>">
				<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
				<cfset s.target    = "right">

			<cfelse>

				<!--- static tree --->
				<cfset s.display   = "<span class='labelmedium' style='font-size:18px;font-weight:bold;padding-bottom:3px'>#treelabel#</span>">

				<cfif id eq "DON">

					<cfset s.href      = "#template#?id=#id#&ID2=#mission#&ID3=#mandateno#&mode=contribution&period=#filter#&#querystring#">
					<cfset s.target    = "right">

				</cfif>

			</cfif>

			<cfif id is "ORG" or id is "DON" or id is "ATT" or id is "FIN" or id is "CUS" or id is "MAN" or id is "PRG">
				<cfset s.expand    = "true">

			</cfif>

			<cfif id is "MAN" and Mandate.dateExpiration lt now()>
				<cfset s.expand = "false">
			</cfif>

			<cfset arrayAppend(result,s)/>

		<cfelse>

			<cfset l   = len(value)>
			<cfset val = mid(value,5,l-4)>

<!--- staffing table listing only --->

			<cfif (level neq "Full" and (id eq "ORG" or id eq "DON" or id eq "ATT" or id eq "PRG" or id eq "CUS") OR vendor.recordcount gte 1)>

				<cfset accessList = "">

<!--- select list of items --->

				<cfif SESSION.isAdministrator eq "Yes" or findNoCase(mission,SESSION.isLocalAdministrator)>

					<cf_TickLog Init = "#vInit#" step=1>

					<cfquery name="Access"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization O
						WHERE  O.Mission     = '#Mission#'
					AND    O.MandateNo   = '#MandateNo#'
						
						<!--- 1/7/2012 : not sure what this is about
						
						<cfif Vendor.recordcount gt "0">
						
						      AND    O.OrgUnit IN (SELECT Pe.OrgUnit
						                           FROM   Program.dbo.ProgramPeriod Pe
						                           WHERE  Pe.OrgUnit = O.OrgUnit)
						</cfif>
						
						--->

						<cfif value eq "tree">
							AND (ParentOrgUnit IS NULL or ParentOrgUnit = '')
						<cfelse>
							AND ParentOrgUnit = '#val#'
						</cfif>

						<cfif selectiondate neq "">
							AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
						</cfif>

					</cfquery>

				<cfelse>

				<!--- check global --->

					<cf_TickLog Init = "#vInit#" step=3>

					<cfquery name="MissionCheck"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
						SELECT DISTINCT Mission
						FROM   Organization.dbo.OrganizationAuthorization OA  <!--- no link needed this is done below --->
						WHERE  UserAccount = '#SESSION.acc#'
					AND    Mission = '#mission#'

						<cfif id is "ORG">
							AND    Role IN ('HRPosition', 'HRLoaner', 'HRLocator','HROfficer','HRAssistant','HRInquiry')
							<cfelseif id is "ATT">
							AND    Role IN ('Timekeeper', 'HROfficer')
							<cfelseif id is "DON">
							AND    Role IN ('ContributionOfficer','ContributionManager')
							<cfelseif id is "PRG">
							AND    Role IN ('ProgressOfficer','BudgetOfficer','BudgetManager','ProgramOfficer','ProgramManager','ProgramAuditor')
							<cfelseif id eq "CUS">
							AND    Role IN ('WorkOrderProcessor')
						</cfif>
						AND    (OrgUnit = '0' OR OrgUnit is NULL)

					</cfquery>

					<cf_TickLog Init = "#vInit#" step=4>

					<cfif MissionCheck.recordcount gte "1">

						<cf_TickLog Init = "#vInit#" step=5>

						<cfquery name="Access"
								datasource="AppsOrganization"
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
								SELECT *
								FROM   Organization O
								WHERE  O.Mission     = '#Mission#'
								AND    O.MandateNo   = '#MandateNo#'
									
									<!--- removed for FMS as it was hiding too much for buyer
									<cfif Vendor.recordcount gt "0">
									AND    O.OrgUnit IN (SELECT Pe.OrgUnit
									                     FROM   Program.dbo.ProgramPeriod Pe
									                     WHERE  Pe.OrgUnit = O.OrgUnit)
									</cfif>
									--->
	
								<cfif selectiondate neq "">
									AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
								</cfif>
						</cfquery>

					<cfelse>

						<cfquery name="Access"
								datasource="AppsOrganization"
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
							SELECT DISTINCT A.OrgUnit,
									O.OrgUnitCode,
									O.ParentOrgUnit,
									O.Mission,
									O.MandateNo
							FROM   OrganizationAuthorization A INNER JOIN Organization O ON O.OrgUnit     = A.OrgUnit
							WHERE  A.UserAccount = '#SESSION.acc#'
							AND    A.Mission     = '#Mission#'							
							AND    O.Mission     = '#Mission#'
	
								<cfif id eq "ORG">
									AND    A.Role IN ('HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry')
									<cfelseif id is "ATT">
									AND    Role IN ('Timekeeper', 'HROfficer')
									<cfelseif id is "DON">
									AND    Role IN ('ContributionOfficer','ContributionManager')
									<cfelseif id eq "PRG">
									AND    A.Role IN ('ProgressOfficer','BudgetOfficer','BudgetManager','ProgramOfficer','ProgramManager','ProgramAuditor')
									<cfelseif id eq "CUS">
									AND    A.Role IN ('WorkOrderProcessor')
								</cfif>
	
								<cfif selectiondate neq "">
									AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
								</cfif>

						</cfquery>

					</cfif>

				</cfif>

				<cf_TickLog Init = "#vInit#" step=9>
				<cfset i = 0>
				<cfset j = 0>

				<!--- 8/8/2013 get also the parents as otherwise the tree is orphaned --->

				<cfloop query="Access">

					<cfset i = i + 1>

					<cfif accessList eq "">
						<cfset accessList = "'#OrgUnit#'">
					<cfelse>
						<cfset accessList = "#accessList#,'#OrgUnit#'">
					</cfif>

					<cfquery name="Check"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
						SELECT  DISTINCT OrgUnitCode,
						ParentOrgUnit,
						Mission,
						MandateNo
						FROM    Organization
						WHERE   OrgUnit = '#OrgUnit#'
					</cfquery>

					<cfset Parent = Check.ParentOrgUnit>
					<cfset Miss   = Check.Mission>
					<cfset Mand   = Check.MandateNo>

					<cfloop condition="Parent neq ''">

						<cfset j = j + 1>

						<cfquery name="LevelUp"
								datasource="AppsOrganization"
								maxrows=1
								username="#SESSION.login#"
								password="#SESSION.dbpw#">
								SELECT OrgUnit, ParentOrgUnit
								FROM   Organization
								WHERE  OrgUnitCode = '#Parent#'
								AND    Mission     = '#Miss#'
								AND    MandateNo   = '#Mand#'	
								<cfif selectiondate neq "">
								AND    DateEffective <= #sdte# AND DateExpiration >= #sdte#
								</cfif>								
						</cfquery>

						<cfif LevelUp.recordcount eq "1">

							<cfif accessList eq "">
								<cfset accessList = "'#LevelUp.OrgUnit#'">
							<cfelse>
								<cfset accessList = "#accessList#,'#LevelUp.OrgUnit#'">
							</cfif>

						</cfif>
						<cfif Parent neq LevelUp.ParentOrgUnit>
							<cfset Parent = LevelUp.ParentOrgUnit>
						<cfelse>
							<cfset Parent = "">
						</cfif>

					</cfloop>

				</cfloop>

			</cfif>

			<!--- if arguments.value is empty the tree is being built for the first time --->

			<cfquery name="Node"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					
						SELECT TreeOrder,
							   OrgUnitName,
							   OrgUnitNameShort,
							   OrgUnit,
							   
								(   SELECT DateExpiration
									FROM   Ref_Mandate
									WHERE  Mission   = P.Mission
									AND    MandateNo = P.MandateNo ) as MandateExpiration,				
								( SELECT count(*) FROM   OrganizationName WHERE  OrgUnit = P.OrgUnit
								-- AND    LanguageCode = '#client.languageId#'
								) as hasLabels,
		
						<cfif id eq "DON">
		
							(SELECT  count(*)
							FROM    Program.dbo.Contribution C INNER JOIN Organization.dbo.Organization CO ON C.OrgUnitDonor = CO.OrgUnit
							WHERE 	CO.Mission     = '#TreeMis#'
							AND  	CO.MandateNo   = '#TreeMan#'
							AND     CO.HierarchyCode LIKE P.HierarchyCode+'%'
							AND     C.Mission = '#mission#'
		
							<cfif filter neq "">
								AND     EXISTS (SELECT 'X'
								FROM   Program.dbo.ContributionLine CL,
								Program.dbo.ContributionLinePeriod CLP
								WHERE  CLP.ContributionLineId = CL.ContributionLineId
								AND    CL.ContributionId      = C.ContributionId
								AND    Period = '#filter#')
							</cfif>
		
							AND     C.ActionStatus <> '9') as Counted,
		
						<cfelse>
		
							0 as Counted,
		
						</cfif>
		
						OrgUnitCode,
						OrgUnitClass,
						Mission,
						MandateNo,
						DateEffective,
						DateExpiration,
						ParentOrgUnit,
						HierarchyCode

				FROM 	#Client.LanPrefix#Organization P

				WHERE 	Mission     = '#TreeMis#'
				AND  	MandateNo   = '#TreeMan#'
	
					<cfif value is "tree">
						<cfif level eq "Parent">
							<!--- we show also the units defined as autonomouse 11/7/2013 --->
							AND  	(ParentOrgUnit is NULL OR ParentOrgUnit = '' or Autonomous = 1)
						<cfelse>
							AND  	(ParentOrgUnit is NULL OR ParentOrgUnit = '')
						</cfif>
					<cfelse>
						AND  	ParentOrgUnit = '#val#'
					</cfif>
	
					<cfif (level neq "Full" and (id eq "ORG" or id eq "DON" or id eq "PRG" or id eq "ATT" or id eq "CUS") OR vendor.recordcount gte 1)>
	
						<cfif accesslist neq "" and (id eq "ORG" or id eq "CUS" or id eq "ATT" or id eq "DON" or id eq "PRG")>
							AND OrgUnit IN (#PreserveSingleQuotes(AccessList)#)
						</cfif>
	
					</cfif>

				<cfif selectiondate neq "">
					AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
				</cfif>
				
				ORDER BY TreeOrder, OrgUnitName, HierarchyCode
			</cfquery>

			<cfquery name="Select"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Organization O
					WHERE    OrgUnit = '#selectedunit#'
			</cfquery>

			<cf_TickLog Init = "#vInit#" step=13>

			<cfset expandhierarchy = select.hierarchycode>

			<cfoutput query="Node">
			
				<cfset reduce = len(hierarchycode)-2> 
				<cfif reduce gt "0">
					<cfset reduce = reduce/3>
				</cfif>
				
				<cfif reduce eq "0">
					<cfset orglabel = orgunitnameshort>
				<cfelse>
					<cfset orglabel = orgunitname>
				</cfif>
				<cfset orgshort = orgunitnameshort>
				<cfset orgsize  = "#15-reduce#">

				<cfif hasLabels gte "1" and selectiondate neq "">

					<cfquery name="Log"
							datasource="AppsOrganization"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT   TOP 1 *
							FROM     OrganizationName
							WHERE    OrgUnit      = '#OrgUnit#'
							AND      LanguageCode = '#client.languageid#'
							AND      DateExpiration >= #sdte#
							ORDER BY DateExpiration DESC
					</cfquery>

					<cfif Log.recordcount gte "1">

					    <cfif parent eq "">
						<cfset orgshort = Log.orgunitnameshort>
						<cfelse>
						<cfset orglabel = Log.orgunitname>
						</cfif>
						<cfset orgshort = Log.orgunitnameshort>

					</cfif>

				</cfif>

				<cfquery name="Detail"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT   TOP 1 OrgUnit
						FROM     Organization
						WHERE    Mission    = '#treemis#'
						AND      MandateNo  = '#treeman#'
						AND      ParentOrgUnit = '#orgUnitCode#'
				</cfquery>

				<cfquery name="Class"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_OrgUnitClass
						WHERE    OrgUnitClass = '#OrgUnitClass#'
				</cfquery>

				<cfset s = structNew()/>
				<cfset s.value     = "node#orgunitcode#">

				<cfif class.ListingIcon eq "">
					<cfset s.img       = "">
				<cfelse>
					<cfset s.img       = "#SESSION.root#/#class.listingicon#">
				</cfif>

				<cfset s.parent    = "#mission#">
				<cfif Detail.recordcount eq "0" or Level eq "Parent">
					<cfset s.leafnode=true/>
				</cfif>

				<!--- default --->
				<cfset cl = "transparent">

				<cfif entity.missionstatus eq "0">
					<cfif selectiondate neq "">
						<cfif DateEffective lte sdte and DateExpiration gte sdte>
							<cfset cl = "transparent">
						<cfelse>
							<cfset cl = "red">
						</cfif>
					</cfif>
				</cfif>

				<cfif id eq "PRG" or id eq "CUS">

					<cfif orgshort eq "">

						<cfif len(orgLabel) gt "29">
							<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orglabel#'>#left(orgLabel,29)#..</span>">
						<cfelse>
							<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orgLabel#'>#orgLabel#</span>">
						</cfif>

					<cfelse>

						<cfif len(orgshort) gt "29">
							<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orgLabel#'>#left(orgshort,29)#..</span>">
						<cfelse>
							<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orgLabel#'>#orgshort#</span>">
						</cfif>

					</cfif>

				<cfelseif id eq "ATT">

					<cfif len(orgLabel) gt "40">
						<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orgLabel#'>#left(orgLabel,40)#..</span>">
					<cfelse>
						<cfset s.display   = "<span style='font-size:#orgsize#;' title='#orgLabel#'>#orgLabel#</span>">
					</cfif>

				<cfelseif id eq "DON">

					<cfif len(orgLabel) gt "34">
						<cfset s.display   = "<span style='font-size:#orgsize#;color: #cl#' title='#orgLabel#'>#left(orgLabel,34)#.. <cfif counted gt 0>[#counted#]</cfif></span>">
					<cfelse>
						<cfset s.display   = "<span style='font-size:#orgsize#;color: #cl#' title='#orgLabel#'>#orgLabel# <cfif counted gt 0>[#counted#]</cfif></span>">
					</cfif>

				<cfelse>

					<cfif len(orgLabel) gt "42">
						<cfset s.display   = "<span style='font-size:#orgsize#;' class='fixlength' title='#orgLabel#'>#left(orgLabel,38)# ...</span>">
					<cfelse>
						<cfset s.display   = "<span style='font-size:#orgsize#;' class='fixlength' title='#orgLabel#'>#orgLabel#</span>">
					</cfif>

				</cfif>

				<cfset arg = replace(querystring,"|","&","ALL")>
				<cfset arg = replace(arg,"!","=","ALL")>

				<!--- check hierarchy --->

				<cfif len(hierarchycode) gte len(expandhierarchy) or select.mission neq mission or	select.mandateno neq mandateno>

					<cfset s.expand    = "false">

				<cfelse>

					<cfset sel = left(expandhierarchy,len(hierarchycode))>

					<cfif sel eq hierarchycode>
						<cfset s.expand    = "true">
					<cfelse>
						<cfset s.expand    = "false">
					</cfif>

				</cfif>

				<cfif id eq "DEF">
					<cfset s.href      = "javascript:ptoken.navigate('#template#?#arg#&org=#orgunit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#','listresult')">
					<cfelseif id eq "ATT">
					<cfset s.href      = "#template#?id=#id#&ID0=#OrgUnit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
					<cfset s.target    = "right">
					<cfif SESSION.isAdministrator eq "Yes" or findNoCase(mission,SESSION.isLocalAdministrator)>
						<cfset s.expand    = "false">
						<cfelseif access.recordcount lte "20">
						<cfset s.expand    = "true">
					<cfelse>
						<cfset s.expand    = "false">
					</cfif>
					<cfelseif id eq "ORG">
					<cfset s.href      = "#template#?id=#id#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
					<cfset s.target    = "right">
					<cfelseif id eq "CUS">
					<cfset s.href      = "javascript:ptoken.navigate('#template#?id=#id#&org=#orgunit#&ID1=#OrgUnitCode#&ID2=#mission#&ID3=#mandateno#&id4=#filter#&#arg#','listcustomer')">
					<cfelseif id eq "DON">
					<cfset s.href      = "#template#?#arg#&mode=DON&ID1=#OrgUnit#&ID2=#mission#&period=#filter##querystring#">
					<cfset s.target    = "right">
					<cfelseif id eq "PRG">
					<cfset s.href      = "#template#?mode=PRG&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
					<cfset s.target    = "right">
					<cfelseif id eq "PRA">
					<cfset s.href      = "javascript:ptoken.navigate('#template#?mode=PRG&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#','right')">
				<cfelse>
					<cfset s.href      = "#template#?id=#id#&ID1=#OrgUnit#&ID2=#mission#&ID3=#mandateno#&id4=#filter#">
					<cfset s.target    = "right">
				</cfif>

				<cfset s.title     = "aaaaa">

				<cfif value eq "Tree">
					<cfif Node.recordcount lte "3">
						<cfset s.expand    = "true">
					</cfif>
				</cfif>

				<cfset arrayAppend(result,s)/>

			</cfoutput>

		</cfif>

		<cfscript>
			threadName = "ws_msg_" & createUUID();
			treenodes = result;

			msg = SerializeJSON(treenodes);
		</cfscript>
		<cfreturn msg>

	</cffunction>

</cfcomponent>
