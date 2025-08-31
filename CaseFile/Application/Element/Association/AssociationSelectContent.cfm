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
<cfparam name="url.elementclass"   default="">

<!--- define fields to be included on the fly --->
	
<cfquery name="TopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   R.*
	     FROM     Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE    ElementClass = '#url.elementclass#'	
		 AND      Operational = 1
		 AND      (Mission = '#url.Mission#' or Mission is NULL)	
		 AND      ValueClass != 'Memo'	
		 AND       R.TopicClass != 'Person'
		 ORDER BY S.ListingOrder,R.ListingOrder
</cfquery>
	
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Element">  

<cfquery name="Detail" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  DISTINCT E.ElementId,
	        E.Reference,    			
			
			<cfif url.elementclass eq "Person">
			
			    A.PersonNo,
				A.IndexNo,
				A.LastName,
				A.LastName2,
				A.FirstName,
				A.MiddleName,
				A.DOB,
				A.Gender,		
			
			<cfelse>
			
			<cfloop query="TopicList">			
				<cfset fld = replace(description," ","","ALL")>
				<cfset fld = replace(fld,".","","ALL")>
				<cfset fld = replace(fld,",","","ALL")>
					(SELECT TopicValue 
					 FROM   ElementTopic 
					 WHERE  ElementId = E.ElementId 
					 AND    Topic = '#code#') as #fld#,						
			</cfloop>	
			
			</cfif>	
			
		    E.Created		
			
	INTO    userquery.dbo.tmp#SESSION.acc#Element						
				
	FROM    Element E 
	        INNER JOIN ClaimElement CE ON E.ElementId = CE.ElementId
			<cfif url.elementclass eq "Person">
			LEFT OUTER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo
			</cfif>
    WHERE   E.ElementClass = '#url.elementclass#' 		
			
</cfquery>

<cfoutput>
<cfsavecontent variable="myquery">
	SELECT * FROM userquery.dbo.tmp#SESSION.acc#Element
</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
		
<cfset itm = itm+1>

<cf_tl id="Reference" var="1">

	<cfset fields[itm] = {label   = "#lt_text#",                   		
						  field   = "Reference",					
						  alias   = "",														
						  search  = "text"}>	
					  
	<cfif url.elementclass eq "Person">
	
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label     	= "#client.indexNoName#", 					
						     field      	= "IndexNo",																
						     display    	= "Yes",
						     search     	= "text"}>				
	
		<cf_tl id="LastName" var="1">
	
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "LastName",											
						     display    	= "Yes",
						     search     	= "text"}>	
							 
		<cf_tl id="2nd LastName" var="1">	
		 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "LastName2",											
						     display    	= "Yes",
						     search     	= "text"}>	
							 
		<cf_tl id="FirstName" var="1">					 
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "FirstName",											
						     display    	= "Yes",
						     search     	= "text"}>		
		
		<cf_tl id="2nd FirstName" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "MiddleName",											
						     display    	= "Yes",
						     search     	= "text"}>							 
		
		<cf_tl id="Gender" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "Gender",											
						     display    	= "Yes",
						     search     	= "text"}>		
		
		<cf_tl id="DOB" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      	= "#lt_text#", 					
						     field      	= "DOB",											
						     display    	= "Yes",
							 formatted  	= "dateformat(dob,CLIENT.DateFormatShow)",
						     search     	= "text"}>			
		
		<cf_tl id="Profile" var="1">
		 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label           = "#lt_text#", 					
						     field            = "PersonNo",	
							 functionscript   = "ShowCandidate",										
						     display          = "Yes",
						     search           = "text"}>							 				 								 								 								 			
						
	<cfelse>			  										  										
		
		<cfloop query="TopicList" startrow="1" endrow="9">
		
			<cfset itm = itm + 1>
			
			<cfset fld = replace(description," ","","ALL")>
			<cfset fld = replace(fld,".","","ALL")>
			<cfset fld = replace(fld,",","","ALL")>
			
			<cfif TopicLabel neq "">
			  <cfset lbl = topiclabel>
			<cfelse>
			  <cfset lbl = description>
			</cfif>
			
			<cfset fields[itm] = {label  = "#lbl#",                    
					field       = "#fld#", 						
					search      = "text"}>		
		
		</cfloop>
		
	</cfif>	
		
	<cfset itm = itm + 1>						
	<cfset fields[itm] = {label    		= "CaseElementId", 					
					     field      	= "CaseElementId",											
					     display    	= "No",
					     search     	= "text"}>					
	
<cfset menu=ArrayNew(1)>	

<cfif url.elementclass eq "Person">
  	<cfset sorting = "LastName"> 
<cfelse>  
	<cfset sorting = "Reference">
</cfif>

<!--- embed|window|dialogajax|dialog|standard --->
										
<cf_listing
	    header        = "elementlinelist"
	    box           = "linedetail#url.elementclass#"
		link          = "#SESSION.root#/CaseFile/Application/Element/Association/AssociationSelectContent.cfm?mode=#url.mode#&mission=#url.mission#&elementid=#url.elementid#&elementclass=#url.elementclass#"
	    html          = "No"		
		tableheight   = "100%"
		tablewidth    = "100%"
		datasource    = "AppsQuery"
		listquery     = "#myquery#"
		listorderfield = "#sorting#"
		listorder      = "#sorting#"
		listorderdir   = "ASC"
		headercolor   = "ffffff"
		show          = "35"				
		filtershow    = "Yes"
		excelshow     = "Yes" 		
		listlayout    = "#fields#"
		drillmode     = "embed" 
		drillargument = "750;930;true;true"	
		drilltemplate = "CaseFile/Application/Element/Association/AssociationAdd.cfm"
		drillkey      = "ElementId"
		drillstring   = "mode=#url.mode#&mission=#url.mission#&elementid=#url.elementid#&elementclass=#url.elementclass#"		
		drillbox      = "addelement"
		allowgrouping = "No">	