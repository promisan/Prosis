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
<cfparam name="url.claimid"         default="">
<cfparam name="url.elementclass"    default="">
<cfparam name="url.claimtypeclass"  default="">

<cfquery name="Class" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Ref_ElementClass
	WHERE    Code = '#url.elementclass#'			
</cfquery>

<!--- define fields to be included on the fly --->

<cfif url.claimid neq "">
	
	<cfquery name="Case" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     Claim 
		 WHERE   ClaimId = '#url.claimid#'			
	</cfquery>

    <cfset url.mission = case.Mission>

<cfelse>

 <cfparam name="url.mission"     default="">

</cfif>
	
<cfquery name="TopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*, S.PresentationMode
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#url.elementclass#'	
		 AND       Operational = 1		 
		 AND       (Mission = '#url.Mission#' or Mission is NULL)		
		 ORDER BY  S.ListingOrder,R.ListingOrder
</cfquery>
	
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Element">  

<cfquery name="Detail" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  C.DocumentDescription,
	        CE.CaseElementId,
	        E.ElementId,
			E.ElementMemo,
			E.PersonNo, 
			E.DependentId,
	        E.Reference,  
			
			<cfif url.elementclass eq "Person">
			
				A.IndexNo,
				(A.LastName+' '+A.LastName2) as LastName,
				(A.FirstName+' '+A.MiddleName) as FirstName,
				A.DOB,
				A.Gender AS Gender,		
			
			<cfelseif Class.EnableDependent eq "1">
			
				D.FirstName, 
				D.LastName,
			
			</cfif> 
							
			<cfloop query="TopicList">			
				 <cfset fld = rereplacenocase(description, '[^a-z]', '', 'all')>
				 <cfif TopicClass neq "Person">
					(SELECT TopicValue 
					 FROM   ElementTopic 
					 WHERE  ElementId = E.ElementId 
					 AND    Topic = '#code#') as #fld#,						
				 </cfif>	 
			</cfloop>		
			
		    E.Created		
			
	INTO    userquery.dbo.tmp#SESSION.acc#Element	
	
	FROM    Element E INNER JOIN ClaimElement CE ON E.ElementId = CE.ElementId INNER JOIN
	        Claim C ON CE.ClaimId = C.ClaimId			
			<cfif url.elementclass eq "Person">
				LEFT OUTER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo
			<cfelseif Class.EnableDependent eq "1">
			    LEFT OUTER JOIN Employee.dbo.PersonDependent D ON E.DependentId = D.DependentId
			</cfif>	 	
		WHERE   E.ElementClass = '#url.elementclass#'	
		AND     
			<cfif url.claimid neq "">
			
				 CE.ClaimId     = '#url.claimid#'
			<cfelse>
			
				CE.ClaimId IN (SELECT ClaimId 
	       				   FROM   Claim 
		   				   WHERE  Mission        = '#url.mission#' 
						   <cfif url.claimtypeclass neq "">
		   				   AND    ClaimTypeClass = '#url.claimtypeclass#'
						   </cfif>
						   )
			</cfif>	
								
	<cfif getAdministrator("#url.mission#") eq "0">
		
			<!--- pending 
							
				AND (
						W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
									    AND    Role = 'WorkOrderProcessor'
									   )	
									   
						OR 		
						
						 <!--- is a requester for this service item --->
							
						 W.ServiceItem IN (
						                SELECT ClassParameter
						                FROM   Organization.dbo.OrganizationAuthorization
									    WHERE  UserAccount = '#SESSION.acc#'
										AND    Mission = '#param.treecustomer#'
									    AND    Role = 'ServiceRequester'
									   )		   
					 )			
					 
			--->	    
							
	</cfif>
	
</cfquery>

<cfoutput>
<cfsavecontent variable="myquery">
	SELECT * FROM userquery.dbo.tmp#SESSION.acc#Element
