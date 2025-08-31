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
<cfoutput>

<cfsavecontent variable="label">
	
	<cfquery name="Search" 
	        datasource="AppsSelection" 
	        username="#SESSION.login#" 
	        password="#SESSION.dbpw#">
	        SELECT *
			FROM RosterSearch
			WHERE SearchId = '#URL.ID#'
	</cfquery>  

	<cfset html="No">
		  
	<cfif Search.SearchCategory eq "Vacancy">
	
		<cfquery name="Vacancy" 
		     datasource="AppsVacancy" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			SELECT   *
			FROM     Document 
			WHERE    DocumentNo = '#Search.SearchCategoryId#'
		</cfquery>		
		
		  Roster search for recruitment request #Search.SearchCategoryId# [#Vacancy.Mission# / #Vacancy.PostGrade# / #Vacancy.FunctionalTitle#]
	
		<cfset html="no">
		
	<cfelseif Search.SearchCategory eq "Function">
	
			<cfquery name="Roster" 
			     datasource="AppsSelection" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				SELECT   FT.FunctionDescription,
				         F.GradeDeployment
				FROM     FunctionOrganization F INNER JOIN
				         FunctionTitle FT ON F.FunctionNo = FT.FunctionNo
				WHERE    F.FunctionId = '#Search.SearchCategoryId#'
			</cfquery>		
			 
			 #Roster.FunctionDescription# [#Roster.GradeDeployment#]	
			 
			 <cfset html="yes">	
					 
	<cfelseif Search.SearchCategory eq "default">
	
		<cfset html="no">
	
	<cfelse>
	
		<cfset html="Yes">
		  	
	  Roster search 
	  
	</cfif>

</cfsavecontent>


<cfquery name="Check" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   SELECT *
	   FROM   RosterSearch
	   WHERE  SearchId = '#URL.ID#'
</cfquery>

<cfparam name="URL.Height" default="600">
<cfparam name="URL.DocNo" default="">

<cf_screentop label="#label#" 
	   height="100%" 
	   html="#html#"
	   line="no" 
	   bannerheight="55"
	   layout="webapp" 
	   banner="gray"
	   border="1"   
	   jquery="Yes"
	   scroll="no">
   
<cf_LayoutScript>
<cfajaximport tags="cfform">	
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<!--- 
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "60px"
		maxsize	  = "60px"
		size 	  = "60px">	
					  
		<cfinclude template="SearchMenu.cfm">
			 			  
	</cf_layoutarea>		
	--->
	 
		
	<cf_layoutarea position="center" name="box">
				
			<iframe src="ResultListing.cfm?mode=#url.mode#&docno=#url.docNo#&ID=GEN&ID1=#URL.ID#&ID2=B&ID3=GEN&height=#URL.height#&mid=#url.mid#"
		        name="center"
		        id="center"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
					
	</cf_layoutarea>			
	
	<cf_layoutarea 
	    position    = "right" 
		name        = "treebox" 
		maxsize     = "370" 		
		size        = "270" 
		collapsible = "true" 
		splitter    = "true"
		overflow    = "hidden">
				
			<iframe src="SearchTree.cfm?docno=#url.docNo#&ID=1&ID1=#URL.ID#&mode=#url.Mode#&Owner=#Check.Owner#&Status=#Check.RosterStatus#&mid=#url.mid#"
		        name="left"
		        id="left"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
	
	</cf_layoutarea>
		
</cf_layout>

</cfoutput>

