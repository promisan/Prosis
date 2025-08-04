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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset cnt = "0">

<cfparam name="URL.Mission" default="x">
<cfparam name="URL.Mandate" default="">
<cfparam name="URL.Mis"     default="#URL.Mission#"> 
<cfparam name="URL.Man"     default="#URL.Mandate#"> 
<cfparam name="URL.href"    default="">

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mandate
	WHERE  Mission = '#URL.Mis#' 
	<cfif URL.Man neq "">
	AND    MandateNo = '#URL.Man#' 
	</cfif>
	ORDER BY MandateNo DESC   
</cfquery>

<cfoutput query="Mandate">

	
    <cfset level01 = 0>

	<!--- we found a case where ParentOrgUnit was the same as OrgUnitCode causing an infinite loop, the below lines
	solve the issue assuming that when the case is present the correct way is to make it root unit 7/1/2015
	Armin--->
	<cfquery name="ResetParent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Organization 
	SET    ParentOrgUnit     = NULL 
	WHERE  Mission           = '#URL.Mis#'
	AND    MandateNo         = '#MandateNo#'
	AND    ParentOrgUnit     = OrgUnitCode
	</cfquery>
	
	<!--- reset --->
	
	<cfquery name="Reset" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Organization 
	SET    HierarchyCode     = NULL, 
	       HierarchyRootUnit = NULL
	WHERE  Mission           = '#URL.Mis#'
	AND    MandateNo         = '#MandateNo#'
	</cfquery>
			
	<cfquery name="Q1" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM     Organization 
		WHERE    Mission   = '#URL.Mis#'
		AND      MandateNo   = '#MandateNo#'
		AND      (ParentOrgUnit = '' OR ParentOrgUnit is NULL)
	    ORDER BY TreeOrder
	</cfquery>
	
		<cfloop query="Q1">
		
		   <cfset level01 = level01 + 1>
		   <cfif level01 lt 10>
		     <cfset level1 = "0#level01#">
		   <cfelse>
		     <cfset level1 = "#Level01#">
		   </cfif>
		   
		   <cfset root    = Q1.OrgUnitCode>
		       
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Organization 
			SET    HierarchyCode = '#Level1#', 
			       HierarchyRootUnit = '#root#'
			WHERE  OrgUnit = '#Q1.OrgUnit#'
			</cfquery>
			
			<cfset cnt = cnt+1>
			<!--- <cfoutput><font face="Arial" size="1">#cnt#</font></cfoutput> --->
			<cfflush>
		
		   <cfset level02 = 0>
		
		   <cfquery name="Q2" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Organization 
			WHERE    Mission   = '#URL.Mis#'
			AND      MandateNo = '#MandateNo#'
			AND      ParentOrgUnit = '#Q1.OrgUnitCode#'
		    ORDER BY TreeOrder
		   </cfquery>
		   
		   <cfloop query="Q2">
		   
		   <cfif Q2.Autonomous eq "1">
			   <cfset root = Q2.OrgUnitCode>	   
		   </cfif>
		
		   <cfset level02 = level02 + 1>
		   <cfif level02 lt 10>
		     <cfset level2 = "0#level02#">
		   <cfelse>
		     <cfset level2 = Level02>
		   </cfif>
		   
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Organization
			SET    HierarchyCode = '#Level1#.#Level2#',
			       HierarchyRootUnit = '#root#'
			WHERE  OrgUnit = '#Q2.OrgUnit#'
			</cfquery>
						
		    <cfset level03 = 0>
		
		    <cfquery name="Q3" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT   *
			    FROM     Organization 
				WHERE    Mission   = '#URL.Mis#'
				AND      MandateNo = '#MandateNo#'
				AND      ParentOrgUnit = '#Q2.OrgUnitCode#'
			    ORDER BY TreeOrder
		    </cfquery>
		   
		       <cfloop query="Q3">
			   
				  <cfif Q3.Autonomous eq "1">
					   <cfset root = Q3.OrgUnitCode>	   
				  </cfif>
		
				  <cfset level03 = level03 + 1>
				    <cfif level03 lt 10>
				     <cfset level3 = "0#level03#">
				  <cfelse>
				     <cfset level3 = Level03>
				  </cfif>
	  
				  <cfquery name="Update" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE Organization
				  SET    HierarchyCode     = '#Level1#.#Level2#.#Level3#', 
				         HierarchyRootUnit = '#root#'
				  WHERE  OrgUnit         = '#Q3.OrgUnit#'
				  </cfquery>				  
										
						  <cfset level04 = 0>
						
						  <cfquery name="Q4" 
						    datasource="AppsOrganization" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Organization 
							WHERE  Mission   = '#URL.Mis#'
							AND    MandateNo = '#MandateNo#'
							AND    ParentOrgUnit = '#Q3.OrgUnitCode#'
						    ORDER BY TreeOrder
						  </cfquery>
		   
		                  <cfloop query="Q4">
						  
						  	 	<cfif Q4.Autonomous eq "1">
								   <cfset root = Q4.OrgUnitCode>	   
							    </cfif>
		
								<cfset level04 = level04 + 1>
								<cfif level04 lt 10>
								    <cfset level4 = "0#level04#">
								<cfelse>
								     <cfset level4 = Level04>
								</cfif>
								   
								<cfquery name="Update" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								UPDATE Organization
								SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#', 
								       HierarchyRootUnit = '#root#'
								WHERE  OrgUnit = '#Q4.OrgUnit#'
								</cfquery>						
								
		                        <cfset level05 = 0>
		
							    <cfquery name="Q5" 
							    datasource="AppsOrganization" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Organization 
								WHERE  Mission   = '#URL.Mis#'
								AND    MandateNo = '#MandateNo#'
								AND    ParentOrgUnit = '#Q4.OrgUnitCode#'
							    ORDER BY TreeOrder
							    </cfquery>
									   
								<cfloop query="Q5">
								
								   <cfif Q5.Autonomous eq "1">
								      <cfset root = Q5.OrgUnitCode>	   
							       </cfif>
								
								   <cfset level05 = level05 + 1>
								    <cfif level05 lt 10>
								     <cfset level5 = "0#level05#">
								   <cfelse>
								     <cfset level5 = Level05>
								   </cfif>
									   
									   <cfquery name="Update" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									UPDATE Organization
									SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#', 
									       HierarchyRootUnit = '#root#'
									WHERE  OrgUnit = '#Q5.OrgUnit#'
									</cfquery>								
															
									<cfset level06 = 0>
									
									   <cfquery name="Q6" 
									    datasource="AppsOrganization" 
									    username="#SESSION.login#" 
									    password="#SESSION.dbpw#">
									    SELECT  *
									    FROM    Organization 
										WHERE   Mission   = '#URL.Mis#'
										AND     MandateNo = '#MandateNo#'
										AND     ParentOrgUnit = '#Q5.OrgUnitCode#'
									    ORDER BY TreeOrder
									   </cfquery>
									   
									   <cfloop query="Q6">
									   
									   	   <cfif Q6.Autonomous eq "1">
									  	    <cfset root = Q6.OrgUnitCode>	   
									       </cfif>
									
										   <cfset level06 = level06 + 1>
										    <cfif level06 lt 10>
										     <cfset level6 = "0#level06#">
										   <cfelse>
										     <cfset level6 = "#Level06#">
										   </cfif>
										   
											   <cfquery name="Update" 
											datasource="AppsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											UPDATE Organization
											SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#', 
											       HierarchyRootUnit = '#root#'
											WHERE  OrgUnit = '#Q6.OrgUnit#'
											</cfquery>
																																						
										   <cfset level07 = 0>
										
										   <cfquery name="Q7" 
											datasource="AppsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT   *
											FROM     Organization 
											WHERE    Mission   = '#URL.Mis#'
											AND      MandateNo = '#MandateNo#'
											AND      ParentOrgUnit = '#Q6.OrgUnitCode#'
											ORDER BY TreeOrder
										   </cfquery>
										   
										   <cfloop query="Q7">
										   
											   <cfif Q7.Autonomous eq "1">
										  	    <cfset root = Q7.OrgUnitCode>	   
									           </cfif>
										
											   <cfset level07 = level07 + 1>
												<cfif level07 lt 10>
												 <cfset level7 = "0#level07#">
											   <cfelse>
												 <cfset level7 = Level07>
											   </cfif>
											   
												<cfquery name="Update" 
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													UPDATE Organization
													SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#.#Level7#', 
														   HierarchyRootUnit = '#root#'
													WHERE  OrgUnit = '#Q7.OrgUnit#'
												</cfquery>	
												
												 <cfset level08 = 0>
										
												   <cfquery name="Q8" 
													datasource="AppsOrganization" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
													SELECT   *
													FROM     Organization 
													WHERE    Mission   = '#URL.Mis#'
													AND      MandateNo = '#MandateNo#'
													AND      ParentOrgUnit = '#Q7.OrgUnitCode#'
													ORDER BY TreeOrder
												   </cfquery>
																						
												 <cfloop query="Q8">
										   
												   <cfif Q8.Autonomous eq "1">
											  	    <cfset root = Q8.OrgUnitCode>	   
										           </cfif>
											
												   <cfset level08 = level08 + 1>
													<cfif level08 lt 10>
													 <cfset level8 = "0#level08#">
												   <cfelse>
													 <cfset level8 = Level08>
												   </cfif>
												   
													<cfquery name="Update" 
													datasource="AppsOrganization" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														UPDATE Organization
														SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#.#Level7#.#Level8#', 
															   HierarchyRootUnit = '#root#'
														WHERE  OrgUnit = '#Q8.OrgUnit#'
													</cfquery>	
													
												   <cfset level09 = 0>
										
												   <cfquery name="Q9" 
													datasource="AppsOrganization" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
													SELECT   *
													FROM     Organization 
													WHERE    Mission   = '#URL.Mis#'
													AND      MandateNo = '#MandateNo#'
													AND      ParentOrgUnit = '#Q8.OrgUnitCode#'
													ORDER BY TreeOrder
												   </cfquery>
													
													<cfloop query="Q9">
											   
													   <cfif Q9.Autonomous eq "1">
												  	    <cfset root = Q9.OrgUnitCode>	   
											           </cfif>
												
													   <cfset level09 = level09 + 1>
														<cfif level09 lt 10>
														 <cfset level9 = "0#level09#">
													   <cfelse>
														 <cfset level9 = Level09>
													   </cfif>
													   
														<cfquery name="Update" 
														datasource="AppsOrganization" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															UPDATE Organization
															SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#.#Level7#.#Level8#.#Level9#', 
																   HierarchyRootUnit = '#root#'
															WHERE  OrgUnit = '#Q9.OrgUnit#'
														</cfquery>	
														
														 <cfset level10 = 0>
										
														   <cfquery name="Q10" 
															datasource="AppsOrganization" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#">
															SELECT   *
															FROM     Organization 
															WHERE    Mission   = '#URL.Mis#'
															AND      MandateNo = '#MandateNo#'
															AND      ParentOrgUnit = '#Q9.OrgUnitCode#'
															ORDER BY TreeOrder
														   </cfquery>
														   
														   <cfloop query="Q10">
											   
														   <cfif Q10.Autonomous eq "1">
													  	    <cfset root = Q10.OrgUnitCode>	   
												           </cfif>
													
														   <cfset level10 = level10 + 1>
															<cfif level10 lt 10>
															 <cfset level10 = "0#level10#">
														   <cfelse>
															 <cfset level10 = Level10>
														   </cfif>
														   
															<cfquery name="Update" 
															datasource="AppsOrganization" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#">
																UPDATE Organization
																SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#.#Level7#.#Level8#.#Level9#.#Level10#', 
																	   HierarchyRootUnit = '#root#'
																WHERE  OrgUnit = '#Q10.OrgUnit#'
															</cfquery>		
															
															  <cfset level11 = 0>
										
															   <cfquery name="Q11" 
																datasource="AppsOrganization" 
																username="#SESSION.login#" 
																password="#SESSION.dbpw#">
																SELECT   *
																FROM     Organization 
																WHERE    Mission   = '#URL.Mis#'
																AND      MandateNo = '#MandateNo#'
																AND      ParentOrgUnit = '#Q10.OrgUnitCode#'
																ORDER BY TreeOrder
															   </cfquery>
														   
															   <cfloop query="Q11">
												   
																   <cfif Q11.Autonomous eq "1">
															  	    <cfset root = Q11.OrgUnitCode>	   
														           </cfif>
															
																   <cfset level11 = level11 + 1>
																	<cfif level11 lt 10>
																	 <cfset level11 = "0#level11#">
																   <cfelse>
																	 <cfset level11 = Level11>
																   </cfif>
																   
																	<cfquery name="Update" 
																	datasource="AppsOrganization" 
																	username="#SESSION.login#" 
																	password="#SESSION.dbpw#">
																		UPDATE Organization
																		SET    HierarchyCode = '#Level1#.#Level2#.#Level3#.#Level4#.#Level5#.#Level6#.#Level7#.#Level8#.#Level9#.#Level10#.#Level11#', 
																			   HierarchyRootUnit = '#root#'
																		WHERE  OrgUnit = '#Q11.OrgUnit#'
																	</cfquery>		
																	
																</cfloop>			
															
															</cfloop>													   
																																														
													</cfloop>															
																																
											   </cfloop>	
																						
										</cfloop>	
										
								   </cfloop>
		
		                     </cfloop>
		
		               </cfloop>
		
	             </cfloop>
		
		   </cfloop>
	
	</cfloop>
	
	<cf_waitEnd>
	
	<!--- invalid characters --->
	
	<cfquery name="Listing" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Organization
	WHERE Mission = '#URL.Mis#'
	</cfquery>
	
	<cfloop query="Listing">
	
		<cfset Name=Replace(OrgUnitName,"'",'','ALL')>
		<cfset NameShort=Replace(OrgUnitNameShort,"'",'','ALL')>
			
		<cfif Name neq OrgUnitName or NameShort neq OrgUnitNameShort>
		
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Organization
			SET    OrgUnitName = '#Name#', 
			       OrgUnitNameShort = '#NameShort#' 
			WHERE OrgUnit = '#OrgUnit#'
			</cfquery>
	
		</cfif>
	
	</cfloop>

</cfoutput>

<cfif URL.href eq "">

	<b><font color="008000">Completed</font>&nbsp;
	
	<script>
		Prosis.busy('no')
		location.reload()
		parent.opener.location.reload();
	</script>

   <!--- do nothing --->
   
<cfelseif URL.href eq "save">   

	<!--- embedded in the save --->
 
<cfelse>

   <script>
	  parent.opener.location.reload();
   </script>
   
</cfif>

