<!--
    Copyright © 2025 Promisan B.V.

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
<title>Update Hierarchy for programcode</title>

<cfparam name="Attributes.ProgramCode" default="0">
<cfparam name="Attributes.ProgramPeriod" default="">

<!--- discontinued 17/8/2015

<!--- locate program/project --->

<!--- A we do the generic and the one for the period --->
	
	<cfquery name = "Parent" 
	   datasource = "AppsProgram" 
	   username   = "#SESSION.login#" 
	   password   = "#SESSION.dbpw#">
	   SELECT *
	   FROM   Program
	   WHERE  ProgramCode = '#Attributes.ProgramCode#' 
	</cfquery>  
	
	<cfloop index="i" from="1" to="4" step="1">
	
	    <!--- go to the highest level of this one --->
		<cfif Parent.ParentCode gt "">
		
			<cfquery name = "Parent" 
			   datasource = "AppsProgram" 
			   username   = "#SESSION.login#" 
			   password   = "#SESSION.dbpw#">
				   SELECT *
				   FROM   Program
				   WHERE  ProgramCode = '#Parent.ParentCode#' 
		    </cfquery> 
			 
		</cfif>  
	
	</cfloop>
	
	<cfif Parent.ListingOrder eq "">
		<cfset ord = "0">
	<cfelse>
		<cfset ord = Parent.listingorder>
	</cfif>	
	
	<cfset hcode = "#ord#_#Parent.ProgramCode#">
	
	<cfquery name="UPDATE" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Program
		SET    ProgramHierarchy = '#hcode#'
		WHERE  ProgramCode = '#Parent.ProgramCode#'
	</cfquery>
	
	<cfquery name="Child1" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   ProgramCode
		FROM     Program
		WHERE    ParentCode = '#Parent.ProgramCode#'
		ORDER BY ListingOrder
	</cfquery>
	
	<cfloop query="Child1">
	
	   <cfif currentRow lt 10>
	     <cfset levelA = "00#currentRow#">
	   <cfelseif currentRow lt 100>
	     <cfset levelA = "0#currentRow#">
	   <cfelse>
	     <cfset levelA = "#currentRow#">
	   </cfif>
	
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Program
			SET    ProgramHierarchy = '#hcode#.#levelA#'
			WHERE ProgramCode    = '#Child1.ProgramCode#'
		</cfquery>
				
		<cfquery name="Child2" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT ProgramCode
		    FROM Program
		    WHERE ParentCode = '#Child1.ProgramCode#'
		    ORDER BY ListingOrder
	    </cfquery>
		
		<cfloop query="Child2">
	
		   <cfif Child2.currentRow lt 10>
		     <cfset levelB = "00#Child2.currentRow#">
		   <cfelseif Child2.currentRow lt 100>
		     <cfset levelB = "0#Child2.currentRow#">
		   <cfelse>
		     <cfset levelB = "#Child2.currentRow#">
		   </cfif>
		
			<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Program
				SET    ProgramHierarchy = '#hcode#.#levelA#.#levelB#'
				WHERE  ProgramCode = '#Child2.ProgramCode#'
			</cfquery>
					
			<cfquery name="Child3" 
	    	datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT ProgramCode
			    FROM   Program
			    WHERE  ParentCode = '#Child2.ProgramCode#'
			    ORDER BY ListingOrder
	    	</cfquery>
			
			<cfloop query="Child3">
	
				<cfif Child3.currentRow lt 10>
				     <cfset levelC = "00#Child3.currentRow#">
				<cfelseif Child3.currentRow lt 100>
				     <cfset levelC = "0#Child3.currentRow#">
				<cfelse>
				     <cfset levelC = "#Child3.currentRow#">
				</cfif>
			
				<cfquery name="Update" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Program
					SET    ProgramHierarchy = '#hcode#.#levelA#.#levelB#.#levelC#'
					WHERE  ProgramCode = '#Child3.ProgramCode#'
				</cfquery>
	
				<cfquery name="Child4" 
		    	datasource="AppsProgram" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    	SELECT ProgramCode
				    FROM   Program
				    WHERE  ParentCode = '#Child3.ProgramCode#'
			    	ORDER BY ListingOrder
		    	</cfquery>
			
				<cfloop query="Child4">
		
				   <cfif Child4.currentRow lt 10>
				     <cfset levelD = "00#Child4.currentRow#">
				   <cfelseif Child4.currentRow lt 100>
				     <cfset levelD = "0#Child4.currentRow#">
				   <cfelse>
				     <cfset levelD = "#Child4.currentRow#">
				   </cfif>
				
					<cfquery name="Update" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Program
					SET    ProgramHierarchy = '#hcode#.#levelA#.#levelB#.#levelC#.#levelD#'
					WHERE  ProgramCode = '#Child4.ProgramCode#'
					</cfquery>
				</cfloop>	
									
			</cfloop>	
		
		</cfloop>
		
	</cfloop>
	
