
<cfquery name="Parameter" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Attributes.Mission#'
</cfquery>

<cf_tl id="#Attributes.Mission#" var="mis">

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;'>#mis#</span>"	
	root="no"
	expand="Yes">

	<cfif Parameter.AdministrationLevel eq "Tree">
				 	   	 
		      <cfquery name="Category" 
			  datasource="AppsLedger" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT DISTINCT R.TransactionCategory, R.Description, R.OrderListing, Currency
			      FROM   Ref_TransactionCategory R, Journal J
				  WHERE  R.TransactionCategory = J.TransactionCategory
			 	  AND    J.Mission     = '#Attributes.Mission#'
				  AND    GLCategory    = '#Attributes.GLCategory#'
				  AND    Operational   = '1'
				  <cfif getAdministrator(url.mission) eq "0">
				  AND    J.TransactionCategory IN (SELECT TransactionCategory
							  	                   FROM Journal
	      	    							       WHERE Journal IN (SELECT ClassParameter 
														          FROM   Organization.dbo.OrganizationAuthorization
														          WHERE  UserAccount = '#SESSION.acc#' 
											                      AND   Role        = 'Accountant'
																  AND   Mission     = '#Attributes.Mission#'
																  AND   OrgUnit is NULL )
											       )							  
				  </cfif>									 
				  ORDER BY Currency,OrderListing
			  </cfquery>
			  
			  <cfif category.recordcount eq "0">
			  
			     <cf_tl id="No access granted" var="vNoAccess">
				 
			  	  <cf_UItreeitem value="101"
			        display="<font color='FF0000'>#vNoAccess#.</font>"
					parent="root">	
			  
			  </cfif>
			  
			  <cf_tl id="Actions" var="vEvents">
			  
			  <cf_UItreeitem value="action"
			        display="<span style='font-size:18px;font-weight:bold' class='labelit'>#vEvents#</span>"						
					href="JournalViewOpen.cfm?ID=EVE&ID1=0&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"				
					parent="root"
					target="right"							
			        expand="Yes">							 	
			  
			  <cf_tl id="Journal" var="vJournals">
			  
			  <cf_UItreeitem value="journal"
			        display="<span style='font-size:18px;font-weight:bold;padding-top:5px' class='labelit'>#vJournals#</span>"						
					parent="root"							
			        expand="Yes">	
												  
		      <cfoutput query="Category" group="Currency">		  
			  
			  	 <cf_UItreeitem value="journal_#Currency#"
					        display="<span style='font-size:16px;padding-top:5px;color:green;font-weight:bold;' class='labelit'>#Currency#</span>"
							parent="journal"											
							target="right"
					        expand="Yes">	
			  
			  	 <cfoutput>			 
				 			 
				 <cf_tl id="#Description#" var="1">
				 			  
				 <cf_UItreeitem value="jr_#currency#_#LEFT(Description,5)#"
			        display="<span style='font-size:15px' class='labelit'>#lt_text#</span>"						
					parent="journal_#currency#"			
			        expand="No">					
			  		  
			        <cfquery name="Journal" 
		             datasource="AppsLedger" 
		             username="#SESSION.login#" 
		             password="#SESSION.dbpw#">
			             SELECT *
			             FROM   Journal
			      	     WHERE  TransactionCategory = '#Category.TransactionCategory#'
						 AND    Mission    = '#Attributes.Mission#'
						 AND    GLCategory = '#Attributes.GLCategory#'
						 AND    Currency   = '#Category.Currency#'
						 AND    (
						        	Operational = '1' 
							        OR 
									Journal IN (SELECT Journal FROM TransactionHeader WHERE Mission = '#Attributes.Mission#' AND AccountPeriod = '#URL.Period#')
								)
						 <cfif getAdministrator(url.mission) eq "0">
						 AND    Journal IN (SELECT ClassParameter 
						                    FROM   Organization.dbo.OrganizationAuthorization
						                    WHERE  UserAccount = '#SESSION.acc#' 
				                            AND    Role        = 'Accountant'
											AND    Mission     = '#Attributes.Mission#' AND OrgUnit is NULL)
						 </cfif>		
						 ORDER BY Currency, Journal								
					 </cfquery>
					 
					 <cfset cat = LEFT(description,5)>							 
					 					 	 			 					 			   
		             <cfloop query="Journal">
					 
					 		<cfif JournalType eq "General">
					 					 													 
							<cf_UItreeitem value="#Journal#"
						        display="<span style='font-size:13px' class='labelit'>#Journal# - #Description#</span>"
								parent="jr_#currency#_#cat#"									
								href="JournalViewOpen.cfm?ID=PEN&ID1=0&ID2=#Journal.Journal#&Mission=#Attributes.Mission#"							
								target="right"
						        expand="No">	
								
							<cfelse>
							
							<cf_UItreeitem value="#Journal#"
						        display="<span style='font-size:13px' class='labelit'>#Journal# - #Description# <span style='color:red;font-size: 10px; vertical-align: super;'>#Ucase(left(JournalType,3))#</span></span>"
								parent="jr_#currency#_#cat#"									
								href="JournalViewOpen.cfm?ID=PEN&ID1=0&ID2=#Journal.Journal#&Mission=#Attributes.Mission#"							
								target="right"
						        expand="No">								
							
							</cfif>	
							
							<cf_tl id="Open documents" var="vDocuments">
								
							<cf_UItreeitem value="#Journal#_doc"
						        display="<span style='font-size:12px'>#vDocuments#</span>"
								parent="#Journal#"																	
								href="JournalViewOpen.cfm?ID=OPE&ID1=0&ID2=#Journal.Journal#&Mission=#Attributes.Mission#"							
								target="right"
						        expand="No">																																				
															
							<cf_tl id="All Documents" var="vAll">
								
							<cf_UItreeitem value="#Journal#_doc"
						        display="<span style='font-size:12px'>#vAll#</span>"
								parent="#Journal#"																	
								href="JournalViewOpen.cfm?ID=JOU&ID1=0&ID2=#Journal.Journal#&Mission=#Attributes.Mission#"							
								target="right"
						        expand="No">								
														
							<cf_tl id="Postings" var="vPostings">
								
							<cf_UItreeitem value="#Journal#_tra"
						        display="<span style='font-size:12px'>#vPostings#</span>"
								parent="#Journal#"														
								href="JournalViewOpen.cfm?ID=TRA&ID1=0&ID2=#Journal.Journal#&Mission=#Attributes.Mission#&systemfunctionid=#url.systemfunctionid#"							
								target="right"
						        expand="No">	
																	
					</cfloop>		
																
									
				</cfoutput>
				
			</cfoutput>		
			
			<cfinvoke component = "Service.Access"  
			 method             = "RoleAccess" 		
			 mission            = "#Attributes.Mission#"   
			 role               = "'Accountant'" 		  
			 accesslevel        = "2"			 
			 returnvariable     = "access">			
			 
			<cfif access eq "granted"> 			
				
				<cf_tl id="Account" var="vAccount">
					
				<cf_UItreeitem value="account"
				        display="<span style='font-size:18px;padding-top:5px;font-weight:bold' class='labelit'>#vAccount#</span>"						
						parent="root"							
				        expand="Yes">	
							
				<cf_UItreeitem value="vw_Balance"
				        display="<span style='font-size:15px;padding-top:2px' class='labelit'>Trial Balance</span>"
						parent="account"	
						href="../../../GLedger/Inquiry/Account/BalanceListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&glcategory=#Attributes.GLCategory#&Orgunit="										
						target="right"
				        expand="No">			
						
				<cf_UItreeitem value="vw_Result"
				        display="<span style='font-size:15px;' class='labelit'>Results</span>"
						parent="account"	
						href="../../../GLedger/Inquiry/Account/ResultListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&glcategory=#Attributes.GLCategory#&OrgUnit="										
						target="right"
				        expand="No">	
					
			</cfif>							
						
			<cfif Attributes.GLCategory eq "Actuals">
											
					 <cf_tl id="Views" var="vLedgerViews">
					
					 <cf_UItreeitem value="views"
					        display="<span style='font-size:18px;padding-top:5px;font-weight:bold' class='labelit'>#vLedgerViews#</span>"						
							parent="root"							
					        expand="Yes">		
										
					  <cfquery name="Currency" 
					  datasource="AppsLedger" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT   DISTINCT Currency 
					      FROM     Journal
						  WHERE    Mission = '#Attributes.Mission#'		  					  
					  </cfquery>					 
				
					<cfloop query="Currency">
				
						 	<cfset cur = currency.currency>
							
							<cf_UItreeitem value="vw_#Currency#"
						        display="<span style='font-size:15px;padding-top:5px;' class='labelit'>#Currency#</span>"
								parent="views"											
								target="right"
						        expand="No">		
								
							<cfinvoke component = "Service.Authorization.Function"  
				  			 method           = "AuthorisedFunctions" 
							 mode             = "View"			 
							 mission          = "#attributes.mission#" 
							 orgunit          = ""
				   			 Role             = ""
							 SystemModule     = "'Accounting'"
							 FunctionClass    = "'Inquiry'"
							 MenuClass        = "'Journal'"
							 Except           = "''"
				   			 Anonymous        = ""
							 returnvariable   = "listaccess">		
							 
							<cfloop query="listaccess"> 	
							
								<cfif FunctionName eq "Staff Advances">
								
									<cfquery name="Area" 
									  datasource="AppsLedger" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									      SELECT * 
									      FROM   Employee.dbo.Ref_AreaGLedger	
										  WHERE Area = 'Advance'					 
									</cfquery>	
									
									<cfif area.recordcount eq "1">
									
									 <cf_UItreeitem value="#cur#_#left(systemfunctionid,8)#"
								      	    display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
											parent="vw_#cur#"
											href="../../../#FunctionDirectory#/#FunctionPath#?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&currency=#cur#&area=Advance"							
											target="right"																					
									        expand="No">	
									
									</cfif>
								
								<cfelse>
								
									 <cf_UItreeitem value="#cur#_#left(systemfunctionid,8)#"
							      	    display="<span style='font-size:14px' class='labelit'>#FunctionName#</span>"
										parent="vw_#cur#"	
										href="../../../#FunctionDirectory#/#FunctionPath#?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&currency=#cur#"							
										target="right"																					
								        expand="No">		
										
								</cfif>								
										
							</cfloop>							
					
					</cfloop>	
				
							
			</cfif>		
					
	<cfelse>	
			
		  <cf_tl id="Actions" var="vEvents">
			  
		  <cf_UItreeitem value="journal"
		        display="<span style='padding-bottom:5px' class='labellarge'>#vEvents#</span>"						
				href="JournalViewOpen.cfm?ID=EVE&ID1=0&Mission=#Attributes.Mission#"				
				parent="root"		
				target="right"					
		        expand="Yes">		
	
		<cfquery name="Mandate" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT   DISTINCT MandateNo, Description, DateEffective, DateExpiration 
		      FROM     Ref_Mandate
		   	  WHERE     Mission = '#Attributes.Mission#' 
			  ORDER BY DateEffective DESC
		</cfquery>
		 	
		 <cfif getAdministrator(attributes.mission) eq "Yes">
		 
			  <!--- show only the last parent org structure --->
			 <cfquery name="Level01" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode, OrgUnitNameShort, MissionOrgUnitId 
			      FROM #Client.LanPrefix#Organization
			   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1)
				  AND Mission     = '#Mission#'
				  AND MandateNo   = '#Mandate.MandateNo#'
				  ORDER BY TreeOrder, OrgUnitName
			 </cfquery>
			 
			 <cfif Level01.recordcount eq "0">
			  
			  	 <cf_tl id="No org units could be found" var="vNoOrgUnits">
			  	 
				 <cf_UItreeitem value="xx"
			        display="<font color='FF0000'>#vNoOrgUnits#.</font>"
					parent="root">	
			  
			  </cfif>
		 
		 <cfelse>
		
			  <!--- show only the last parent org structure --->
			 <cfquery name="Level01" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT TreeOrder, OrgUnitName, OrgUnit, OrgUnitCode, OrgUnitNameShort, MissionOrgUnitId
			      FROM   #Client.LanPrefix#Organization
			   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1)
				  AND   Mission     = '#Mission#'
				  AND   MandateNo   = '#Mandate.MandateNo#'
				  AND (OrgUnit in (SELECT OrgUnit 
				                   FROM   OrganizationAuthorization 
				                   WHERE  UserAccount = '#SESSION.acc#' 
				                   AND    Role = 'Accountant')
				       OR 
					   Mission IN (SELECT Mission 
					               FROM   OrganizationAuthorization 
								   WHERE  UserAccount = '#SESSION.acc#' 
			                       AND    Role = 'Accountant'
			                 	   AND    OrgUnit is NULL))
				  ORDER BY TreeOrder, OrgUnitName
			 </cfquery>
		 
		 </cfif>
		 
		 <cfif level01.recordcount lt "4">
		 	<cfset show = "Yes">
		 <cfelse>
		 	<cfset show = "No">
		 </cfif>
		 		 	 	    
		 <cfloop query="level01">
		 
		 	<cfset OrgUnit          = "#Level01.OrgUnit#">
			<cfset MissionOrgUnitId = "#Level01.MissionOrgUnitId#">
		 
		  	<cf_UItreeitem value="#OrgUnit#"
			        display="<span style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold' class='labelit'>#Level01.OrgUnitNameShort#</span>"
					parent="Root"							
			        expand="#show#">		     
		 
		      <cfquery name="Category" 
			  datasource="AppsLedger" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT DISTINCT TransactionCategory, Description, OrderListing
			      FROM   Ref_TransactionCategory R
			 	  WHERE  TransactionCategory IN (SELECT TransactionCategory 
				                                 FROM   Journal 
											 	 WHERE  Operational = 1 
												 AND    GLCategory = '#Attributes.GLCategory#'
												 AND    Mission    = '#Attributes.Mission#')
				  <cfif getAdministrator(attributes.mission) eq "0">
				  AND      TransactionCategory IN (SELECT TransactionCategory
										             FROM    Journal
			      	    							 WHERE   Journal IN (SELECT ClassParameter 
																         FROM   Organization.dbo.OrganizationAuthorization
																         WHERE  UserAccount = '#SESSION.acc#' 
													                     AND   Role = 'Accountant'
																		 AND   Mission = '#Attributes.Mission#'
																		 AND   OrgUnit is NULL
																	    )
													)				    
																	  
				  </cfif>
				  
				   AND     TransactionCategory IN (SELECT TransactionCategory
										           FROM    Journal
			      	    						   WHERE   Mission = '#Attributes.mission#'
												   AND   (OrgUnitOwner is NULL 
													        OR OrgUnitOwner = '0' 
														    OR OrgUnitOwner IN	(SELECT OrgUnit 
															                     FROM   Organization.dbo.Organization
																				 WHERE  Mission = '#attributes.mission#'
																				 AND    MissionOrgUnitid = '#MissionOrgUnitId#')
							                               )				
													)	   		 										 
				  
				  ORDER BY OrderListing
			  </cfquery>
			  
			  <cf_tl id="Journal" var="vJournals">
			  
			  <cf_UItreeitem value="journal#OrgUnit#"
			        display="<span style='font-size:18px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labellarge'>#vJournals#</span>"						
					parent="#OrgUnit#"							
			        expand="Yes">	
			  
			  <cfif category.recordcount eq "0">
			  
			  	  <cf_tl id="No access granted" var="vNoAccess">
					
			  	  <cf_UItreeitem value="xx"
			        display="<span style='font-size:15px' class='labelit'>#vNoAccess#.</span>"
					parent="root">	
			  
			  </cfif>
		  
		      <cfloop query="Category">
			  
			  	<cfset ct = currentrow>
				
				<cf_tl id="#Description#" var="1">
			  		  
			    <cf_UItreeitem value="journal#OrgUnit#_#ct#"
			        display="<span style='font-size:15px;padding-top:3px;padding-bottom:2px;color:6688aa;font-weight:bold' class='labelit'>#lt_text#</span>"
					parent="journal#OrgUnit#"											
			        expand="No">	
			  				  
			        <cfquery name="Journal" 
		             datasource="AppsLedger" 
		             username="#SESSION.login#" 
		             password="#SESSION.dbpw#">
		             SELECT *
		             FROM   Journal
		      	     WHERE  TransactionCategory = '#Category.TransactionCategory#'					
					 AND    GLCategory = '#Attributes.GLCategory#'
					 AND    Mission = '#Attributes.Mission#'
					 
					  AND    (
						        	Operational = '1' 
							        OR 
									Journal IN (SELECT Journal FROM TransactionHeader WHERE Mission = '#Attributes.Mission#' AND AccountPeriod = '#URL.Period#')
								)
					 
					 <cfif getAdministrator(attributes.mission) eq "0">
					 AND  Journal IN (SELECT ClassParameter 
					                  FROM   Organization.dbo.OrganizationAuthorization
					                  WHERE  UserAccount = '#SESSION.acc#' 
			                             AND Role = 'Accountant'
										 AND ((OrgUnit = '#OrgUnit#') OR (Mission = '#Attributes.Mission#' AND OrgUnit is NULL)))
					 </cfif>	
					 <!--- show only relevant journals --->	
					  AND   (   OrgUnitOwner is NULL 
							    OR OrgUnitOwner = '0' 
							    OR OrgUnitOwner IN	(SELECT OrgUnit 
								                     FROM   Organization.dbo.Organization
													 WHERE  Mission = '#attributes.mission#'
													 AND    MissionOrgUnitid = '#MissionOrgUnitId#')
							)													 
				  
					 
					 								
					 </cfquery>
													 			   
		             <cfloop query="Journal">
					 
						<cf_UItreeitem value="#OrgUnit#_#ct#_#Journal#"
				         display  = "<span style='font-size:13.5px' class='labelit'>#Description#</span>"
						 parent   = "journal#OrgUnit#_#ct#"								
						 href     = "JournalViewOpen.cfm?ID=JOU&ID1=#OrgUnit#&ID2=#Journal.Journal#&Mission=#Attributes.Mission#"							
						 target   = "right"
				         expand   = "No">	
					
					</cfloop>
					 				 	  	  
			  </cfloop>		
			  
			  <cfinvoke component = "Service.Access"  
				 method             = "RoleAccess" 		
				 mission            = "#Attributes.Mission#"   
				 role               = "'Accountant'" 		  
				 accesslevel        = "2"	
				 unit               = "#orgunit#"		 
				 returnvariable     = "access">			
			 
			   <cfif access eq "granted"> 			
			  
				   <cf_tl id="GLAccount" var="vAccount">
				  
				  <cf_UItreeitem value="account#OrgUnit#"
				        display="<span style='font-size:18px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labellarge'>#vAccount#</span>"						
						parent="#OrgUnit#"							
				        expand="Yes">							
							
					<cf_UItreeitem value="vw_Balance"
					        display="<span style='font-size:15px;padding-top:2px;padding-bottom:2px' class='labelit'>Trial Balance</span>"
							parent="account#OrgUnit#"	
							href="../../../GLedger/Inquiry/Account/BalanceListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&glcategory=#Attributes.GLCategory#&Orgunit=#orgunit#"										
							target="right"
					        expand="No">			
							
					<cf_UItreeitem value="vw_Result"
					        display="<span style='font-size:15px;padding-top:2px;padding-bottom:2px' class='labelit'>Results</span>"
							parent="account#OrgUnit#"	
							href="../../../GLedger/Inquiry/Account/ResultListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#Attributes.Mission#&period=#attributes.Period#&glcategory=#Attributes.GLCategory#&OrgUnit=#orgunit#"										
							target="right"
					        expand="No">	
							
				 </cfif>									 
			 	   		 		  
		  </cfloop>	  	
		  		  	
	</cfif>

</cf_UItree>

