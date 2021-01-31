
 <cfquery name="getRole" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_AuthorizationRole
		WHERE  Role IN ('ProcReqInquiry','BudgetOfficer')	
		ORDER BY OrgUnitLevel
</cfquery>
		
<cfoutput>
	
		<!--- select programs to show incl. the parent/global programs for this fund --->
		
		<!--- -------------------------------------------- --->
		<!--- ----define programs to show in the view----- --->
		<!--- -------------------------------------------- --->
						
		<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT TOP 1 * 
		        FROM   OrganizationAuthorization
				WHERE  UserAccount    = '#SESSION.acc#'
				AND    Mission        = '#URL.Mission#'
				AND    Role           IN ('ProcReqInquiry','BudgetOfficer','BudgetManager')
				AND    ClassParameter = '#URL.EditionId#'	
				AND    OrgUnit is NULL
		</cfquery>	
					
		<cfquery name="MissionPeriod" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *  
			FROM   Ref_MissionPeriod
			WHERE  Mission = '#url.Mission#'
			AND    Period  = '#url.period#' 
		</cfquery>	
		
		<cfif url.planningperiod neq "">
		    <cfset per = url.planningperiod>
		<cfelse>
			<cfset per = MissionPeriod.PlanningPeriod>
		</cfif>	
		
		<!--- master views of programs to be shown in the execution view --->
		
		<!--- Hanno : I move the GL outside for a issue with DPA 10/10 --->
		
		<cfquery name="getProgramLedger" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT  DISTINCT TL.ProgramCode 
		    FROM    Accounting.dbo.TransactionHeader TH,
			        Accounting.dbo.TransactionLine TL
			 WHERE  TH.Mission         = '#url.mission#'		
			 AND    TH.Journal         = TL.Journal
			 AND    TH.JournalSerialNo = TL.JournalSerialNo										 
			 AND    TL.ProgramPeriod   = '#url.period#'		
			 AND    TH.ActionStatus != '9'
			 AND    TH.RecordStatus != '9'
			 <cfif fund neq "">
			 AND    TL.Fund = '#Fund#'			
		     </cfif>
		</cfquery> 
																				 		
		<cfquery name="Select" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
			SELECT   DISTINCT 
			         P.ProgramCode, 
			         Pe.PeriodParentCode as ParentCode,	
					 
					 ( SELECT ProgramScope
					   FROM   Program Par 
					   WHERE  Par.ProgramCode = Pe.PeriodParentCode
					  ) 
					   as ParentScope
					   
			FROM     ProgramAllotmentDetail AS D INNER JOIN
                     Program AS P ON D.ProgramCode = P.ProgramCode  INNER JOIN
                     ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode AND Pe.Period = '#Per#' 					

			WHERE    Pe.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#URL.Mission#') 
			  AND    D.Period = '#Per#'
			  
			  AND    D.EditionId IN (SELECT EditionId 
			                         FROM   Ref_AllotmentEdition 
									 WHERE  Mission = '#url.mission#'
									 AND   (Period = '#url.period#' or Period is NULL))
			 			   			   			   
			   <cfif fund neq "">
			   AND   D.Fund = '#Fund#'			
			   </cfif>
			   
			   <cfif clan neq "">
			   			  			   
				   <cfif clan eq "Group">
				   				   
				   		   AND P.ProgramCode IN (SELECT ProgramCode 
						                         FROM   ProgramGroup 
												 WHERE  ProgramCode = P.ProgramCode
												 AND    ProgramGroup   = '#clav#')	
										 
										 
				   <cfelse>
				   
						   AND P.ProgramCode IN (SELECT ProgramCode 
				                         FROM ProgramCategory 
										 WHERE ProgramCode = P.ProgramCode
										 AND  ProgramCategory = '#clav#')
				   </cfif>
				   
			   </cfif>	   
			   
			   <cfif Edition.ProgramClass neq "">
				   AND P.ProgramClass = '#Edition.ProgramClass#'
			   </cfif>
			   
			   <cfif url.find neq "">
			   AND   (
			         P.ProgramCode LIKE '%#url.find#%' OR
					 Pe.Reference LIKE '%#url.find#%' OR
					 P.ProgramName LIKE '%#url.find#%'
					 )					 
			   </cfif>
			   <cfif url.unithierarchy neq "">			   
			   AND   Pe.OrgUnit IN (SELECT OrgUnit 
			                        FROM   Organization.dbo.Organization 
									WHERE  Mission     = '#URL.Mission#' 
									AND    MandateNo   = '#man#'
									AND    HierarchyCode LIKE ('#url.unithierarchy#%') 
								   )	
			   </cfif>		
			 
			   
			   <cfif getAdministrator(url.mission) eq "0" and check.recordcount eq "0">
										
				    <cfif getRole.OrgUnitLevel eq "All">	
								
					AND     Pe.OrgUnit IN (SELECT OrgUnit				                   
					                    FROM   Organization.dbo.OrganizationAuthorization A
										WHERE  A.UserAccount    = '#SESSION.acc#'
										AND    A.Mission        = '#URL.Mission#'
										AND    A.Role           IN ('ProcReqInquiry','BudgetOfficer')	
										AND    A.ClassParameter = '#URL.EditionId#'								
									   )		
				
					<cfelse>
																		
					AND     Pe.OrgUnit IN (SELECT OrgUnit 
					                       FROM   Organization.dbo.Organization Org
										   WHERE  Mission   = '#URL.Mission#'
										   AND    MandateNo = '#MissionPeriod.MandateNo#'
										   									   								
								           <!--- take the parent code and include all units under it --->
						
										   AND    HierarchyRootUnit IN (
									
									                    SELECT OrgUnitCode 
									                    FROM   Organization.dbo.OrganizationAuthorization A, Organization.dbo.Organization O
														WHERE  O.OrgUnit        = A.OrgUnit
														AND    O.Mission        = Org.Mission
														AND    O.MandateNo      = Org.MandateNo
														AND    A.UserAccount    = '#SESSION.acc#'
														AND    A.Mission        = '#URL.Mission#'									
														AND    A.ClassParameter = D.EditionId
														AND    A.Role           IN ('ProcReqInquiry','BudgetOfficer')	
														AND    O.MandateNo      = '#man#'
														
													   )	
													   
													   											  
										  )	   	
										   
				  </cfif>				
			   
			  </cfif> 
			   
			  
			GROUP BY P.ProgramCode, Pe.PeriodParentCode
			HAVING  SUM(AmountBase) > 0  
						
			<!--- 7/7/2010 extend it to any requisition or disbursement --->
			

			UNION
			
			SELECT   DISTINCT P.ProgramCode, 
			         Pe.PeriodParentCode as ParentCode,	
					 ( SELECT Par.PeriodParentCode
					   FROM   ProgramPeriod Par 
					   WHERE  Par.ProgramCode = Pe.PeriodParentCode
					   AND    Par.Period = '#Per#'
					  ) as Master
					   
			FROM     Program AS P INNER JOIN
                     ProgramPeriod AS Pe ON P.ProgramCode = Pe.ProgramCode  					

			WHERE    Pe.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#URL.Mission#') 
			   AND   Pe.Period = '#Per#' 
			   
			   <!--- requisitions --->
			   AND  ( 
			   
			   		P.ProgramCode IN   (SELECT  F.ProgramCode 
			                             FROM   Purchase.dbo.RequisitionLine R, 
										        Purchase.dbo.RequisitionLineFunding F
										 WHERE  R.RequisitionNo = F.RequisitionNo
										 AND    R.Mission = '#url.mission#'
										 AND    F.ProgramPeriod  = '#url.period#'
										 AND    F.ProgramCode = P.ProgramCode
										 <cfif fund neq "">
										   AND   F.Fund = '#Fund#'			
									     </cfif>
										 )
										
					<cfif getProgramLedger.recordcount gt "0">						 
			   		OR 										
					P.ProgramCode IN   (#QuotedValueList(getProgramLedger.ProgramCode)#)		
					</cfif>
										 
					OR 					
					
					P.ProgramCode IN   (SELECT  TA.ProgramCode 
			                             FROM   ProgramAllotmentAllocation TA
										 WHERE  TA.ProgramCode = P.ProgramCode
										 AND    TA.Period  = '#url.period#'
										 AND    TA.ProgramCode = P.ProgramCode
										 <cfif fund neq "">
										   AND   TA.Fund = '#Fund#'			
									     </cfif>
										 )												 
					OR 
										
					P.ProgramCode IN   (SELECT  TA.ProgramCode 
			                             FROM   ProgramAllotmentRequest TA
										 WHERE  TA.ProgramCode = P.ProgramCode
										 AND    TA.Period  = '#url.period#'
										 AND    TA.ProgramCode = P.ProgramCode
										 <cfif fund neq "">
										   AND   TA.Fund = '#Fund#'			
									     </cfif>
										 )									 			 
										 
					)					 
				
				 <cfif clan neq "">	
				 
				 	<cfif clan eq "Group">
				   				   
				   		   AND P.ProgramCode IN (SELECT ProgramCode 
						                         FROM   ProgramGroup 
												 WHERE  ProgramCode = P.ProgramCode
												 AND    ProgramGroup   = '#clav#')	
										 
										 
				   <cfelse>
				   
						   AND P.ProgramCode IN (SELECT ProgramCode 
				                         FROM ProgramCategory 
										 WHERE ProgramCode = P.ProgramCode
										 AND  ProgramCategory = '#clav#')
				   </cfif>	
				
			
			   </cfif>
			   
			    <cfif Edition.ProgramClass neq "">				
				   AND P.ProgramClass = '#Edition.ProgramClass#'
			   </cfif>
			   
			   <cfif url.find neq "">
			   AND   (
			         P.ProgramCode LIKE '%#url.find#%' OR
					 Pe.Reference LIKE '%#url.find#%' OR
					 P.ProgramName LIKE '%#url.find#%'
					 )					 
			   </cfif>
			   <cfif url.unithierarchy neq "">			   
			   AND   Pe.OrgUnit IN (SELECT OrgUnit 
			                        FROM   Organization.dbo.Organization 
									WHERE  Mission     = '#URL.Mission#' 
									AND    MandateNo   = '#man#'
									AND    HierarchyCode LIKE ('#url.unithierarchy#%') 
								   )	
			   </cfif>	
			   
			   
			   
			   <!--- filter program based on the access rights this person has been granted --->
						
					<cfif getAdministrator(url.mission) eq "0" and check.recordcount eq "0">
										
				    <cfif getRole.OrgUnitLevel eq "All">								
								
					AND     Pe.OrgUnit IN (SELECT OrgUnit				                   
					                    FROM   Organization.dbo.OrganizationAuthorization A
										WHERE  A.UserAccount    = '#SESSION.acc#'
										AND    A.Mission        = '#URL.Mission#'
										AND    A.Role           IN ('ProcReqInquiry','BudgetOfficer')	
										AND    A.ClassParameter = '#URL.EditionId#'								
									   )		
					
					<cfelse>
													
					AND     Pe.OrgUnit IN (SELECT OrgUnit 
					                       FROM   Organization.dbo.Organization Org
										   WHERE  Mission   = '#URL.Mission#'
										   AND    MandateNo = '#MissionPeriod.MandateNo#'
										   									   								
								                 <!--- take the parent code and include all units under it --->
						
											AND     HierarchyRootUnit IN (
									
									                    SELECT OrgUnitCode 
									                    FROM   Organization.dbo.OrganizationAuthorization A, Organization.dbo.Organization O
														WHERE  O.OrgUnit        = A.OrgUnit
														AND    O.Mission        = Org.Mission
														AND    O.MandateNo      = Org.MandateNo
														AND    A.UserAccount    = '#SESSION.acc#'
														AND    A.Mission        = '#URL.Mission#'									
														AND    A.ClassParameter = '#URL.EditionId#'
														AND    A.Role           IN ('ProcReqInquiry','BudgetOfficer')	
														AND    O.MandateNo      = '#man#'
														
													   )	
													   
													   											  
										  )	   	
										   
				  </cfif>				
				
				</cfif>
							   
			GROUP BY P.ProgramCode, Pe.PeriodParentCode
			
									
			<!--- UNION 
			
			12/7/2010 extend for disbursement as well => pending --->
				
		 </cfquery>
		
		 <!--- ------------------------------------------------------------------- --->
		 <!--- above query presents already 3 level - child - father - grandfather --->
		 <!--- ------------------------------------------------------------------- --->
		 
		 <cfset prg = QuotedValueList(select.programCode)>
		 
		 		 		 
		 <!--- check if the query has a parent --->
		 		 
		 <cfloop query="select">
		 
		 	<cfset par = parentcode>	
			
			<cfif clan neq ""> 
						
				<cfif not find("'#par#'",prg) and ParentScope neq "Unit">											
				    <cfset prg = "#prg#,'#par#'">					
				</cfif>						
			
			<cfelse>
			
				<cfif not find("'#par#'",prg)>											
				    <cfset prg = "#prg#,'#par#'">					
				</cfif>					
			
			</cfif>	
														   			
		    <cfloop condition="#par# neq ''">
						
				 <cfif not find("'#par#'",prg)>	
		 			
					<!--- iteration, now check if the parent code has a parent --->
					<!--- now check if the parent code has another parent----- --->
					<!--- ---------------------------------------------------- --->
															
					<cfquery name="Check" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							SELECT   P.*, PP.PeriodParentCode as ParentCode
							FROM     Program P
									 INNER JOIN ProgramPeriod PP
									 	ON P.ProgramCode = PP.ProgramCode
							WHERE    PP.ProgramCode = '#par#' 					
							AND  	 PP.Period      = '#per#'
					</cfquery>
																					
					<cfif clan neq ""> 
					
							<cfif check.ProgramScope neq "Unit">											
							    <cfset prg = "#prg#,'#par#'">					
							</cfif>						
					
					<cfelse>
																				
						    <cfset prg = "#prg#,'#par#'">													
					
					</cfif>		
																						
					<cfset par = check.parentcode>		
								
				<cfelse>
				
					<cfset par = "">
				
				</cfif>				
																	
			</cfloop>		
					 
		 </cfloop>		
		 		 		 					
		 <cfoutput>
		 		
				
			<cfif len(prg) lte "4">
				
				<tr><td colspan="#cols#" class="line" height="1"></td></tr>
				
				<tr bgcolor="ffffff">
				<td colspan="2" height="1" style="padding-left:15px"><font size="1">#Fund#</b></font></td>
				
				<td colspan="9" align="right" style="padding-left:15px" class="labelmedium">
					 <cfif len(prg) lte "4">
					 <font color="808080"><cf_tl id="No Program/Activities found">
					 </cfif>	
				</td>
												
				</tr>
				
			<cfelse>
				
				<tr><td colspan="#cols#" class="line" height="1"></td></tr>
				<cfif fund eq "">
				<tr>
					<td colspan="2" height="1" style="padding-left:4px; font-size:21px" class="labelmedium"><cf_tl id="All funds"></b></font></td>				
					<td colspan="#cols-2#" align="right" height="30"></td>												
				</tr>
				<cfelse>
				<tr>
					<td colspan="2" height="1" style="padding-left:4px; font-size:25px" class="labelmedium">#Fund#</b></font></td>				
					<td colspan="#cols-2#" align="right" height="30"></td>												
				</tr>
				</cfif>
				
			</cfif>
							
		 </cfoutput>	
		 
	 	 <cfif url.hierarchy eq "true">
			<cfset filter = "ProgramHierarchy LIKE Pe.PeriodHierarchy+'%'">							
		 <cfelse>
		    <cfset filter = "ProgramCode = P.ProgramCode">	
		 </cfif>	
		 		 	
				 
		 <cfif len(prg) gt "5">
		 		 		 				
			<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  P.ProgramCode,
				        P.ProgramName,
						Pe.PeriodDescription as ProgramDescription,
						P.ProgramClass, 
						Pe.PeriodHierarchy as ProgramHierarchy,
						P.ProgramScope,
						Pe.Reference,
						 
						<!--- get the amount total --->						 
					
						(
						SELECT    SUM(Total)
						FROM      userquery.dbo.#SESSION.acc#Requirement						
						WHERE     #preservesingleQuotes(filter)#												  						
						<cfif fdid neq "">						  
						AND       Fund = '#fdid#'				
						</cfif>		 		
						) as Requirement,
						
						(
						SELECT   SUM(Total)
						FROM      userquery.dbo.#SESSION.acc#Release
						WHERE     #preservesingleQuotes(filter)#									  												  
						<cfif fdid neq "">						  
						AND       Fund = '#fdid#'					
						</cfif> ) as Allotment,
						
						(
						SELECT   SUM(ReservationAmount) as Amount
						FROM     userquery.dbo.#SESSION.acc#Pipeline
						WHERE    #preservesingleQuotes(filter)#
						<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
						</cfif>	) as Pipeline, 
						
						(
						SELECT   SUM(ReservationAmount) as Amount
						FROM     userquery.dbo.#SESSION.acc#Planned
						WHERE    #preservesingleQuotes(filter)#
						<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
						</cfif>						
						) as Planned,
						
						(
						SELECT   SUM(ReservationAmount) as Amount
						FROM     userquery.dbo.#SESSION.acc#Requisition
						WHERE    #preservesingleQuotes(filter)#
						<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
						</cfif>				
						) as Reservation,
														
						(
						SELECT   SUM(ObligationAmount) as Amount 
						FROM     userquery.dbo.#SESSION.acc#Unliquidated
						WHERE    #preservesingleQuotes(filter)#
							<cfif fdid neq "">						  
								AND       Fund = '#fdid#'					
							</cfif>		
						) as Unliquidated,
						
						(
						SELECT   SUM(InvoiceAmount) as Amount
						FROM     userquery.dbo.#SESSION.acc#Invoice
						WHERE    #preservesingleQuotes(filter)#
						<cfif fdid neq "">						  
						AND       Fund = '#fdid#'					
						</cfif>		
						) as Invoice
						
						<cfif url.mission eq "OICT" or url.mission eq "DM_FMS">
							
							,							
							(
							SELECT   SUM(ExpenditureAmount) as ExpenditureAmount
							FROM     userquery.dbo.#SESSION.acc#IMIS		
							WHERE    #preservesingleQuotes(filter)#
							<cfif fdid neq "">						  
							AND       Fund = '#fdid#'					
							</cfif>			
							) as ExpenditureAmount														
							
						</cfif>						 
						 
				FROM     Program P INNER JOIN
				         ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
				WHERE    Pe.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#URL.Mission#') 
				AND      Pe.Period = '#per#' 
				
				<!--- orgunit that belongs to this mission --->			
				AND      Pe.OrgUnit IN (SELECT OrgUnit 
				                        FROM   Organization.dbo.Organization
				                        WHERE  OrgUnit = Pe.OrgUnit
										AND    Mission = '#URL.Mission#') 	
	
	            <!--- program has not been deactivated --->												
				AND      Pe.RecordStatus <> '9'	
				
				<cfif url.find neq "">
				
			    AND   (
				         P.ProgramCode LIKE '%#url.find#%' OR
						 Pe.Reference LIKE '%#url.find#%' OR
						 P.ProgramName LIKE '%#url.find#%'
					 )					 
			   </cfif>
				
				<!--- program has indeed funds assigned or inherited from the child --->
				AND     (
				
				        P.ProgramCode IN (#preservesinglequotes(prg)#)	
												
						OR
						
						P.ProgramCode IN (SELECT PeriodParentCode 
						                  FROM   ProgramPeriod												
										  WHERE  ProgramCode IN (#preservesinglequotes(prg)#)
										  AND    Period = '#per#')
												
						<cfif url.unithierarchy eq "">	
				
							<cfif SelectBase.EditionId eq EditionId>	
							
							<!--- program has indeed execution records --->
									
							OR 
							
							P.ProgramCode IN (SELECT RF.ProgramCode 
							                  FROM   Purchase.dbo.RequisitionLine R,
											         Purchase.dbo.RequisitionLineFunding RF
											  WHERE  R.RequisitionNo = RF.RequisitionNo
											  AND    RF.ProgramCode IN (#preservesinglequotes(prg)#)
											  AND    R.Mission      = '#URL.Mission#'  
											  AND    R.ActionStatus != '9' 
											  AND    RF.Fund        = '#Fund#'
											  AND    R.Period IN (#preservesingleQuotes(persel)#)
											  )
											  
							</cfif>		
						
						</cfif>			  
										  
						)		
																	   			
				
				ORDER BY Pe.PeriodHierarchy 
									
		    </cfquery>
																																											
			<cfset edid = editionid>
			<cfset fdid = fund>
			
			<!--- looping --->				 
			
			<cfloop query="Program">					
				
				<cfif ProgramClass eq "Program">
					 <cfset cl  = "CAFBFA">
					 <cfset ht  = "40">		
					 <cfset ac  = accessall>			
				<cfelseif ProgramClass eq "Component">
					 <cfset cl  = "f1f1f1"> 
					  <cfset ht = "10">
					  <cfset ac = "1">
				<cfelse>
					 <cfset cl  = "ffffff">
					  <cfset ht = "10">
					  <cfset ac = "1">
				</cfif>				
																				
				<tr bgcolor="#cl#" style="height:25px;!important" class="filterrow navigation_row">						
												
				<td width="30%" class="line" style="height:20px">
															
					<table>
					
					<tr>
					
					<cfif ac eq "1">
					
					<td width="30" 
					     style="padding-left:3px" onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#')">
												
						   <img src="#SESSION.root#/Images/arrow.gif" alt="" 
								id="#programcode#_#edition.editionid#_#fdid#Exp" border="0" class="regular" align="absmiddle" style="cursor: pointer;">
												
						   <img src="#SESSION.root#/Images/arrowdown.gif" 
								id="#programcode#_#edition.editionid#_#fdid#Min" alt="" border="0" align="absmiddle" class="hide" style="cursor: pointer;" height="12" width="12">
																		
					</td>						
									
					<td>&nbsp;</td>													
					<td align="center" height="#ht#">					
																 										
						  <cfif programScope neq "Global">						   
							 <cf_img icon="open" navigation="Yes" onclick="AllotmentInquiry('#ProgramCode#','#fdid#','#URL.Period#','Inquiry','#Vers#')">																								
						  </cfif>							
						  
					</td>	
										
					<cfelse>
					
						<td colspan="3"></td>
						
					</cfif>		
																		
					<td width="30" class="noprint">
					
					   <cf_space spaces="8">
						<cfset cnt = 0>
						<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">				  
						  	  <cfif cnt eq 1><b>.</b></cfif>
							  <cfset cnt = 1>
						</cfloop>		
						
					</td>					
									
					<td class="labelmedium2">#Reference#
					    <div class="filtercontent hide">#Reference# #ProgramName# #ProgramCode#</div></td>				
										
						 <cfif ProgramClass eq "Program">
						 
						 <td width="100%" height="25" style="padding:1px">
						 
						 <table width="100%" height="100%">
							 <tr>
								 <td class="labellarge" bgcolor="B0D8FF" style="padding-left:5px;border: 1px solid Silver;">
									 #ProgramName#		
									 <div class="filtercontent hide">Main</div>					
								 </td>										 
							 </tr>
						 </table>
						 
						 </td>
						 
						 <cfelse>	
						 
						 	 <td width="100%" height="20">
						 
							 <table width="100%" height="100%">
								 <tr class="labelmedium2">
								 <td style="padding-left:6px"><a title="#programdescription#"><font color="000000">#ProgramName#</a></td>	
								 <td align="right" style="padding-right:3px">
								 <img src="#SESSION.root#/images/drill.png" alt="Open Detail" border="0"
								 onclick="bmore('add','#ProgramCode#_#edition.editionid#_#CurrentRow#','#fdid#','','#URL.Period#','#ProgramCode#','','show','list','#url.mission#','#ProgramHierarchy#','#UnitHierarchy#','#edition.editionid#')">
								 </td>				 
								 </tr>
							 </table>		
							 
							 </td>			 
						 						 
						 </cfif>					
										
					</tr>
					</table>	 						 				 
									
				</td>		
								
				<cfset stc = "padding-right:2px;border-left:1px solid Gray;">		
																
				<td align="right" class="line" bgcolor="CEF1F4" 
				onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')" 
				style="#stc#;background-color:##CEF1F480">						
																									
					<cfif Requirement eq "">
					  <cfset rsc = 0>
					<cfelse>
					  <cfset rsc =  Requirement>
					</cfif>
						
					<cf_space align="right" label="#numberformat(rsc/1000,",._")#">					
									
				</td>
				
				<td align="right" class="line" bgcolor="D9FFD9" 
				onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')" 
				style="#stc#;background-color:##D9FFD980">														
					<cfif Allotment eq "">
					  <cfset all = 0>
					<cfelse>
					  <cfset all =  Allotment>
					</cfif>						
					<cf_space align="right" label="#numberformat(all/1000,",._")#">															
				</td>
				
				<cfif url.mission neq "STL">	
				
				<td align="right" class="line" bgcolor="ffffFf" onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
				style="#stc#;background-color:##ffffff80">					
					<cfif Pipeline eq "">
					 <cfset pip =  0>
					  -
  					<cfelse>
					  <cfset pip =  Pipeline>
					  <cf_space align="right" label="#numberformat(pip/1000,",._")#">
					</cfif>					
															
				</td>		
				
				</cfif>
						
				<td align="right" class="line" bgcolor="ffffef" onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
				style="#stc#;background-color:##ffffef80">					
					
					<cfif Planned eq "">
					  -
					   <cfset pla =  0>
					<cfelse>
					  <cfset pla =  Planned>
					  <cf_space align="right" label="#numberformat(pla/1000,",._")#">
					</cfif>
																					
				</td>
				
				<td align="right" class="line" bgcolor="ffffef" onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
				style="#stc#;background-color:##ffffef80">								
					<cfif Reservation eq "">
					 -  <cfset res =  0>
					<cfelse>
					  <cfset res =  Reservation>
					  <cf_space align="right" label="#numberformat(res/1000,",._")#">
					</cfif>					
																
				</td>
												
				<td colspan="1" class="line" bgcolor="F3F3DA" align="right" 
					style="#stc#;background-color:##F3F3DA80" 
					onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')">														
					<cfif Unliquidated eq "">
					  -   <cfset unl =  0>
					<cfelse>
					  <cfset unl =  Unliquidated>
					  <cf_space align="right" label="#numberformat(unl/1000,",._")#" >		
					</cfif>					
													
				</td>
				
				<td align="right" class="line" bgcolor="F3F3DA" 
				style="#stc#;background-color:##F3F3DA80" 
				onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')">										
					<cfif Invoice eq "">
					 -  <cfset inv =  0>
					<cfelse>
					  <cfset inv =  Invoice>
					  <cf_space align="right" label="#numberformat(inv/1000,",._")#">	
					</cfif>					
													
				</td>				
								
				<td align="right" class="line" bgcolor="B7DBFF" onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
			    style="#stc#;background-color:##B7DBFF80">																		
		 
		  		 <cfif url.mission eq "OICT" or url.mission eq "DM_FMS">			   
					
					<cfif ExpenditureAmount eq "">
					  <cfset ims = 0>
					<cfelse>
					  <cfset ims =  ExpenditureAmount>
					</cfif>						
					<cf_space align="right" label="#numberformat(ims/1000,",._")#">		
							  		  
				  <cfelse>				
				  
					<cf_space align="right" label="#numberformat((unl+inv)/1000,",._")#">					
					
				  </cfif>				  						
				  
				</td>			
																
					<cfif Parameter.FundingCheckCleared eq "0">		
											
						<td align="right" 
				    	class="line" 						
						bgcolor="CEF1F4" 
						onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
				        style="#stc#;background-color:##CEF1F480">	
									
						<cfif rsc-pla-res-unl-inv gte 0>
							<cf_space align="right" label="#numberformat((rsc-pla-res-unl-inv)/1000,",._")#">		
						<cfelse>
							<cf_space align="right" label="#numberformat((rsc-pla-res-unl-inv)/1000,",._")#" color="red">		
						</cfif>		
						
						</td>
								
					<cfelse>		
					
						<td align="right" 
				    	class="line" 
						bgcolor="D9FFD9" 						
						onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')"
				        style="#stc#;background-color:##D9FFD980">	
							
						<cfif all-pla-res-unl-inv gte 0>
							<cf_space align="right" label="#numberformat((all-pla-res-unl-inv)/1000,",._")#">		
						<cfelse>
							<cf_space align="right" label="#numberformat((all-pla-res-unl-inv)/1000,",_._")#" color="red">		
						</cfif>			
						
						</td>
						
					</cfif>									
							
				
				<cfset tot = pla+res+unl+inv>
		
				<cfif Parameter.FundingCheckCleared eq "0">
				
					<cfif rsc gt "0">
						<cfset exe = "#numberformat(tot*100/rsc,'._')#%">
						<cfif tot gt rsc>
							<cfset cl = "red">
						<cfelse>
							<cfset cl = "e8e8e8">
						</cfif>
					<cfelse>
						<cfset exe = "-">
						<cfset cl = "d5d5d5">
					</cfif>						
				
				<cfelse>				
				
					<cfif all gt "0">
						<cfset exe = "#numberformat(tot*100/all,'._')#%">
						<cfif tot gt all>
							<cfset cl = "red">
						<cfelse>
							<cfset cl = "e8e8e8">
						</cfif>
					<cfelse>
						<cfset exe = "-">						
						<cfset cl = "d5d5d5">
					</cfif>			
				
				</cfif>
							
				<td align="right" bgcolor="#cl#" style="#stc#;background-color:###cl#80" class="line"
				onclick="object('#programcode#','#url.mission#','#per#','#url.period#','#programclass#','#programhierarchy#','#edition.editionid#','#fdid#','#url.unithierarchy#')">														
				
				<cfif cl eq "red">			
					<cf_space align="right" label="#exe#" color="white"> 		
				<cfelse>
					<cf_space align="right" label="#exe#">						
				</cfif>	
										
				</td>																	
				<td  bgcolor="white" style="border-left: 1px solid Gray;"></td>
																				
				</tr>													
								
				<tr id="d#ProgramCode#_#edid#_#fdid#" class="hide">			
				     <td colspan="#cols#">						 						 
				     <table width="100%">
					     <tr><td class="filterrow">
						 <div class="hide filtercontent">Main #Reference# #ProgramName# #ProgramCode#</div>		
						 <table width="100%" cellspacing="0" cellpadding="0">
							 <tr><td id="i#ProgramCode#_#edid#_#fdid#" bgcolor="white"></td></tr>
						 </table>
						 </tr>
					 </table>
					 </td>					 
				</tr>		
																					
			</cfloop>
					
		</cfif>	
				
</cfoutput>   