</cfsavecontent>
</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
		
	<cfif class.EnableReference eq "1">
	
		<cfset itm = itm+1>
		<cf_tl id="Reference" var="1">
	
		<cfset fields[itm] = {label   = "#lt_text#",                   		
							  field   = "Reference",					
							  alias   = "",														
							  search  = "text"}>	
						  
	</cfif>		
	
	<cfif url.claimid eq "">
	
		<cfset itm = itm+1>	
		<cf_tl id="Case" var="1">
	
		<cfset fields[itm] = {label   = "#lt_text#",                   		
							  field   = "DocumentDescription",					
							  alias   = "",														
							  search  = "text"}>	

	</cfif>				 
					  
	<cfif Class.EnableDependent eq "1">
	
	   <cf_tl id="LastName" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      = "#lt_text#", 					
						     field      = "LastName",											
						     display    = "Yes",
						     search     = "text"}>	
						
		<cf_tl id="FirstName" var="1">
							 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      = "#lt_text#", 					
						     field      = "FirstName",											
						     display    = "Yes",
						     search     = "text"}>	
	
	</cfif>		  										

 	<cfset FirstPersonElement  = TRUE>	
	
	<cfloop query="TopicList">

	    <cfif PresentationMode neq "0">
		    <cfset dis = "Yes">
		<cfelse>
			<cfset dis = "No">		
		</cfif>	
		 
		 <cfif TopicClass eq "Person">

		 	 <cfif FirstPersonElement>
			   
			    <cfset itm = itm + 1>
			 	<cfset FirstPersonElement  = FALSE>
	 			<cf_tl id="Profile" var="1">
				<cfset fields[itm] = {label     		= "#lt_text#", 					
								     field      		= "PersonNo",	
									 functionscript   	= "ShowCaseFileCandidate",										
								     display    		= "Yes",
								     search			    = "text"}>							 				 								 								 								 			
										 
				
			 </cfif>
		 
		 	<cfswitch expression="#TopicLabel#">
				<cfcase value="IndexNo">
					<cfset itm = itm + 1>
					<cfset fields[itm] = {label    		= "#client.indexNoName#", 					
								     	field      		= "IndexNo",																
								     	display    		= "#dis#",
								     	search     		= "text"}>		
				</cfcase>
				
				<cfcase value="FirstName">
				   <cfset itm = itm + 1>				
					<cf_tl id="#TopicLabel#s" var="1">
					<cfset fields[itm] = {label    		= "#lt_text#", 					
								     	 field      	= "#TopicLabel#",											
									     display    	= "#dis#",
									     search     	= "text"}>		
				</cfcase>					

				<cfcase value="LastName">
				   <cfset itm = itm + 1>				
					<cf_tl id="#TopicLabel#s" var="1">
					<cfset fields[itm] = {label      	= "#lt_text#", 					
								     	 field      	= "#TopicLabel#",											
									     display    	= "#dis#",
									     search     	= "text"}>		
				</cfcase>					
				
				<cfcase value="Gender">
				   <cfset itm = itm + 1>				
					<cf_tl id="#TopicLabel#" var="1">
					<cfset fields[itm] = {label   		= "#lt_text#", 					
								     	 field      	= "#TopicLabel#",											
									     display    	= "#dis#",
									     search     	= "text"}>		
				</cfcase>					

				
				<cfcase value="DOB">
					<cfset itm = itm + 1>
					<cf_tl id="DOB" var="1">
					<cfset fields[itm] = {label         = "#lt_text#", 					
								     	 field          = "DOB",											
									     display        = "#dis#",
										 formatted      = "dateformat(dob,CLIENT.DateFormatShow)",
									     search     	= "text"}>			
				</cfcase>			
				</cfswitch>	
	
				
		<cfelse>
		
				<cfset itm = itm + 1>
								
				<cfset fld = rereplacenocase(description, '[^a-z]', '', 'all')>
				
				<cfif TopicLabel neq "">
					  <cfset lbl = topiclabel>
				<cfelse>
					  <cfset lbl = description>
				</cfif>
				
				<cfif ValueClass eq "Date">		
				
					<cfset fields[itm] = {label         = "#lbl#",                    
										field           = "#fld#", 		
										display         = "#dis#",
										formatted       = "dateformat(#fld#,CLIENT.DateFormatShow)",				
										search          = "date"}>		
				
				<cfelseif ValueClass eq "DateTime">
				
					<cfset fields[itm] = {label  	    = "#lbl#",                    
										field           = "#fld#", 	
										display         = "#dis#",	
										formatted       = "dateformat(#fld#,CLIENT.DateFormatShow)",				
										search          = "date"}>		
							
					 <cfset itm = itm + 1>		
							
					 <cfset fields[itm] = {label  		= "Time",                    
										field       	= "#fld#", 
										display    		= "#dis#",		
										formatted  		= "timeformat(#fld#,'HH:MM')",				
										search      	= "date"}>					
				
				<cfelse>
				
					<cfset fields[itm] = {label  		= "#lbl#",                    
										field       	= "#fld#", 
										display    		= "#dis#",						
										search      	= "text"}>		
				
				</cfif>
			
		</cfif>			
	</cfloop>
		
	<cfset itm = itm + 1>						
	<cfset fields[itm] = {label 		= "CaseElementId", 					
					     field      	= "CaseElementId",											
					     display    	= "No",
					     search  	    = "text"}>					
	
<cfset menu=ArrayNew(1)>	

<cfif url.claimid neq ""> 
	
	<cfinvoke component = "Service.Access"  
	   method           = "CaseFileManager" 	   
	   returnvariable   = "access"
	   Mission          = "#url.mission#">	     
	
		<cfif access eq "ALL">		
														
			<cf_tl id="Add Line" var="1">
			<cfset menu[1] = {label = "#lt_text#", icon = "insert.gif",	script = "lineadd('#url.claimid#','','#url.elementclass#')"}>		
		
		<cfelse>	
		
			<cfset menu = "">					  
				
		</cfif>				
	
<cfelse>

	<cfset menu = "">
	
</cfif>	

<cfif url.elementclass eq "Person">
  	<cfset sorting = "LastName"> 
<cfelse>  
	<cfset sorting = "Reference">
</cfif>
	
<!--- embed|window|dialogajax|dialog|standard --->

<cf_listing
	    header         = "elementlinelist"
	    box            = "linedetail#url.elementclass#"
		link           = "#SESSION.root#/CaseFile/Application/Element/Listing/ElementListingContent.cfm?claimid=#url.claimid#&mission=#url.mission#&elementclass=#url.elementclass#&claimtypeclass=#url.claimtypeclass#"
	    html           = "No"		
		tableheight    = "100%"
		tablewidth     = "100%"
		datasource     = "AppsQuery"
		listquery      = "#myquery#"
		listorderfield = "#sorting#"
		listorder      = "#sorting#"
		listorderdir   = "ASC"
		headercolor    = "ffffff"
		show           = "35"		
		menu           = "#menu#"
		filtershow     = "Hide"
		excelshow      = "Yes" 		
		listlayout     = "#fields#"
		drillmode      = "securewindow" 
		drillargument  = "#client.height-100#;#client.widthfull-90#;false;true"	
		drilltemplate  = "CaseFile/Application/Element/Create/ElementEdit.cfm?drillid="
		drillkey       = "CaseElementId"
		drillbox       = "addelement"
		allowgrouping  = "No">	
		