--->	

<!--- On the period --->
		
<cfif Attributes.Period neq "">

		<cfset per     = Attributes.Period>
		
		<cfquery name = "Parent" 
		   datasource = "AppsProgram" 
		   username   = "#SESSION.login#" 
		   password   = "#SESSION.dbpw#">
		   SELECT *
		   FROM   ProgramPeriod
		   WHERE  ProgramCode = '#Attributes.ProgramCode#' 
		   AND    Period = '#per#'
		</cfquery>  
		
		<cfloop index="i" from="1" to="4" step="1">
		
		    <!--- go to the highest level of this one --->
			<cfif Parent.PeriodParentCode gt "">
			
				<cfquery name = "Parent" 
				   datasource = "AppsProgram" 
				   username   = "#SESSION.login#" 
				   password   = "#SESSION.dbpw#">
				   SELECT *
				   FROM   ProgramPeriod
				   WHERE  ProgramCode = '#Parent.PeriodParentCode#' 
				   AND    Period      = '#per#'
			    </cfquery> 
				 
			</cfif>  
		
		</cfloop>
		
		<cfset ProgramCode = Parent.ProgramCode>
		
		<cfquery name = "Root" 
		   datasource = "AppsProgram" 
		   username   = "#SESSION.login#" 
		   password   = "#SESSION.dbpw#">
			   SELECT *
			   FROM   Program P
			   WHERE  ProgramCode     = '#programcode#'			  
		</cfquery>  
		  
		<cfloop query = "root">
			
			<cfif ListingOrder eq "">
				<cfset ord = "0">
			<cfelse>
				<cfset ord = listingorder>
			</cfif>	
			
			<cfset HierarchyCode = "#ord#_#ProgramCode#">
			
			<cfquery name="UPDATE" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE      ProgramPeriod
				SET         PeriodHierarchy = '#HierarchyCode#'
				WHERE       ProgramCode     = '#ProgramCode#'
				AND         Period          = '#per#'
			</cfquery>
			
			<cfquery name="Child1" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   P.ProgramCode			
				FROM     ProgramPeriod Pe, Program P
				WHERE    Pe.ProgramCode = P.ProgramCode
				AND      P.ProgramCode IN (SELECT ProgramCode 
			                               FROM   Program 
									       WHERE  Mission = '#mission#')    
				AND      Pe.Period = '#period#'		  
				AND      Pe.PeriodParentCode = '#Root.ProgramCode#'			
				ORDER BY P.ListingOrder
			</cfquery>
		
			<cfloop query="Child1">
			
			   <cfif currentRow lt 10>
			     <cfset levelA = "00#currentRow#">
			   <cfelseif currentRow lt 100>
			     <cfset levelA = "0#currentRow#">
			   <cfelse>
			     <cfset levelA = "#currentRow#">
			   </cfif>
			
				<cfquery name="Update" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE      ProgramPeriod
					SET         PeriodHierarchy = '#HierarchyCode#.#levelA#'
					WHERE       ProgramCode = '#Child1.ProgramCode#'
					AND         Period          = '#per#'				
				</cfquery>
				
				<cfquery name="Child2" 
			    datasource="AppsProgram" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT   P.ProgramCode			
					FROM     ProgramPeriod Pe, Program P
					WHERE    Pe.ProgramCode = P.ProgramCode
					AND      P.ProgramCode IN (SELECT ProgramCode 
				                               FROM   Program 
										       WHERE  Mission = '#mission#')    
					AND      Pe.Period = '#period#'		  
					AND      Pe.PeriodParentCode = '#Child1.ProgramCode#'			
					ORDER BY P.ListingOrder			
			    </cfquery>
				
				<cfloop query="Child2">
			
				   <cfif Child2.currentRow lt 10>
				     <cfset levelB = "00#Child2.currentRow#">
				   <cfelseif Child2.currentRow lt 100>
				     <cfset levelB = "0#Child2.currentRow#">
				   <cfelse>
				     <cfset levelB = "#Child2.currentRow#">
				   </cfif>
				   
				   <cfquery name="Update" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE      ProgramPeriod
					SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#'
					WHERE       ProgramCode = '#Child2.ProgramCode#'
					AND         Period          = '#per#'				
					</cfquery>
					
					<cfquery name="Child3" 
				    datasource="AppsProgram" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
						SELECT   P.ProgramCode			
						FROM     ProgramPeriod Pe, Program P
						WHERE    Pe.ProgramCode = P.ProgramCode
						AND      P.ProgramCode IN (SELECT ProgramCode 
					                               FROM   Program 
											       WHERE  Mission = '#mission#')    
						AND      Pe.Period = '#period#'		  
						AND      Pe.PeriodParentCode = '#Child2.ProgramCode#'			
						ORDER BY P.ListingOrder			
				    </cfquery>
									
					<cfloop query="Child3">
			
					   <cfif Child3.currentRow lt 10>
					     <cfset levelC = "00#Child3.currentRow#">
					   <cfelseif Child3.currentRow lt 100>
					     <cfset levelC = "0#Child3.currentRow#">
					   <cfelse>
					     <cfset levelC = "#Child3.currentRow#">
					   </cfif>
					   
					    <cfquery name="Update" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE      ProgramPeriod
							SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#.#levelC#'
							WHERE       ProgramCode = '#Child3.ProgramCode#'
							AND         Period          = '#per#'				
						</cfquery>
						
						<cfquery name="Child4" 
						    datasource="AppsProgram" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
								SELECT   P.ProgramCode			
								FROM     ProgramPeriod Pe, Program P
								WHERE    Pe.ProgramCode = P.ProgramCode
								AND      P.ProgramCode IN (SELECT ProgramCode 
							                               FROM   Program 
													       WHERE  Mission = '#mission#')    
								AND      Pe.Period = '#period#'		  
								AND      Pe.PeriodParentCode = '#Child3.ProgramCode#'			
								ORDER BY P.ListingOrder			
						</cfquery>
													
						<cfloop query="Child4">
					
							   <cfif Child4.currentRow lt 10>
							     <cfset levelD = "00#Child4.currentRow#">
							   <cfelseif Child4.currentRow lt 100>
							     <cfset levelD = "0#Child4.currentRow#">
							   <cfelse>
							     <cfset levelD = "#Child4.currentRow#">
							   </cfif>
							   
							   <cfquery name="Update" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									UPDATE      ProgramPeriod
									SET         PeriodHierarchy = '#HierarchyCode#.#levelA#.#levelB#.#levelC#.#levelD#'
									WHERE       ProgramCode     = '#Child4.ProgramCode#'
									AND         Period          = '#per#'				
							  </cfquery>
													
						</cfloop>
					
					</cfloop>
				
				</cfloop>
				
			</cfloop>
		
		</cfloop>
			





</cfif>		
