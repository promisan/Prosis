
<cfparam name="Attributes.Distributionid"  default = "#url.distribid#"> 
<cfparam name="Attributes.Name"            default = "rptQuery"> 
<cfparam name="Attributes.UserName"        default = "#SESSION.login#"> 
<cfparam name="Attributes.Password"        default = "#SESSION.dbpw#"> 
<cfparam name="Attributes.Datasource"      default = ""> 
<cfparam name="Attributes.Stats"           default = "Yes"> 
<cfparam name="Attributes.Progress"        default = "1"> 
<cfparam name="Attributes.ProgressSteps"   default = "1"> 
<cfparam name="Attributes.ProgressLabel"   default = ""> 
<cfparam name="Attributes.Output"          default = "table"> 

<cfif Attributes.ProgressSteps lt Attributes.Progress>
	<cfset steps = attributes.Progress>
<cfelse>
	<cfset steps = Attributes.ProgressSteps>	
</cfif>
			
<cfif thisTag.ExecutionMode is "start">	
	
	<cfif attributes.distributionid neq "" and attributes.Progress gte "1">	
	
		<cfquery name="get" 
				 datasource="#Attributes.Datasource#"				  
				 username="#Attributes.UserName#" 
				 password="#Attributes.Password#">				
				 SELECT *  
				 FROM   System.dbo.UserReportDistribution
				 WHERE  DistributionId = '#Attributes.DistributionId#'
			</cfquery>	
			
		<cf_Wait text= "#attributes.ProgressLabel#" 
		         progress   = "#attributes.progress#" 
				 total      = "#steps#"				 
				 controlid  = "#get.controlid#">
	
	</cfif>
		
<cfelse>	
   			
	<!--- execute the query and log it and add stats --->	
			
	<cfinvoke component="Service.Audit.AuditReport"
	   method 	      = "LogQuery"
	   distributionId = "#Attributes.DistributionId#"
	   name           = "#Attributes.Name#"
	   query          = "#thisTag.GeneratedContent#"
	   username       = "#Attributes.UserName#" 
	   password       = "#Attributes.Password#"
	   datasource     = "#Attributes.Datasource#"
	   stats          = "#Attributes.Stats#" 	 
	   output         = "#Attributes.Output#" 
	   returnvariable = "result_#Attributes.Name#">
	
	<cfif Attributes.Output eq "Query">
		<cfset "caller.#Attributes.Name#" = evaluate('result_#Attributes.Name#')>
	</cfif>   
						
</cfif>
		
	