
<cfquery name="TopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    R.*
	     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE     ElementClass = '#url.elementclass#'	
		 AND       Operational = 1
		 AND       (Mission = '#url.Mission#' or Mission is NULL)	
		 AND      ValueClass != 'Memo'       
		 AND       R.TopicClass != 'Person'
		 ORDER BY S.ListingOrder, R.ListingOrder
</cfquery>

<cftry>
	
	<cfquery name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		 SELECT TOP 1 * FROM userquery.dbo.tmp#SESSION.acc#ElementMatched_#url.fileno#
	</cfquery>
	
	<cfoutput>
	<cfsavecontent variable="myquery">
		SELECT * FROM userquery.dbo.tmp#SESSION.acc#ElementMatched_#url.fileno#
	</cfsavecontent>
	</cfoutput>
	
<cfcatch>

	<table align="center" class="labelmedium">
		<tr><td><font face="Verdana" size="2" color="808080">Problem retrieving data</td></tr>
	</table>
	<cfabort>

</cfcatch>	

</cftry>

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
		<cfset fields[itm] = {label      		= "#client.indexnoName#", 					
						     field      		= "IndexNo",											
						     display    		= "Yes",
						     search     		= "text"}>	
	
		<cf_tl id="LastName" var="1">
	
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "LastName",											
						     display    		= "Yes",
						     search     		= "text"}>	
							 
							 
		<cf_tl id="2nd LastName" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "LastName2",											
						     display    		= "Yes",
						     search     		= "text"}>	
		
		<cf_tl id="FirstName" var="1">
		
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "FirstName",											
						     display    		= "Yes",
						     search     		= "text"}>		
		
		<cf_tl id="2nd FirstName" var="1">
							 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "MiddleName",											
						     display    		= "Yes",
						     search     		= "text"}>							 
		
		<cf_tl id="Gender" var="1">
							 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "Gender",											
						     display    		= "Yes",
						     search     		= "text"}>		
		
		<cf_tl id="DOB" var="1">
							 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label      		= "#lt_text#", 					
						     field      		= "DOB",											
						     display   			= "Yes",
							 formatted  		= "dateformat(dob,CLIENT.DateFormatShow)",
						     search     		= "text"}>		
		
		<cf_tl id="PersonNo" var="1">
							 
		<cfset itm = itm + 1>						
		<cfset fields[itm] = {label     		= "#lt_text#", 					
						     field      		= "PersonNo",	
							 functionscript		= "ShowCandidate",										
						     display    		= "Yes",
						     search     		= "text"}>							 					 								 								 								 			
						
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
			
			<cfset fields[itm] = {label  	  = "#lbl#",                    
								 field        = "#fld#", 						
								 search       = "text"}>		
		
		</cfloop>
	
	</cfif>
		
	<cfset itm = itm + 1>						
	<cfset fields[itm] = {label     		 = "CaseElementId", 					
					     field      		 = "CaseElementId",											
					     display    		 = "No",
					     search     		 = "text"}>					
	
<cfset menu=ArrayNew(1)>	

<cfquery name="List" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM   userquery.dbo.tmp#SESSION.acc#ElementMatched_#url.fileno#
</cfquery>
	
<cf_listing
    header        = "elementmatchlist"
    box           = "linedetail#url.elementclass#"
	link          = "#SESSION.root#/CaseFile/Application/Element/Create/ElementMatchedContent.cfm?mission=#url.mission#&elementclass=#url.elementclass#&fileno=#url.fileno#"
    html          = "no"		
	tableheight   = "#250+list.recordcount*20#"
	tablewidth    = "100%"
	datasource    = "AppsQuery"
	listquery     = "#myquery#"
	listorderfield = "Created"
	listorder      = "Created"
	listorderdir   = "ASC"
	headercolor   = "ffffff"
	show          = "10"				
	filtershow    = "Hide"
	excelshow     = "Yes" 		
	listlayout    = "#fields#"
	selectmode    = "checkbox"		
	drillmode     = "dialog" 
	drillargument = "750;930;true;true"	
	drilltemplate = "CaseFile/Application/Element/Create/ElementEdit.cfm"
	drillkey      = "ElementId"
	drillstring	  = "mode=view"
	drillbox      = "addelement">							  