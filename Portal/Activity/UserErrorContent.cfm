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

<!--- control list data content --->

<cfparam name="url.filter"  default="">
<cfparam name="url.mode"    default="current">
<cfparam name="url.scope"   default="usr">
<cfparam name="url.systemfunctionid"   default="">

<cfif getAdministrator("*") eq "1">

	<cfset Drill.recordcount = "1">
	
<cfelse>

	<cfquery name="Drill" 
	datasource="AppsOrganization">
		SELECT   *
		FROM     OrganizationAuthorization
		WHERE    UserAccount = '#SESSION.acc#'
		AND      Role = 'AdminUser'
	</cfquery>

</cfif>

<cfif drill.recordcount gte "1">
  <cfset access = "Full">
<cfelse>
  <cfset access = "Limited">  
</cfif>

<cfif URL.Mode eq "Current">	

	<cfset daterecent = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfelse>	

	<cfset daterecent = DateAdd("d", "-1", "#now()#")>

</cfif>

<!--- configuration file --->

<cfoutput>
<cfsavecontent variable="myquery">
	 SELECT  U.*, FirstName+' '+LastName as Name 
	 FROM    UserError	U INNER JOIN UserNames N ON U.Account = N.Account 	
	 WHERE   U.ErrorTimeStamp > #daterecent#						
	 --condition
</cfsavecontent>


<cfset fields=ArrayNew(1)>

<cfset itm = "0">

<cfif access eq "Full">
	
	<cfset itm = itm+1>	
	<cf_tl id="Account" var = "1">		
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "Account",																	
						alias             = "",	
						functionscript    = "ShowUser",
						functionfield     = "Account",																		
						functioncondition = "audit",
						filtermode		  = "3",		
						search            = "text"}>	
						
<cfelse>
	
	<cfset itm = itm+1>	
	<cf_tl id="Account" var = "1">		
	<cfset fields[itm] = {label           = "#lt_text#",                    
	     				field             = "Account",																	
						alias             = "",		
						filtermode		  = "3",					
						search            = "text"}>		
	
</cfif>				
	
<cfif access eq "Full">
						
		<cfset itm = itm+1>	
		<cf_tl id="Name" var = "1">		
		<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field           = "Name",																	
							alias           = "",
							functionscript  = "EditPerson",
							functionfield   = "PersonNo",
							filtermode		= "3",
							display         = "yes",																			
							search          = "text"}>	
						
<cfelse>
	
		<cfset itm = itm+1>	
		<cf_tl id="Name" var = "1">		
		<cfset fields[itm] = {label         = "#lt_text#",                    
		     				field           = "Name",																	
							alias           = "",
							filtermode		= "1",
							display         = "yes",																			
							search          = "text"}>	
		
	
</cfif>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Diagnostics", 					
					  field      = "ErrorDiagnostics",
					  width      = "150",
					  sort       = "No",
					  search     = "text"}>		

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "ErrorNo",                    
					  field      = "ErrorNo",
					  search     = "text"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Server",                    
					  field      = "HostServer",
					  filtermode = "2",																						  
					  search     = "text"}>		

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Directory",                    
					  field      = "TemplateGroup",
					  filtermode = "2",	
					  search     = "text"}>					

<cfset itm = itm+1>									
<cfset fields[itm] = {label      = "Date",    					
				 	  field      = "ErrorTimeStamp",					
					  formatted  = "dateformat(ErrorTimeStamp,CLIENT.DateFormatShow)"}>

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Time",    					
					  field      = "ErrorTimeStamp",
					  formatted  = "timeformat(ErrorTimeStamp,'HH:MM')"}>			
					  
<cfif url.mode eq "Current">
	<cfset label = "Active users">
<cfelse>
	<cfset label = "Today's users"> 
</cfif>					  		

		
<cf_listing
    header        = "usererror"
    box           = "usererror"
	boxlabel      = "#label#"
	link          = "#SESSION.root#/Portal/Activity/UserErrorContent.cfm?systemfunctionid=#url.systemfunctionid#"
    html          = "No"
	show          = "100"
	listquery     = "#myquery#"
	listkey       = "account"	
	listgroup     = "TemplateGroup"
	listgroupdir  = "ASC"
	listorder     = "ErrorTimeStamp"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	excelshow     = "Yes"
	filtershow    = "hide"	
	drillmode     = "dialogajax"
	drillargument = "740;800;false;false"	
	drilltemplate = "System/Access/User/Audit/ListingErrorDetail.cfm"
	drillkey      = "ErrorId">
		
</cfoutput>	
