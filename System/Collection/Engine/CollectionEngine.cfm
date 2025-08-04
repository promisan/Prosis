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
	<cftry>
	
		<cfsearch collection="#collection.collectionname#" name="SearchTotal" startrow="1" maxrows="1" language="English">
		
		<cfcatch>
		
			<cfoutput>
				<table width="100%"><tr><td height="50" align="center"><font size="3" color="F47A00">Database is OFF-LINE. Come back later.</font></td></tr></table>
			</cfoutput>
			<cfabort>
		
		</cfcatch>
		
    </cftry>	
	
	<!---				

    <cftry>
	
	--->		
	
	<!--- ----------------------- --->
	<!--- make a total assessment --->
	<!--- ----------------------- --->
	
	<!--- we can speed this up but this will then affect the left menu to show all found categories 01/03/2011 --->
			
	<cfsearch collection="#collection.collectionname#" 
		name                  = "CollectionResult" 
		criteria              = "#Lcase(form.searchtext)#" 				
		ContextBytes          = "0"
		ContextPassages       = "0"
		language              = "English">
		
	 <cfset yr = year(now())>	
	 <cfset mt = month(now())>	
	 <cfset da = day(now())>	
	 
	 <cfset dateto = dateformat(now(),"YYYYMMDD")>
	 
	 <cfset date = CreateDate(yr, mt, da)>
	 		
	 <cfif url.time eq "month">	 
	   <cfset date = DateAdd("m", -1,date)> 	   
	 <cfelseif url.time eq "week">	 
	    <cfset date = DateAdd("d", -7,date)> 		
	 <cfelseif url.time eq "day">	 
	    <cfset date = DateAdd("d", -1,date)> 	
	 </cfif>	
	 
	 <cfset datefrom = dateformat(date,"YYYYMMDD")>
			
	 <cfquery name="SearchTotal" dbtype="query">
		SELECT   count(*) as Total
		FROM     CollectionResult
		WHERE    1 = 1
		<cfif url.category neq "">
		AND    Category = '#url.category#'
		</cfif>
		<cfif url.time neq "">
		AND    Custom2 between '#datefrom#' AND '#dateto#' 
		</cfif>		
	 </cfquery>	
	 	 	 
	<cfset counted = 0>
			 
	 <cfif SearchTotal.total gt 0>
	 	 <cfset counted = SearchTotal.total>
	 </cfif>	 
	 
	 <cf_PageCountN count="#counted#">
     <cfset last = counted>		 
	  
	<!--- ------------------------ ---> 
	<!--- make a detail assessment --->
	<!--- ------------------------ --->
		
	<cfif url.time eq "">
	
		    <!--- no need to make double queries for the time filtering --->	
		
			<cfsearch collection="#collection.collectionname#" 
				name                  = "SearchResult" 
				criteria              = "#lcase(form.searchtext)#" 
				startrow              = "#first#" 
				maxrows               = "#CLIENT.PageRecords#"		
				category              = "#url.category#"
				language              = "English"
				Status                = "Info"
				Suggestions           = "5"		
				ContextBytes          = "300"
				ContextPassages       = "4"
				ContextHighlightBegin = "<B>"
				ContextHighlightEnd   = "</B>">	
	
	<cfelse>
		
			<cfsearch collection="#collection.collectionname#" 
				name                  = "CollectionDetailResult" 
				criteria              = "#lcase(form.searchtext)#" 
				startrow              = "#first#" 		
				language              = "English"
				Status                = "Info"
				category              = "#url.category#"
				Suggestions           = "5"		
				ContextBytes          = "300"
				ContextPassages       = "4"
				ContextHighlightBegin = "<B>"
				ContextHighlightEnd   = "</B>">	
				
				<cfquery name="SearchResult" dbtype="query" maxrows = "#CLIENT.PageRecords#" >
					SELECT   *
					FROM     CollectionDetailResult				
					<cfif url.time neq "">
					WHERE    Custom2 between '#datefrom#' AND '#dateto#' 
					</cfif>
			    </cfquery>	
			
	 </cfif>		
	 
	 <!--- logging of the search --->
		
	 <cf_assignid>
						
	 <cfquery name="Logging" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO CollectionLog
			(SearchId,
			 CollectionId, 
			 SearchCriteria, 
			 SearchResults, 
			 SearchBase, 
			 SearchTime, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		VALUES
			('#rowguid#',
			 '#url.collectionid#',
			 '#Lcase(form.searchtext)#',
			 '#info.found#',
			 '#info.searched#',
			 '#info.time#',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')  
	 </cfquery>
	 
	 <cfloop query="searchresult">
	 
	     <cfif len(key) lte "50">
	 
		 <cfquery name="LoggingResult" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO CollectionLogResult
				(SearchId,Category,RecordKey)
			VALUES
				('#rowguid#','#category#','#key#')  
		 </cfquery>
		 
		 </cfif>
	 
	 </cfloop>
	 
	 <cfset url.searchid = rowguid>