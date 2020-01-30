
<cfoutput>
	<cfsavecontent variable="myquery">
	   SELECT *
	   FROM (	
			   SELECT 	*, (SELECT 	ActionName
			   				FROM 	stPersonnelActionDetail Dx
			   				WHERE 	Dx.ActionId = A.ActionId
			   				AND 	Dx.SerialNo = 1 ) as Description,
							
							(SELECT 	DateEffective
			   				FROM 	stPersonnelActionDetail Dx
			   				WHERE 	Dx.ActionId = A.ActionId
			   				AND 	Dx.SerialNo = 1 ) as ActionEffective,
							
							(SELECT 	YEAR(DateEffective)
			   				FROM 	stPersonnelActionDetail Dx
			   				WHERE 	Dx.ActionId = A.ActionId
			   				AND 	Dx.SerialNo = 1 ) as RequestYear	
						
						
			   FROM   	stPersonnelAction A
			   WHERE 	A.PersonNo = '#url.id#' ) as D
		WHERE 1=1	   
			   			   
	</cfsavecontent>
</cfoutput>



<cfset fields=ArrayNew(1)>

<cfset itm = "1">								
<cfset fields[itm] = {label      = "Year", 					
					field      = "RequestYear",											
					filtermode = "2",
					search     = "text"}>
					
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Effective", 					
					field      = "ActionEffective",											
					filtermode = "4",
					search     = "date",
					formatted  = "dateformat(ActionEffective,client.dateformatshow)"}>					

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Action No", 					
					field      = "PersonnelActionNo",											
					filtermode = "4",
					search     = "text"}>

<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Description", 					
					field      = "Description",											
					filtermode = "2",
					search     = "text"}>	

<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Requester", 					
					field      = "RequestOfficer"}>	
					
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Requested", 					
					field      = "RequestDate",											
					filtermode = "4",
					search     = "date",
					formatted  = "dateformat(RequestDate,client.dateformatshow)"}>					

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Certifier", 					
					field      = "CertifyOfficer",											
					filtermode = "2",
					search     = "text"}>

<!---					
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Approver", 					
					field      = "ApproveOfficer",											
					filtermode = "2",
					search     = "text"}>
					--->

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "ActionId", 					
					field      = "ActionId",
					display    ="no"}>

					
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Remarks", 					
					field      = "Remarks",											
					filtermode = "4",
					search     = "text",
					rowlevel   = "2",
					colspan    = "7"}>
		
<!--- embed|window|dialogajax|dialog|standard --->

<table width="100%" height="99%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td width="100%" height="100%">						
	
	<cf_listing header  = "PersonnelAction"
	    box           = "actiondetail"
		link          = "#SESSION.root#/Staffing/Application/Employee/History/ActionListContent.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#"
	    html          = "No"		
		datasource    = "AppsEmployee"
		listquery     = "#myquery#"
		listorder     = "ActionEffective"
		listorderdir  = "ASC"
		headercolor   = "ffffff"				
		tablewidth    = "99%"
		listlayout    = "#fields#"
		FilterShow    = "Show"
		ExcelShow     = "Yes"
		drillmode     = "securewindow" 
		drillargument = "800;1100;true;true"	
		drilltemplate = "Staffing/Application/Employee/History/ActionView.cfm?drillid="
		drillkey      = "ActionId">	
		
	</td></tr>

</table>	