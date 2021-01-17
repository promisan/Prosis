<cfparam name="URL.TableName" default="#session.acc#_#url.mission#_GeneralLedgerActions">

<cfoutput>
	<cfsavecontent variable="sqlbody">
		SELECT	*
		FROM	UserQuery.dbo.#URL.TableName#
	</cfsavecontent>
</cfoutput>

<!--- Hanno --->

<!----
show : 

Date
UnitCode
UnitName
ActionDescription
ActionStatus
Officer

<br>
group by OrgUnit (store) and show the last one first.

<br>
I will prepare a landing screen to procees the editing from 

--->

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>
					
<cfset itm = 1>			
<cfset fields[itm] = {label       = "Event Date",                   
					field         = "EventDate",	
					formatted	  = "dateformat(EventDate,client.dateformatshow)",		
					search        = "text"}>		
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Unit Code", 
					field         = "OrgUnit",
					search        = "text"}>					
									
<cfset itm = itm+1>	
<cfset fields[itm] = {label       = "Org Unit Name", 
					field         = "OrgUnitName",
					search        = "text"}>
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label       = "Action Description", 
					field         = "EventDescription",
					search        = "text"}>							
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",		
					selectfield   = "ActionStatusName",			
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>													
						
<cfset itm = itm+1>											
<cfset fields[itm] = {label       = "Officer",    
					field         = "OfficerUserId",		
					search        = "text"}>	

								
<cf_listing
	header         = "EventListing"
	box            = "EventListing"
	link	       = "#SESSION.root#/Gledger/Application/Event/EventListingContent.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&Period=#URL.Period#&TableName=#URL.TableName#"
	html           = "No"                           
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsQuery"
	listquery      = "#sqlBody#"
	listorderfield = "EventDate"
	listorder      = "EventDate"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	annotation     = "GLEvent"
	show           = "35"               
	showrows       = "2"  
	filtershow     = "Hide"
	excelshow      = "Yes"                       
	listlayout     = "#fields#"
	allowgrouping  = "Yes"
	listgroup	   = "Mission"
	listgroupdir   = "ASC"
	drillmode      = "tab" 
	drillargument  = "#client.height-400#;850;true;true"                                       
	drilltemplate  = "Gledger/Application/Event/EventView.cfm?id="
	drillkey       = "EventId"
	drillbox       = "addcasefile">
										
