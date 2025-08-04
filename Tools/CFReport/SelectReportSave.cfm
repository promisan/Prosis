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

<cfparam name="url.global"            default="0">
<cfparam name="url.formselect"        default="insert">
<cfparam name="form.FileFormat"       default="">
<cfparam name="form.DistributionMode" default="">
<cfparam name="url.SaveRefresh" 	  default="1">

<cfquery name="Report" 
  datasource="AppsSystem"
  maxrows=1 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT * 
  FROM   Ref_ReportControl R, Ref_ReportControlLayout L
  WHERE  R.ControlId = L.ControlId
  AND    L.LayoutId = '#Form.LayoutId#'
</cfquery>

<cfparam name="Form.DistributionDOM" default="0">

<cfloop index="day" from="1" to="7">
	<cfparam name="Form.DistributionDOW#day#" default="">
</cfloop>
	
<cfset DOW = "">
<cfloop index="day" from="1" to="7">
    <cfset val = Evaluate("Form.DistributionDOW" & #day#)>
	<cfif val gte "1">
	    <cfset DOW = "#DOW#|#day#">
	</cfif>
</cfloop>

<!--- define the mode --->

<cfquery name="Parameter" 
  datasource="AppsSystem"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter 
</cfquery>

<cfset autserver = "[#Parameter.AuthorizationServer#]">

<cfif Report.FunctionClass eq "System">
   <cfset subscrip = "0">
<cfelseif SESSION.acc eq "#Parameter.AnonymousUserId#">  
   <cfset subscrip = "0">
<cfelse>
   <cfset subscrip = "1">  
</cfif>

<cfif Report.LayoutClass eq "View">
	 <cfset format = "#Form.FileFormat#">	 
	 <cfif Report.EnableAttachment eq "0">
		  <cfset distribution = "Hyperlink"> 
	 <cfelse>
	      <cfset distribution = "#Form.DistributionMode#"> 	  
	 </cfif>
<cfelse>
	  <cfset format = "#Form.FileFormat#">
	  <cfset distribution = "#Form.DistributionMode#"> 
</cfif>

<cfif subscrip eq "1">

	<cfset dateStart = "">
	<CF_DateConvert Value="#Form.DistributionDateEffective#">
	<cfset dateStart = dateValue>
	
	<cfset dateEnd = "">
	<CF_DateConvert Value="#Form.DistributionDateExpiration#">
	<cfset dateEnd = dateValue>
	
<cfelse>	

    <cfset URL.Status = "6">
	
	<cfquery name="Clean" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM UserReport
		WHERE  Status = '#URL.Status#' 
		AND    Account = '#SESSION.acc#'
	</cfquery>

</cfif>

<!--- --------------------------------- --->
<!--- --------ADD subscription--------- --->
<!--- --------------------------------- --->

<cfif url.formselect eq "Insert" or url.global eq "1" or URL.Status eq "5">

<!--- select mail which results in a save action --->

	<cfquery name="CleanMail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM UserReport
		WHERE  Status = '5'
		AND    NodeIP = '#CGI.Remote_Addr#'
	</cfquery>
	
	<cfparam name="format" default="">
	
	<cfif format eq "Excel" or format eq "OLAP">
		<cfset distribution = "Hyperlink">
	</cfif>
	
	<!--- capture prior variants for the same layout --->
	
	<cfquery name="PriorLayout" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    UserReport
		WHERE   LayoutId = '#Form.LayoutId#' 				 
		AND     Account  = '#SESSION.acc#'
		AND     Status != '5'
	</cfquery>
		
	<cf_assignId>
	
	<cfquery name="Check" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    UserNames
		WHERE   Account  = '#SESSION.acc#'		
	</cfquery>
	
	<cfif Check.recordcount eq "1">
	
	
	<cfparam name="Form.AccountGroup" default="">
					         
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserReport
		         (Reportid,
				 Account,
				 LayoutId,
				 NodeIP,
				 <cfif subscrip eq "1">
				     AccountGroup,
					 DistributionName,
					 DistributionEMail,
					 DistributionEMailCC,
					 DistributionReplyTo,
					 DistributionSubject,
					 DistributionMode,
					 FileFormat,
					 DistributionPeriod,
					 DistributionDOW,
					 DistributionDOM,
					 DateEffective,
					 DateExpiration,
					 Status,
				 <cfelse>	
				     AccountGroup,
				     DistributionName, 
					 Status,
					 DistributionMode,	
				 	 FileFormat,
					 DistributionPeriod,
				 </cfif>
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  	 VALUES ('#rowguid#',
			      '#SESSION.acc#',
		          '#Form.LayoutId#', 
				  '#CGI.Remote_Addr#',
				  <cfif subscrip eq "1">
				      '#Form.AccountGroup#',
					  '#Form.DistributionName#',
					  '#Form.DistributionEMail#',
					  '#Form.DistributionEMailCC#',
					  '#Form.DistributionReplyTo#',
					  '#Form.DistributionSubject#',
					  '#distribution#', 
					  '#format#',
					  '#Form.DistributionPeriod#',
					  '#dow#',
					  '#Form.DistributionDOM#',
					  #dateStart#,
					  #dateEnd#, 
					  '#URL.Status#',
				  <cfelse>
				     '#Form.AccountGroup#', 
				     'Preset criteria',
					 '#URL.Status#',
					 '','','',				 
				  </cfif>
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
			  </cfquery>	
			  
		  </cfif>	  	  
						  
		  <cfparam name="Form.AccountMailing" default="">
		  
		  <cfif Form.AccountMailing neq "">
		  
		  <cfquery name="InsertMailing" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserReportMailing
		         (ReportId,
				 Account,
				 OperationAL,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  	 VALUES ('#rowguid#',
			      '#FORM.AccountMailing#',
		          '1', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
			</cfquery>
		  
		  </cfif>
		  
		  <!--- save cluser values --->
		  
		   <cfquery name="Cluster" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT DISTINCT CriteriaCluster
				 FROM   Ref_ReportControlCriteria
				 WHERE  ControlId = '#URL.ControlId#'
				 AND (CriteriaCluster != NULL or CriteriaCluster <> '')
				 AND    Operational = 1
		  </cfquery>
		  
		  <cfoutput query="Cluster">
		  		   		  
			   <cfset value  = Evaluate("FORM." & #Cluster.CriteriaCluster#)>
			  				         	  	  
				  <cfquery name="InsertParameter" 
				  datasource="AppsSystem"
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO UserReportCriteria
				          (ReportId, CriteriaName, CriteriaValue)
				  VALUES ('#rowguid#', '#Cluster.CriteriaCluster#', '#value#')
				  </cfquery>
		  
		  </cfoutput>
		  		  
		  <!--- save criteria values --->
			  
		  <cfquery name="Criteria" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_ReportControlCriteria
				 WHERE  ControlId = '#URL.ControlId#'
				 AND    Operational = 1
				 AND (CriteriaCluster is NULL or CriteriaCluster = '')
				 UNION ALL
				 SELECT *
				 FROM   Ref_ReportControlCriteria
				 WHERE  ControlId = '#URL.ControlId#'
				 AND    Operational = 1
				 AND CriteriaName IN (SELECT CriteriaValue 
	                      FROM UserReportCriteria 
						  WHERE ReportId = '#rowguid#')
				 
				 
		  </cfquery>
			 			 	
	      <cfoutput query="Criteria">
		  
		  		<cfparam name="FORM.#Criteria.CriteriaName#" default="">			  
		        <cfset rep = rowguid>				
				<cfinclude template="SelectReportSaveLine.cfm">
			  
		  </cfoutput>
			  
		  <!--- now check if subscribed report already has an equivalent by mapping records --->
		  
			
			<CFIF url.status NEQ "5">
											
				<cfloop query="PriorLayout">
				
					 <cfquery name="Lines" 
						 datasource="AppsSystem"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						   SELECT  *
						   FROM    UserReportCriteria
						   WHERE   Reportid = '#ReportId#'					  
					 </cfquery>
								
					 <cfquery name="Mapped" 
						 datasource="AppsSystem"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						   SELECT  *
						   FROM    UserReportCriteria Prior INNER JOIN
				                   UserReportCriteria New ON Prior.CriteriaName = New.CriteriaName 
								   AND Prior.CriteriaValue = New.CriteriaValue
						   WHERE   Prior.Reportid = '#ReportId#'
						   AND     New.reportId = '#rowguid#' 
					 </cfquery>
					 
					 <cfif Lines.recordcount eq Mapped.recordcount and Lines.recordcount neq "0">
					 
						 <!--- check if also layout is the same --->
						
						  <cfquery name="Delete" 
							 datasource="AppsSystem"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							   DELETE  FROM    UserReport
							   WHERE   Reportid = '#rowguid#'			  
						 </cfquery>
						 
						 <script>
						     alert("It appears you already subscribed to this layout with the same selection criteria. Your subscription request will not be completed")
						 </script>
						 
												 
					 </cfif>
					 			
			    </cfloop>	
			
			</CFIF>	
												 
			<cfif URL.Status eq "5">
			
				<cfset URL.ReportId = rowguid>
			
			<cfelse>
			
			    <cfoutput>
				
				<cfif url.global eq "1">								
							
				<cfelse>
			
					<script>
						ColdFusion.navigate('HTML/FormHTMLSubscription.cfm?controlid=#controlid#&reportid=#reportid#','subscriptions')
					</script>	
				
				</cfif>
				
				</cfoutput>		
				
			</cfif>
											      
</cfif>

<!--- --------------------------------- --->
<!--- --------UPDATE subscription------ --->
<!--- --------------------------------- --->

<cfif url.formselect eq "Update"> 

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserReport 
		WHERE  ReportId = '#URL.ReportId#' 		
 	</cfquery>
	
	
	<cfif Check.recordcount eq "0">
	
	 <script language="JavaScript">
		      alert("Your report variant was removed from the database.")
	  </script>  
	
	<cfelse>   
			
		<cfif format eq "Excel" or format eq "OLAP">
		
			  <cfset distribution = "Hyperlink">
			  
		<cfelse>
		  	
			<cfif Report.EnableAttachment eq "0">	
			
			      <cfset distribution = "Hyperlink"> 
			<cfelse>  
			      <cfset distribution = "#Form.DistributionMode#"> 
		    </cfif>
			
		</cfif>
		
		<cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE UserReport 
			SET    Account             = '#SESSION.acc#',
				   LayoutId            = '#Form.LayoutId#',
				   AccountGroup        = '#Form.AccountGroup#',
				   DistributionName    = '#Form.DistributionName#',
				   DistributionEMail   = '#Form.DistributionEMail#',
				   DistributionEMailCC = '#Form.DistributionEMailCC#',
				   DistributionReplyTo = '#Form.DistributionReplyTo#',
				   DistributionSubject = '#Form.DistributionSubject#',
				   DistributionMode    = '#distribution#', 
				   FileFormat          = '#format#',
				   DistributionPeriod  = '#Form.DistributionPeriod#',  
				   DistributionDOW     = '#dow#',
				   DistributionDOM     = '#Form.DistributionDOM#',
				   DateEffective       =  #dateStart#,
				   DateExpiration      =  #dateEnd#,
				   OfficerUserId       = '#SESSION.acc#',
				   OfficerLastName     = '#SESSION.last#',
				   OfficerFirstName    =  '#SESSION.first#'              
		    WHERE  ReportId = '#URL.ReportId#'
	 	</cfquery>
	 
	    <cfquery name="Clear" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM   UserReportCriteria 
		WHERE  ReportId = '#URL.ReportId#'
		</cfquery>
		
		<cfquery name="Clear" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM   UserReportMailing 
		WHERE  ReportId = '#URL.ReportId#'
		</cfquery>
				 
		<cfparam name="Form.AccountMailing" default="">
		
		<cfif Form.AccountMailing neq "">
			  
			  <cfquery name="InsertMailing" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO UserReportMailing
			         (ReportId,
					 Account,
					 OperationAL,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  	 VALUES ('#URL.ReportId#',
				      '#FORM.AccountMailing#',
			          '1', 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
				</cfquery>
			  
		  </cfif>		  
		  		
		 <!--- save cluser values --->
			  
		 <cfquery name="Cluster" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT DISTINCT CriteriaCluster
				 FROM   Ref_ReportControlCriteria
				 WHERE  ControlId = '#URL.ControlId#'
				 AND (CriteriaCluster != NULL or CriteriaCluster <> '')
				 AND    Operational = 1
		 </cfquery>		
		  
		 <cfoutput query="Cluster">
		  
			  <cfset value  = Evaluate("FORM." & #Cluster.CriteriaCluster#)>
				         	  	  
			  <cfquery name="InsertParameter" 
				  datasource="AppsSystem"
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO UserReportCriteria
				          (ReportId, CriteriaName, CriteriaValue)
				  VALUES ('#URL.ReportId#', '#Cluster.CriteriaCluster#', '#value#')
			  </cfquery>
		  
		 </cfoutput>
		 
		 
		  
		 <!--- save criteria values --->  
		
		<cfquery name="Criteria" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Ref_ReportControlCriteria
		 WHERE  ControlId = '#URL.ControlId#'
		 AND (CriteriaCluster is NULL OR CriteriaCluster = '')
		 AND    Operational = 1
		 UNION ALL
		 SELECT *
		 FROM   Ref_ReportControlCriteria
		 WHERE  ControlId = '#URL.ControlId#'
		 AND    Operational = 1
		 AND CriteriaName IN (SELECT CriteriaValue 
		                      FROM UserReportCriteria
							  WHERE ReportId = '#URL.ReportId#')  
		 
		</cfquery>
				
		<cfoutput query="Criteria">
		 
		 		<cfset rep = url.reportid>				
				<cfinclude template="SelectReportSaveLine.cfm">
		 
		</cfoutput>
		
						 
		<cfoutput>
			
			<cfif url.global eq "1">
					
					<!--- nada --->
			
			<cfelse>
		   
			     <script>
					ColdFusion.navigate('HTML/FormHTMLSubscription.cfm?controlid=#controlid#&reportid=#reportid#','subscriptions')
				 </script>		
			 
			 </cfif>
			
		</cfoutput> 
		 		 
	   </cfif>
			  
</cfif>	  

<!--- not sure what this is 26/3/2008 --->

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsSystem" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      DELETE FROM UserReport 
      WHERE  ReportId = '#Form.ReportId#'
	</cfquery>
		    	
</cfif>		

<cfif url.SaveRefresh eq "1">
	<script>
		window.location.reload();
	</script>
</cfif>

