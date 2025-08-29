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
<cfparam name="URL.SystemFunctionId"   default="">
<cfparam name="URL.Mission"            default="">
<cfparam name="URL.id1"                default="">
<cfparam name="URL.period"             default="FY10">

<cf_ListingScript>
<cf_dialogProcurement>

<cfoutput>

<cfsavecontent variable="myquery">	
	
	SELECT   R.*, P.ProgramName
	FROM     (
			SELECT *, OfficerFirstName + ' ' + OfficerLastName AS Officer,
				(
				SELECT CASE  WHEN RequestDate IS NULL  THEN Created
		    	 ELSE  RequestDate END AS RDate
			    FROM   PurchaseExecutionRequest
				WHERE  RequestId = PER.RequestId
			)
			AS RDate
		FROM PurchaseExecutionRequest PER
	) AS R
	
	INNER JOIN Program.dbo.Program P ON R.ProgramCode = P.ProgramCode
	WHERE    Period       = '#url.period#' 
	AND      ActionStatus = '#URL.ID1#'			
	<!--- only this mission --->
	AND      R.PurchaseNo IN
                        (SELECT     PurchaseNo
                         FROM       Purchase
                         WHERE      Mission = '#url.mission#'
					     AND        PurchaseNo = R.PurchaseNo) 
	<!--- valid orgunit --->				
	AND 	  R.OrgUnit IN
                        (SELECT    OrgUnit
                         FROM      Organization.dbo.Organization
					     WHERE     OrgUnit = R.OrgUnit)							

</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="Purchase" var="vPurchase">
<cfset fields[itm] = {label         = "#vPurchase#", 
					  field         = "PurchaseNo",
				      searchfield   = "PurchaseNo",
					  filtermode    = "2",
					  search        = "text"}>			

<cfset itm = itm+1>		
<cf_tl id="Program" var="vProgram">
<cfset fields[itm] = {label         = "#vProgram#", 
					  field         = "ProgramName",
					  searchfield	= "ProgramCode",
					  searchalias	= "P",
  					  filtermode    = "2",
					  search		= "text"}>					

<cfset itm = itm+1>		
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label         = "#vReference#", 
					  field         = "Reference",
				      searchfield   = "Reference",
					  filtermode    = "0",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cfset itm = itm+1>		
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label         = "#vDescription#", 
					  field         = "RequestDescription",
				      searchfield   = "RequestDescription",
					  filtermode    = "0",
					  search        = "text"}>	
	  
<cfset itm = itm+1>		
<cf_tl id="Officer" var="vOfficer">
<cfset fields[itm] = {label         = "#vOfficer#", 
					  field         = "Officer"}>	
	  
<cfset itm = itm+1>		
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label       = "#vDate#",  					
					  field       = "RDate",
					  search      = "date",
					  formatted   = "dateformat(RDate,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label         = "#vAmount#", 
					  field         = "RequestAmount",
					  align			= "Right",
					  formatted     = "NumberFormat(RequestAmount,'___,___.__')"}>	
	

<cfset menu=ArrayNew(1)>	
	 
 <cfquery name="Check" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
			 SELECT DISTINCT R.Role, R.Description, R.ListingOrder
		     FROM   OrganizationAuthorization A INNER JOIN
		            Ref_AuthorizationRole R ON A.Role = R.Role
		     WHERE  A.Mission = '#URL.Mission#' 
			 AND    A.UserAccount = '#SESSION.acc#' 
			 AND    A.Role IN ('ProcReqEntry')
</cfquery>
	 
<cfinvoke component = "Service.Access"  
		   method           = "createwfobject" 
		   entitycode       = "ProcExecution"
		   returnvariable   = "accesscreate">
					   
<cfif check.recordcount gte "1" or accesscreate eq "EDIT" or getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->		
	    				
	<cfset newLabel = "New Request">
	
	<cf_tl id="#newLabel#" var="1">
						
	<cfset menu[1] = {label = "#lt_text#", script = "addRequest('#url.mission#','#url.period#')"}>				 

</cfif>

<cf_listing
    header         = "Request"
	menu           = "#menu#"
    box            = "detail"
	link           = "ViewListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&period=#url.period#&id1=#url.id1#"
    html           = "No"
	show           = "40"
	datasource     = "AppsPurchase"
	listquery      = "#myquery#"			
	listorder      = "Created"
	listorderalias = "R"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Yes"
	excelShow      = "Yes"
	drillmode      = "window"	
	drillargument  = "900;1000;true;true"	
	drilltemplate  = "Procurement/Application/PurchaseOrder/ExecutionRequest/RequestView.cfm?id="
	drillkey       = "RequestId">
	