
<!---  Name: /Component/Process/Program/Category.cfc
       Description: Program procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "ProgramRoutine for multiple reference tables to control like ProgramCategory, ProgramFinancial and later event">
	
	<cffunction name="ReferenceTableControl"
             access="public"
             returntype="any"
             displayname="Determine if category item has to be shown for data entry">
		
		<cfargument name="ControlObject"      type="string" required="true"  default="Ref_ProgramCategory">	
		<cfargument name="Mission"            type="string" required="true"  default="">	
		<cfargument name="AreaCode"           type="string" required="true"  default=""> 
		<cfargument name="ProgramCode"        type="string" required="true"  default="">
		<cfargument name="Period"             type="string" required="true">
		
		<!--- it is defined if a category has to be shown within a mission through ref_ParameterMissionCategory which is the top level 
		Then we define for each item which is passedin the cluster in hierarchy, if the hierarchy item passes the control table, 

			obtain for the project top mission, program, period, parent unit -> to cfc

			check if category + pass = go

			if no, then all elements under it will not go either, next

			what is a -go-

			check category + mission + period 

			= if no records for cat, mis, -period- found = pass	
			= records for period found and match = pass
			otherwise = hide			
			we return a list of categorycodes that to be hidden --->

        <!--- ---------------------------------------- --->		
		<!--- obtain the program of this programcode-- --->
		<!--- ---------------------------------------- --->
		
				
		<cfquery name="get" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProgramPeriod
			WHERE     ProgramCode = '#ProgramCode#'
			AND       Period      = '#Period#'			
		</cfquery>	
		
		<cfset phier = get.PeriodHierarchy>
		<cfset program = "">
		
		<!--- ----------------------------------------- --->	
		<!--- ------obtain the program of it ---------- --->
		<!--- ----------------------------------------- --->
		
		<cfset hier = "">
		
		<cfloop index="itm" list="#phier#" delimiters=".">
				     
			<cfif hier eq "">
				<cfset hier = "#itm#">
			<cfelse>
			    <cfset hier = "#hier#.#itm#">	
			</cfif>	
		
			<cfquery name="get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      ProgramPeriod Pe
				WHERE     ProgramCode IN (SELECT ProgramCode 
				                          FROM   Program 
										  WHERE  ProgramCode = Pe.ProgramCode
										  AND    ProgramClass = 'Program')
				AND       Period      = '#Period#'			
				AND       PeriodHierarchy = '#hier#'
				AND       OrgUnit IN (SELECT OrgUnit 
				                      FROM   Organization.dbo.Organization WHERE Mission = '#mission#') 
			</cfquery>		
						
			<cfif get.recordcount eq "1">
			
				<cfset program = get.ProgramCode>
							
			</cfif>	
		
		</cfloop>
				
		<!--- ----------------------------------------- --->					
		<!--- obtain the parent orgunit of this program --->
		<!--- ----------------------------------------- --->	
		
		<cfquery name="get" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProgramPeriod
			WHERE     ProgramCode = '#ProgramCode#'
			AND       Period      = '#Period#'			
		</cfquery>				
		
		<cfquery name="orgUnit" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     P.OrgUnit, P.Mission
			FROM       Organization AS O INNER JOIN
                       Organization AS P ON O.ParentOrgUnit = P.OrgUnitCode AND O.Mission = P.Mission AND O.MandateNo = P.MandateNo
			WHERE      O.OrgUnit = '#get.OrgUnit#'			
		</cfquery>	
		
		<cfset orgunit = orgUnit.OrgUnit>
						
		<cfquery name="get" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProgramGroup
			WHERE     ProgramCode = '#ProgramCode#'					
		</cfquery>	
		
		<cfset group = "#valueList(get.ProgramGroup)#"> 
				
		<!--- get all the list of categories --->
		
		<cfif ControlObject eq "Ref_ProgramCategory">
				
		<cfquery name="List" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_ProgramCategory
			WHERE     Code IN     (SELECT    Code
                                   FROM      Ref_ProgramCategory 
                                   WHERE     AreaCode = '#areacode#')
			ORDER BY HierarchyCode
			
		</cfquery>	
		
		<cfelse>
		
			<cfquery name="List" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *, Code as HierarchyCode
				FROM      Ref_ProgramFinancial	
				ORDER BY ListingOrder		
			</cfquery>	
				
		</cfif>

		<cfset elements = "">
		
		<!--- we check if filter is set for this CODE and functional ELEMENT  --->
				
		<cfloop index="itm" list="period,orgunit,program,group">
		
				<cfquery name="getControl" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      #ControlObject#Control
						WHERE     Code           IN (SELECT Code 
						                             FROM   Ref_ProgramCategory 
													 WHERE AreaCode = '#areacode#')
						AND       Mission        = '#mission#'
						AND       ControlElement = '#itm#'						
				 </cfquery>
				 
				 <cfif getControl.recordcount gte "1">
				 
					 <cfif elements eq "">
						 <cfset elements = "#itm#">
					 <cfelse>
					 	<cfset elements = "#elements#,#itm#">	 
					 </cfif>
				 
				 </cfif>
		
		</cfloop>
				
		<cfif elements neq "">
		
			<cfloop index="itm" list="#elements#">
			
				<cfset deny = "">
				<cfset denyhier = "9999">
					
				<cfoutput query="List">
								
				    <!--- ATTENTION we need  cater for the fact that a program can have multiple GROUP assigned
					     so we need to loop through each group value --->
						 				
				    <cfset pass = "1">					
							
					<cfif find(denyhier,hierarchycode)>
					
						<!--- the higher level is denied so also the deeper level will --->
																													
						<cfset pass = "0">		
													
														
					<cfelse>				
															 															 				 					 					 					 
						<!--- we have filters set for this category AREA and ELEMENT (Period)
						so now we check if it applies for the underlying range of topics 
						the selected ELEMENT-VALUE value (FY17) --->
								
						<cfset val = evaluate(itm)>
								 
						<cfquery name="getControl" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      #ControlObject#Control
								WHERE     Code           IN (SELECT Code 
								                             FROM   Ref_ProgramCategory 
															 WHERE  AreaCode = '#areacode#' 
															 AND    HierarchyCode LIKE '#HierarchyCode#%')
								AND       Mission        = '#mission#'
								AND       ControlElement = '#itm#'								
								<cfif itm eq "Period">
								AND       ControlValue   = '#val#'
								</cfif>
						 </cfquery>
								
						 <cfif getControl.recordcount eq "0">
																																									
								<!--- not explicitly enabled so the higher category level will rule not changes in the deny --->
								
						 <cfelse>
						 
						 		<!--- we have records for this hierarchy now we check if it is enabled --->
						 															
									<cfquery name="getDetailControl" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    *
										FROM      #ControlObject#Control
										WHERE     Code           IN (SELECT Code 
								                             FROM   Ref_ProgramCategory 
															 WHERE  AreaCode = '#areacode#' 
															 AND    HierarchyCode LIKE '#HierarchyCode#%')
										AND       Mission        = '#mission#'
										AND       ControlElement = '#itm#'
										AND       ControlValue   = '#val#'
								    </cfquery>									
																
									<cfif getDetailControl.ControlMode eq "0" or getDetailControl.recordcount eq "0">		
																	
										<cfset pass = "0">
										<cfset denyhier = HierarchyCode>																																					
									
									</cfif>														
												 
							 	</cfif>											
							
							</cfif>				
																					
						<cfif pass eq "0">
																		
						      <cfif deny eq "">
							  	<cfset deny = "'#code#'">
							  <cfelse>
								<cfset deny = "#deny#,'#code#'">
							  </cfif>	
							  
						</cfif>
											
				</cfoutput>
			
			</cfloop>		
		
		</cfif>		
		   
	   <cfreturn deny>		
		 
   </cffunction>   
  		
</cfcomponent>	 