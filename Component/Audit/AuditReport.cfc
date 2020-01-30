
  <cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "AuditReport">
		
	<cffunction name="LogReport" access="remote" returntype="string" displayname="Header">
					 
		    <cfargument name="SystemModule"        type="string" required="yes"   default="System">		
			<cfargument name="FunctionName"        type="string" required="yes"   default="">		 
			<cfargument name="LayoutClass"         type="string" required="yes"   default="">		
			<cfargument name="LayoutName"          type="string" required="yes"   default="">		 
			<cfargument name="FileFormat"          type="string" required="yes"   default="">		 
			<cfargument name="ControlId"           type="string" required="no">		 
			<cfargument name="ReportId"            type="string" required="no">		 
			<cfargument name="DistributionId"      type="GUID"   required="yes">		 
			<cfargument name="DistributionPeriod"  type="string" required="no"    default="">		 
			<cfargument name="DistributionName"    type="string" required="no"    default="">		 
			<cfargument name="DistributionSubject" type="string" required="no"    default="">		 
			<cfargument name="DistributioneMail"   type="string" required="no"    default="">		 
			<cfargument name="Category"            type="string" required="yes"   default="">		 
			<cfargument name="StatusMode"          type="string" required="yes"   default="">		 
			<cfargument name="Status"              type="string" required="yes"   default="1">		 
			<cfargument name="UserId"              type="string" required="yes"   default="">		
						 									  		   
			<cfquery name="Log" 
			 datasource="AppsSystem">
			 INSERT INTO UserReportDistribution 		
					 (DistributionId,
					  ReportId, 
					  ControlId, 
					  SystemModule,
					  FunctionName,
					  LayoutClass,
					  LayoutName,
					  FileFormat,
					  Account,
					  HostName,
					  NodeIP,
					  PreparationStart,
					  <cfif StatusMode neq "Form">
						  DistributionPeriod,
						  DistributionName, 
						  DistributionSubject, 
						  DistributionEMail, 
					  </cfif>
					  DistributionCategory,
					  DistributionStatus,
					  OfficerUserid, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 VALUES ( '#DistributionId#',
			          '#ReportId#',
			          '#ControlId#', 
			      	  '#SystemModule#',
					  '#FunctionName#',
					  '#LayoutClass#',
					  '#LayoutName#',
					  '#FileFormat#',
					  '#SESSION.acc#',
					  '#CGI.HTTP_HOST#',
					  '#CGI.Remote_Addr#',
					  getDate(),
					  <cfif StatusMode neq "Form">
						  '#DistributionPeriod#',
					      '#DistributionName#',
					      '#DistributionSubject#',
						  '#DistributionEMail#', 
					  </cfif>
					  '#category#',
					  '#Status#',
					  '#UserId#', 
					  '#SESSION.last#',
					  '#SESSION.first#') 
			</cfquery>			
						 
	</cffunction>		
		
	<cffunction name="EndReport"
             access="remote"
             displayname="Header">
			 
			<cfargument name="DistributionId"  type="GUID"  required="yes">		 
							
			<cfquery name="Log" 
					 datasource="AppsSystem">
					 UPDATE UserReportDistribution 		
					 SET    PreparationEnd          = getDate(), 	
					        PreparationMillisecond  = DATEDIFF(millisecond,PreparationStart,getDate()), 				        
					        DistributionStatus      = 1
					 WHERE  DistributionId = '#DistributionId#'
			</cfquery>	 
		 					
		<cfset SESSION.Status = "1.0">
			 
	</cffunction>	
	
	<!--- log general query --->	
	
	<cffunction name="LogQuery"
             access="remote"
             returntype="any"
             displayname="Header"
             output="yes">
			 
	<cfargument name="DistributionId" type="GUID"   required="yes">		 
	<cfargument name="Name"           type="string" required="yes">			 
	<cfargument name="Query"          type="string" required="yes">			 
	<cfargument name="Datasource"     type="string" required="yes"  default="AppsSystem">		
	<cfargument name="UserName"       type="string" default="#SESSION.login#">	
	<cfargument name="Password"       type="string" default="#SESSION.dbpw#">	
	<cfargument name="Stats"          type="string" default="Yes"   required="no">			
	<cfargument name="Output"         type="string" default="query" required="no">
	
	<cfset Preps = now()>

	<!--- ----------------- --->
	<!--- perform the query --->
	<!--- ----------------- --->
		
	<cftransaction isolation="read_uncommitted">
	
		<cfquery name  = "thisQuery" 
			username   = "#UserName#" 
	    	password   = "#Password#"
	    	datasource = "#Datasource#">
			#preserveSingleQuotes(query)#
		</cfquery>
		
	</cftransaction>	  	
		
	<cfif Stats neq "">
	
			<cftry>
				
			   <cfquery name="rec" 
				 datasource="#Datasource#">
				 SELECT count(*) as total 
				 FROM #stats#
			   </cfquery>	
			   
			   <cfset records = rec.total>
		   
			   <cfcatch>			   
			   		<cfset records = "0">						
			   </cfcatch>
		   
		   </cftry>
		   
	<cfelse>	
			<cfset records = "0">	   	
	</cfif>	
		
	<cfset ms = cfquery.executionTime>	
		
			<cfquery name="Last" 
			username   = "#UserName#" 
	    	password   = "#Password#"
	    	datasource = "#Datasource#">
				SELECT   TOP 1 DistributionSerialNo as SerialNo
				FROM     System.dbo.UserReportDistributionQuery
				WHERE    DistributionId = '#distributionid#'
				ORDER BY DistributionSerialNo DESC
			</cfquery>

			<cfif Last.SerialNo eq "">
			  <cfset serNo = 1>
			<cfelse>	
			  <cfset serNo = Last.SerialNo+1>
			</cfif>

			<cfquery name="Capture" 			
			username   = "#UserName#" 
	    	password   = "#Password#"
	    	datasource = "#Datasource#">
			INSERT INTO System.dbo.UserReportDistributionQuery
				(distributionId,
				 distributionSerialNo,
				 queryName,
				 queryContent,
				 queryStart,
				 queryEnd,
				 queryMilliSecond,
				 queryOutputTable,
				 queryOutputRecord)
			VALUES  
			   ('#DistributionId#',
			    '#serNo#',
			    '#Name#',
				'#Query#',
				#preps#,
				getDate(),
				#ms#,
				'#stats#',
				#records#)
			</cfquery>
				
		<cfif output eq "Query">
			<cfreturn ThisQuery>
		</cfif>		
										 
	</cffunction>	
			
  </cfcomponent> 