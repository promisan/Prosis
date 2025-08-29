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
<cfsavecontent variable="myquery">		
	<cfoutput>

		SELECT   *      
		FROM     Materials.dbo.CustomerBeneficiary CB
		WHERE    CB.CustomerId = '#url.customerid#' 
		ORDER BY CB.BirthDate DESC
	</cfoutput>
</cfsavecontent>


<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<cf_tl id="DOB" var="1">

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "BirthDate",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "date",
					  formatted     = "dateformat(BirthDate,'#CLIENT.DateFormatShow#')"}>	


<cf_tl id="FirstName" var="1">					  

<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "FirstName",
					  filtermode    = "2",
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	
					  
<cf_tl id="LastName" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "#lt_text#",                  
					  field       = "LastName"}>					  

<cf_tl id="Relationship" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "Relationship",
					  filtermode    = "1",
					  display		= "Yes",
					  displayfilter = "Yes",
					  search        = "text"}>	

<cf_tl id="Gender" var="1">						  
<cfset itm = itm+1>		
<cfset fields[itm] = {label         = "#lt_text#",                  
					  field         = "Gender",
					  filtermode    = "1",
					  display		= "Yes",
					  displayfilter = "Yes",					  
					  search        = "text"}>
					  
					  
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">	
		
	<cf_listing
	    header         = "Invoices"
	    box            = "Invoices"
		link           = "#SESSION.root#/warehouse/Application/Customer/Beneficiary/RecordListing.cfm?customerid=#url.customerid#&systemfunctionid=null"
	    html           = "No"
	    show           = "40"		
		datasource     = "AppsQuery"
		listquery      = "#myquery#"		
		listorder      = "BirthDate"
		listorderfield = "BirthDate"
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "yes"
		excelShow      = "Yes"
		drillmode      = "window"	
		drillargument  = "600;600;false;false"	
		drillstring    = ""	
		drilltemplate  = "Warehouse/Application/Customer/Beneficiary/RecordListingDetail.cfm?CustomerId=#url.customerid#&BeneficiaryId="
		drillkey       = "BeneficiaryId">		
	</td></tr>
</table>		