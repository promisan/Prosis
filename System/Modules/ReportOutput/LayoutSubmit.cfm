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

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.Dashboard" default="0">
<cfparam name="Form.UserScoped" default="0">
<cfparam name="Form.PasswordUser" default="">
<cfparam name="Form.PasswordOwner" default="0">
<cfparam name="Form.OutputEncryption" default="none">
<cfparam name="Form.OutputPermission" default="">

<cfset Form.LayoutCode  = Replace(#Form.LayoutCode#,' ','','ALL')>
<cfset Form.LayoutCode  = Replace(#Form.LayoutCode#,'.','','ALL')>	
<cfset Form.LayoutCode  = Replace(#Form.LayoutCode#,',','','ALL')>

<cfif Form.TemplateReport	neq "Excel">
	<cfset cnt = 0>
	<cfloop index="itm" list="#Form.TemplateReport#" delimiters=".">
	    <cfset suf = "#itm#">
		<cfset cnt = cnt + 1>
	</cfloop>	
	
	<!---
	<cfif (#suf# neq "cfr" and #Form.LayoutClass# eq "Report") or 
	      (#suf# neq "cfm" and #Form.LayoutClass# eq "View") or 
		   #cnt# neq "2">
	
	  <script language="JavaScript">
	   alert(You entered an invalid file name.")
	   <cfoutput>
		 window.location = "Layout.cfm?ID=#URL.ID#"
	   </cfoutput> 
	  </script>
	  <cfabort>
	  	  
	</cfif>  
	--->
	  
</cfif>

<cftransaction action="BEGIN">

<cfif URL.ID1 eq "00000000-0000-0000-0000-000000000000">
  
	<cfquery name="Check" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * FROM Ref_ReportControlLayout 
		 WHERE ControlId = '#URL.ID#'
		 AND   LayoutName = '#Form.LayoutName#'
	</cfquery>
	
	<cfif Check.recordcount gte "1">
	
	<script>
	   alert("Layout name : <cfoutput>#Form.LayoutName#</cfoutput> already exists")
	</script>
	
	<cfelse>

		<cf_assignId>
		
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlLayout 
		         (LayoutId,
				 ControlId,
				 LayoutName,
				 LayoutCode,
				 LayoutClass,
				 LayoutFormat,
				 LayoutTitle,
				 LayoutSubtitle,
				 TemplateReport,
				 OutputPermission,
				 OutputEncryption,
				 PasswordOwner,
				 PasswordUser,
				 ListingOrder,
				 Dashboard,
				 UserScoped,
				 CleanSQLTables,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		      VALUES ('#rowguid#',
			      '#URL.ID#',
		      	  '#Form.LayoutName#',
				  '#Form.LayoutCode#',
				  '#Form.LayoutClass#', 
				  '#Form.LayoutFormat#',
				  '#Form.LayoutTitle#',
				  '#Form.LayoutSubTitle#',				 
				  '#Form.TemplateReport#',
				  '#Form.OutputPermission#',
				  '#Form.OutputEncryption#',
				  '#Form.PasswordOwner#',
				  '#Form.PasswordUser#',
				  '#Form.ListingOrder#',
				  '#Form.Dashboard#',
				  '#Form.UserScoped#',
				  '#Form.CleanSQLTables#',
				  '#Form.Operational#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
			<cfquery name="Cluster" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT CriteriaCluster
				FROM      Ref_ReportControlCriteria
				WHERE     CriteriaCluster <> '' 
				AND (ControlId = '#URL.ID#')
			</cfquery>
			
			<cfloop query="Cluster">
			
				<cfparam name="Form.Cluster_#CriteriaCluster#" default="">
				<cfset cn = evaluate("Form.Cluster_#CriteriaCluster#")>
				
				<cfif cn neq "">
				
					<cfquery name="Insert" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Ref_ReportControlLayoutCluster 
				         (LayoutId,
						 CriteriaCluster,
						 CriteriaName)
				      VALUES ('#rowguid#',
				      	  '#CriteriaCluster#',
						  '#cn#')
					</cfquery>
							
				</cfif>
						
			</cfloop>
	
	</cfif>
	
<cfelse>
	
	   <cfquery name="Update" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Ref_ReportControlLayout
		  SET Operational      = '#Form.Operational#',
			  ListingOrder     = '#Form.ListingOrder#',
			  TemplateReport   = '#Form.TemplateReport#',
		      OutputPermission = '#Form.OutputPermission#',
			  OutputEncryption = '#Form.OutputEncryption#',
			  LayoutTitle      = '#Form.LayoutTitle#',
			  LayoutSubtitle   = '#Form.LayoutSubtitle#',
			  PasswordOwner    = '#Form.PasswordOwner#',
			  PasswordUser     = '#Form.PasswordUser#',
			  Dashboard        = '#Form.Dashboard#',
			  UserScoped       = '#Form.UserScoped#',
			  CleanSQLTables   = '#Form.CleanSQLTables#',
			  LayoutName       = '#Form.LayoutName#',
			  LayoutFormat     = '#Form.LayoutFormat#',
			  LayoutCode       = '#Form.LayoutCode#'
		 WHERE LayoutId = '#URL.ID1#'
    	</cfquery>
		
		<cfquery name="Clear" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Ref_ReportControlLayoutCluster
				WHERE   LayoutId =  '#url.id1#'				
			</cfquery>
		
		<cfquery name="Cluster" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    DISTINCT CriteriaCluster
				FROM      Ref_ReportControlCriteria
				WHERE     CriteriaCluster <> '' 
				AND (ControlId = '#URL.ID#')
			</cfquery>
			
			<cfloop query="Cluster">
			
				<cfparam name="Form.Cluster_#CriteriaCluster#" default="">
				<cfset cn = evaluate("Form.Cluster_#CriteriaCluster#")>
				
				<cfif cn neq "">
				
					<cfquery name="Insert" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Ref_ReportControlLayoutCluster 
				         (LayoutId,
						 CriteriaCluster,
						 CriteriaName)
				      VALUES ('#url.id1#',
				      	  '#CriteriaCluster#',
						  '#cn#')
					</cfquery>
							
				</cfif>
						
			</cfloop>
	
</cfif>

</cftransaction>

<script> 
    parent.parent.outputrefresh()
    parent.parent.ProsisUI.closeWindow('mydialog',true)  
</script> 	
   
