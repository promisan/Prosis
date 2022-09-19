
<!--- 1. logfile for user --->
<!--- 2. find table name --->

<cfcomponent output="false">	
		  
     <cffunction name="getLog"
             access="remote"
             displayname="Report Run Log File">
	 
	      <cfargument name="page" required="yes">
	      <cfargument name="pageSize" required="yes">
	      <cfargument name="gridsortcolumn" required="yes">
	      <cfargument name="gridsortdirection" default="DESC" required="yes">
		  <cfargument name="reportid" default="{00000000-0000-0000-0000-000000000000}" required="yes">
		  <cfargument name="controlid" default="{00000000-0000-0000-0000-000000000000}" required="yes">
		  <cfargument name="acc" default="administrator" required="yes">
	
		  <cfquery name="loginfo" 
				   datasource="AppsSystem">
						SELECT    convert(varchar,Created,111) as Datestamp, 
			   					  convert(varchar,Created,108) as Timestamp,
						          DistributionEMail, 
								  DistributionSubject,
								  DistributionCategory, 
								  LayoutName,
								  FileFormat,
								  DATEDIFF(ms, PreparationStart, PreparationEnd) AS Duration,
								  OfficerUserId,
								  OfficerFirstName+' '+OfficerLastName as Contact
						FROM      UserReportDistribution
						WHERE    (ReportId = '#reportId#' 
						     AND ReportId != '{00000000-0000-0000-0000-000000000000}')
						OR       (ControlId = '#ControlId#' 
						     AND Account = '#acc#' 
							 AND ReportId = '{00000000-0000-0000-0000-000000000000}') 					 
						<cfif gridsortcolumn neq ''>
	      						order by #gridsortcolumn# #gridsortdirection#
						</cfif>
		   </cfquery>  	          
		   <cfreturn queryconvertforgrid(loginfo,page,pagesize)/>
	   
	 </cffunction>
	 
	 <cffunction name="getTable"
             access="remote"
             returntype="string"
             displayname="Report Run Log File">
	 
	      <cfargument name="ds" required="yes">
	      <cfargument name="search" required="yes">
	     
 		  <cfquery name="Parameter" 
				   datasource="AppsSystem">
		 
					 SELECT ControlServer
					 FROM   System.dbo.Parameter
					 
		  </cfquery>

		  <cfquery name="tables" 
				datasource="#ds#" 
				maxrows="7">
					SELECT TableName
					FROM
						(
							SELECT	TableName
							<cfif Parameter.ControlServer neq "">
								FROM 	[#Parameter.ControlServer#].Control.dbo.DictionaryTable
							<cfelse>
								FROM 	Control.dbo.DictionaryTable
							</cfif>
							WHERE  	DataSource = '#ds#' 
							AND  	TableName LIKE '#search#%'
							
							UNION
							
							SELECT 	Name as TableName
							FROM 	Sysobjects
							WHERE 	Type = 'V'
							AND  	Name LIKE '#search#%'
						) as Data
					ORDER BY TableName	 
						
		   </cfquery> 

		   <cfreturn ValueList(tables.TableName)/>
	   
	 </cffunction>
	 
	 
	 <cffunction name="getfield"
             access="remote"
             returntype="array"
             displayname="Custom Workflow fields">
	 
	      <cfargument name="documentid" required="yes">
	      <cfargument name="search"     required="yes">
		  
		  <cfquery name="custom" 
				   datasource="AppsOrganization">
						SELECT    *
						FROM      Ref_EntityDocument
						WHERE     DocumentId = '#documentid#'  									
		   </cfquery>  
		 
		  
		   <cfquery name="data" 
				datasource="#custom.LookupDataSource#">
				    SELECT DISTINCT TOP (20)  #custom.LookupFieldName# as Name	        
					FROM   #custom.LookupTable#		
							
					WHERE #custom.LookupFieldName# LIKE '%#search#%' 
					ORDER BY #custom.LookupFieldName#  				
			</cfquery>
			
			<cfset var provideArray = ArrayNew(1)>   

		    <cfloop query="data">   
		
		        <cfset arrayAppend(provideArray, Name)>   
		
		    </cfloop> 						
		   
		    <cfreturn #providearray#/>
	   
	 </cffunction>
	 
	 <cffunction name="gettemplate"
             access="remote"
             returntype="string"
             displayname="List termplate">
	 	      
	      <cfargument name="search" required="yes">
	     
		  <cfquery name="templates" 
				datasource="AppsControl">
					SELECT   TOP 20 REPLACE(substring(PathName, 2, 100), '\', '/')+'/'+FileName as myFile
					FROM     Ref_Template
					WHERE    PathName <> '[root]'
					GROUP BY PathName,FileName	
					HAVING   REPLACE(substring(PathName, 2, 100), '\', '/')+'/'+FileName LIKE '#search#%'
					ORDER BY PathName,FileName	 						
		   </cfquery>  	
		 		  		   
		   <cfreturn ValueList(templates.myFile)/>
	   
	 </cffunction>
	 
	 
	 <cffunction name="getlookup"
             access="remote"
             returntype="string"
             displayname="Report Run Log File">
	 
	      <cfargument name="controlid" required="yes">
	      <cfargument name="criteriaName" required="yes">
		  <cfargument name="search" required="yes">
		  
		  <cfquery name="criteria" 
				   datasource="AppsSystem">
						SELECT    *
						FROM      Ref_ReportControlCriteria
						WHERE     ControlId = '#controlid#' 
						     AND  CriteriaName = '#criterianame#'					
		   </cfquery>  	 
	     
		   <cfquery name="data" 
				datasource="#criteria.LookupDataSource#"
				maxrows="5">
				    SELECT DISTINCT TOP 5 #criteria.LookupFieldValue# as PK					        
					FROM   #criteria.LookupTable#		
					WHERE  #criteria.LookupFieldValue# LIKE '#search#%'		
					ORDER BY #criteria.LookupFieldValue#		
			</cfquery>
			
		   <cfreturn ValueList(data.PK)/>
	   
	 </cffunction>	
	 
	 <cffunction name="getlistingsuggest"
             access="remote"
             returntype="any"
             displayname="Report Run Log File">
	 
	      <cfargument name="dsn"              required="yes">
	      <cfargument name="query"            required="yes">
	      <cfargument name="field"            required="yes">		
		  <cfargument name="systemfunctionid" required="yes"  default="">
		  <cfargument name="functionserialno" required="yes"  default="">
		  <cfargument name="search"           default="yes"   required="yes">
		  <cfargument name="topselect"        default="2"     required="no">
		  <cfargument name="mode"             default="combo" required="no">
	      <cfargument name="requester"        required="yes"  default="standard">
		  
		  <cfset qry = replace(query,"|","'","ALL")>
		  <cfset qry = replace(qry,";",",","ALL")>
		  <cfset qry = replace(qry,"&","=","ALL")>
		  		 		  		  		  		  
		  <cfif systemfunctionid neq "">
		  								
				<cfquery name="Header" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ModuleControlDetail
					WHERE  SystemFunctionId = '#SystemFunctionId#'
					AND    FunctionSerialNo = '#functionserialno#'
				</cfquery>
										
				<cftry>				
						
						<cfset fileNo = "#Header.DetailSerialNo#">							
						<cfinclude template="../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">
						
						<cfloop index="t" from="1" to="10">		
							 <cfset qry = replaceNoCase("#qry#","@answer#t#","#evaluate('answer#t#')#")> 			  
					    </cfloop>
							
						<cfquery name="preset" 
							datasource="#dsn#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 			
							#preserveSingleQuotes(qry)# 	
						</cfquery>	
								
						<cfcatch>
						
							<!--- generate the files if needed --->
					
							<cfinclude template="../../System/Modules/InquiryBuilder/QueryPreparation.cfm">	
											
							<!--- outputting --->
									
							<cfquery name="preset" 
								datasource="#dsn#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 			
								#preservesinglequotes(qry)#		
							</cfquery>		
									
						</cfcatch>
					
					</cftry>	
					
					<cfif mode eq "Combo">
										
						<cfquery name="data"
				         maxrows="#topselect#"
			    	     dbtype="query">
						   SELECT   DISTINCT #field# AS PK
						   FROM     preset
						   WHERE    lower(#field#) LIKE '#LCase(search)#%' 
						   ORDER BY #field#
					    </cfquery>	
					
					<cfelse>
					
						<cfquery name="data"
				         maxrows="#topselect#"
			    	     dbtype="query">
						   SELECT   DISTINCT #field# AS PK   
						   FROM     preset						  
						   ORDER BY #field#
					    </cfquery>						
					
					</cfif>
					
			<cfelseif requester eq "Listing">		
						
				 <cfoutput>
			 
				  	<cfsavecontent variable="testme">	
					
					   #preserveSingleQuotes(qry)# 	  
					   
					   ------------------------------
					   
			           SELECT   DISTINCT #field# AS PK   
					   FROM     preset						  
					   ORDER BY #field#
					   
					</cfsavecontent>
											 
					<cffile action="WRITE" 
						file="#SESSION.rootpath#/test.txt" 
						output="#testme#" 
						addnewline="Yes" 
						fixnewline="No"> 											
													
				</cfoutput>	
										
				<cfquery name="preset" 
					datasource="#dsn#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#"> 			
					#preserveSingleQuotes(qry)# 	
				</cfquery>	
				
				<cfif mode eq "Combo">
										
					<cfquery name="data"
				        maxrows="#topselect#" dbtype="query">
						   SELECT   DISTINCT #field# AS PK
						   FROM     preset
						   WHERE    lower(#field#) LIKE '#LCase(search)#%' 
						   ORDER BY #field#
				    </cfquery>	
					
				<cfelse>
					
					<cfquery name="data"
				        maxrows="#topselect#"
			    	    dbtype="query">
						   SELECT   DISTINCT #field# AS PK   
						   FROM     preset						  
						   ORDER BY #field#
					</cfquery>						
					
				</cfif>							
				
			<cfelse>
			
				<!--- outputting --->												
			   				
				<cfif mode eq "Combo">
						
				  <cfquery name="data"
				      datasource="#dsn#" 
					  username="#SESSION.login#" 
  					  password="#SESSION.dbpw#">
					  	 SELECT   DISTINCT top #topselect# #field# AS PK
						 #preservesinglequotes(qry)#	
					     WHERE    lower(#field#) LIKE '#LCase(search)#%' 
					     ORDER BY #field#
				   </cfquery>	
				   
				  <cfelse>
				  
				  	<cfquery name="data"
				         maxrows="#topselect#"
			    	     dbtype="query">
						   SELECT   DISTINCT top #topselect# #field# AS PK
							        #preservesinglequotes(qry)#					  
						   ORDER BY #field#
					 </cfquery>	
				  
				</cfif> 				
																	
		</cfif>
			
		<cfif mode eq "Combo">	
									
		   		<cfreturn ValueList(data.PK)/>
		   
		<cfelse>
		   
		   	  <cfset mylist = arraynew(2)>
			  	  			  		  
			  <cfset mylist[1][1]= "">
	       	  <cfset mylist[1][2]= "">
										  
			  <!--- Convert results to array --->
	      	  <cfloop index="i" from="1" to="#data.RecordCount#">
			   	 <cfset mylist[i+1][1]= data.PK[i]>
	        	 <cfset mylist[i+1][2]= data.PK[i]>												 
	      	  </cfloop>
			  
			  <cfreturn mylist>		   
		   
		</cfif>
	   
	 </cffunction>	
	 
	 <!---
	 
	 <cffunction name="getmail"
             access="remote"
             returntype="string"
             displayname="EMail listing">
	 
	      <cfargument name="mode" required="yes" default="address">
		  <cfargument name="criteriaName" required="yes">
	     		  
		  <cfquery name="mail" 
				   datasource="AppsSystem">
						SELECT    TOP 20 Fullname+' ('+emailaddress+')' as PK
						FROM      AddressBook
						WHERE     FullName LIKE '%#criterianame#%'					
		   </cfquery>  	 
	     		
		   <cfreturn ValueList(mail.PK)/>
	   
	 </cffunction>
	 
	 --->
	 	   
</cfcomponent>