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

<cftree name="root"
   font="tahoma"
   fontsize="11"		
   bold="No"   
   format="html"    
   required="No">   
   
   <cfif attributes.master eq "1">
	   <cfset exp = "No">
	<cfelse>
	   <cfset exp = "Yes">
	</cfif>
	
	<!--- disabled as this moved to the support portal
   
   <cftreeitem value="mod"
        display="Requests for Modification"
		parent="Root"	
		img="#SESSION.root#/Images/folder_close.png"
		imgopen="#SESSION.root#/Images/folder_open.png"						
        expand="#exp#">	
						
		<!--- check access granted within the workflow for this person --->
				
		<cfquery name="Status" 
			  datasource="AppsOrganization">
		      SELECT *
			  FROM   Ref_EntityStatus
			  WHERE  EntityCode = 'SysChange'	 
		</cfquery>	
				
		<cfif Status.recordcount eq "0">
		
			<cfquery name="Status" 
			  datasource="AppsOrganization">
		      INSERT INTO Ref_EntityStatus
			  (EntityCode,EntityStatus,StatusDescription)
			  VALUES
			  ('SysChange','0','Pending')	 
			</cfquery>	
			
			<cfquery name="Status" 
			  datasource="AppsOrganization">
		      INSERT INTO Ref_EntityStatus
			  (EntityCode,EntityStatus,StatusDescription)
			  VALUES
			  ('SysChange','1','Testing')	 
			</cfquery>	
			
			<cfquery name="Status" 
			  datasource="AppsOrganization">
		      INSERT INTO Ref_EntityStatus
			  (EntityCode,EntityStatus,StatusDescription)
			  VALUES
			  ('SysChange','2','Completed')	 
			</cfquery>	
			
			<cfquery name="Status" 
			  datasource="AppsOrganization">
		      INSERT INTO Ref_EntityStatus
			  (EntityCode,EntityStatus,StatusDescription)
			  VALUES
			  ('SysChange','9','Cancelled')	 
			</cfquery>	
		
		</cfif>
	
		<cfinvoke component = "Service.Access"  
			method           = "ShowEntity" 
			entityCode       = "SysChange"				
			returnvariable   = "access">
			
		<cfif access eq "READ" or access eq "EDIT" or access eq "ALL">				
						
					<cfquery name="Status" 
					  datasource="AppsOrganization">
				      SELECT *
					  FROM   Ref_EntityStatus
					  WHERE  EntityCode = 'SysChange'						 
					</cfquery>		
					
					<cfoutput query="Status">							
								
						<cftreeitem value="mod_#EntityStatus#"
					        display="#StatusDescription#"
							href="../Modification/ModificationViewView.cfm?context=status&contextid=#EntityStatus#"		
							img="#SESSION.root#/Images/select.png"
							target="right"	
							parent="mod"								
					        expand="no">	
											
					</cfoutput> 	
					
		</cfif>		
		
	--->	
		
	<!--- production sites --->
		
		<cfquery name="Mast" 
		  datasource="AppsControl">
		      SELECT * FROM ParameterSite
			  WHERE ServerRole = 'QA'
		</cfquery>
		
	<cfif attributes.master eq "1">
		
		<cftreeitem value="Master"
			        display="Master (#Mast.ApplicationServer#)"
					parent="Root"			
					img="computer"					
			        expand="Yes"
					target="right"
					href="#SESSION.root#/Tools/Template/TemplateCheck.cfm">	
		<!--- year, month, moments --->
		
		<cfquery name="Site" 
		  datasource="AppsControl">
		      SELECT * FROM ParameterSite
			  WHERE ServerRole = 'Design'
			  AND Operational = 1 
			  ORDER BY ServerLocation
		</cfquery>
		
		<cfif Site.recordcount gt 0>
		
			<cftreeitem value="Design"
			        display="Design"
					parent="Root"			
					img="computer"					
			        expand="Yes">	
					
		</cfif>
					
		<cfoutput query="Site">
		  
		  	  <!--- show this site only if the user has access to this server for the entity Release --->	
		  
			  <cfinvoke component = "Service.Access"  
						method           = "ShowEntity" 
						entityCode       = "Release"
						entityGroup      = "#ApplicationServer#"
						returnvariable   = "access">
						
				<cfif access eq "EDIT">		
			  
					  	<cfif serverlocation eq "remote">
						   <cfset icn = "#SESSION.root#/Images/world.gif">
						<cfelse>
						   <cfset icn = "#SESSION.root#/Images/weblink2.gif"> 		  
						</cfif>
			  	 
						<cftreeitem value="site#applicationServer#"
				        display="#applicationServer# (#ServerLocation#)"
						parent="Design"					
						expand="no"
						img="#SESSION.root#/Images/cf.png">
						
												
						<cftreeitem value="site#applicationServer#dir"
					        display="Directories"
							parent="site#applicationServer#"
							target="right"
							expand="yes"
							href="TemplateFilter.cfm?site=#applicationserver#"
							img="folder">						
													 
						<cfquery name="Group" 
						  datasource="AppsControl">
						      SELECT * 
							  FROM   ParameterSiteGroup
							  WHERE  ApplicationServer = '#applicationserver#'						
						</cfquery> 
						
						<cfloop query="group">
									
							 <cftreeitem value="#templategroup#"
					        display="#templategroup#/"
							parent="site#applicationServer#dir"
							target="right"				
							img="#SESSION.root#/Images/select.png"
							href="TemplateFilter.cfm?site=#applicationserver#&group=#templategroup#">
									
						</cfloop>
						
				</cfif>		
				 			   		 
		</cfoutput>					
							
		<!--- production --->
		
		<cfquery name="Site" 
		  datasource="AppsControl">
		      SELECT * FROM ParameterSite
			  WHERE ServerRole = 'Production'
			  AND Operational = 1 
			  ORDER BY ServerLocation
		</cfquery>
		
		<cftreeitem value="Production"
			        display="Production"
					parent="Root"			
					img="computer"					
			        expand="Yes">	
		
		  <cfoutput query="Site">
		  
		  	  <!--- show this site only if the user has access to this server for the entity Release --->	
		  
			  <cfinvoke component = "Service.Access"  
						method           = "ShowEntity" 
						entityCode       = "Release"
						entityGroup      = "#ApplicationServer#"
						returnvariable   = "access">
						
				<cfif access eq "EDIT">		
			  
					  	<cfif serverlocation eq "remote">
						   <cfset icn = "#SESSION.root#/Images/world.gif">
						<cfelse>
						   <cfset icn = "#SESSION.root#/Images/weblink2.gif"> 		  
						</cfif>
			  	 
						<cftreeitem value="site#applicationServer#"
				        display="#applicationServer# (#ServerLocation#)"
						parent="Production"					
						expand="no"
						img="#SESSION.root#/Images/cf.png">
						
						<cfif ServerLocation eq "Local">
						
								<cftreeitem value="site#applicationServer#dir"
					        display="Directories"
							parent="site#applicationServer#"
							target="right"
							expand="yes"
							href="TemplateFilter.cfm?site=#applicationserver#"
							img="folder">
						
						<cfelse>
						
							<cftreeitem value="site#applicationServer#rel"
					        display="Release Packages"
							parent="site#applicationServer#"
							target="right"
							expand="no"
							href="TemplateRelease.cfm?site=#applicationserver#"
							img="#SESSION.root#/Images/package.gif">
							
							<cftreeitem value="site#applicationServer#dir"
					        display="Directories"
							parent="site#applicationServer#"
							target="right"
							expand="no"
							href="TemplateFilter.cfm?site=#applicationserver#"
							img="folder">
							
						</cfif>	
													 
						<cfquery name="Group" 
						  datasource="AppsControl">
						      SELECT * 
							  FROM   ParameterSiteGroup
							  WHERE  ApplicationServer = '#applicationserver#'						
						</cfquery> 
						
						<cfloop query="group">
									
							 <cftreeitem value="#templategroup#"
					        display="#templategroup#/"
							parent="site#applicationServer#dir"
							target="right"				
							img="#SESSION.root#/Images/select.png"
							href="TemplateFilter.cfm?site=#applicationserver#&group=#templategroup#">
									
						</cfloop>
						
				</cfif>		
				 			   		 
		</cfoutput>
		
	</cfif>	
	
	<!--- versions --->
	
	<!--- year, month, moments --->
	
	<cfquery name="Base" 
	  datasource="AppsControl">
	      SELECT Min(VersionDate) as Base
	      FROM Ref_TemplateContent
		  WHERE ApplicationServer = '#mast.applicationServer#' 
		  AND   VersionDate is not NULL
	</cfquery>
	
	<cfquery name="Year" 
	  datasource="AppsControl">
	      SELECT DISTINCT YEAR(VersionDate) as Year
	      FROM   Ref_TemplateContent
		  WHERE  VersionDate is not NULL
		  AND    ApplicationServer = '#mast.applicationServer#' 
		  ORDER BY Year DESC
	</cfquery>
	
	<cfoutput>
					
		<cftreeitem value="Release"
		        display="Code Tracker"
				parent="Root"			
				img="#SESSION.root#/Images/folder_close.png"
			    imgopen="#SESSION.root#/Images/folder_open.png"			
		        expand="No">	
				
		 <cftreeitem value="Filter"
		        display="Search"
				parent="Release"	
				href="TemplateFilter.cfm?filter=1"		
				target="right"
				img="#SESSION.root#/Images/16/table.png"
				imgopen="#SESSION.root#/Images/16/table.png"				
		        expand="No">	 		
						
	
	  <cfloop query="Year">
	  
	  	<cfset yr = Year.year>
	  
		  <cftreeitem value="#yr#"
		        display="#Yr#"
				parent="Release"			
				img="element"
				imgopen="element"				
		        expand="No">	 
	    
			 <cfquery name="Month" 
			  datasource="AppsControl">
			      SELECT DISTINCT Month(VersionDate) as Month 
			      FROM Ref_TemplateContent
				  WHERE YEAR(VersionDate) = #yr#
				   AND   VersionDate is not NULL
				   AND    ApplicationServer = '#mast.applicationServer#'
				  ORDER BY Month DESC
			 </cfquery>
		  	         	   	  	  
		 <cfloop query="Month">
		 
		    <cfset mt  = Month.Month>
		    <cfset mtS = monthAsString(Month.Month)>
			
			 <cftreeitem value="#mt#"
		        display="#mtS#"
				parent="#yr#"			
				img="#SESSION.root#/Images/date.gif"				
		        expand="No">		
					
			 <cfquery name="Date" 
			    datasource="AppsControl">
			      SELECT DISTINCT DAY(VersionDate) as DAY, VersionDate
			      FROM Ref_TemplateContent
				  WHERE YEAR(VersionDate) = #yr#
				  AND   MONTH(VersionDate) = #mt# 
				  AND   VersionDate != '#dateFormat(Base.Base,client.DateSQL)#'
				  AND   VersionDate is not NULL
				  AND   ApplicationServer = '#mast.applicationServer#' 
				  ORDER BY DAY DESC
			   </cfquery>	
		   
			    <cfloop query="Date">
				
				    <cfset dy   = Day>
							   
				    <cfif len(dy) eq "1">
					  <cfset dy = "0#dy#">
					</cfif>
				   		    
					<cfset dyS  = dayOfWeek(VersionDate)>
					<cfset dyS  = dayOfWeekAsString(dyS)>
					
					<cftreeitem value="#mts##dy#"
			        display="#dy#:#dys#"
					parent="#mt#"
					target="right"
					img="#SESSION.root#/Images/select.png"
					href="TemplateFilter.cfm?version=#VersionDate#">
				 		
				</cfloop>  
			
			</cfloop>  
						   
		   </cfloop>  
		   		 
	</cfoutput>
	
</cftree>