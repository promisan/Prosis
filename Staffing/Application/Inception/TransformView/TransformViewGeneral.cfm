
<cf_listingscript>

<cfquery name="Action" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   EmployeeAction
	WHERE  ActionDocumentNo = '#URL.ID4#' 
</cfquery>

<cfoutput>

	<cfsavecontent variable="myquery">
	
	<cfif action.ActionSource eq "Assignment">
	
	 SELECT E.PersonNo, 
	        E.IndexNo, 
			E.FirstName, 
			E.LastName, 
			E.Gender,
			E.Nationality,
			A.PostType,
			Po.PostGrade,
			R.Postorder,
			PA.DateEffective, 
			PA.DateExpiration,
		    Po.SourcePostNumber, 
			PA.FunctionDescription
     FROM   EmployeeAction A, 
	        EmployeeActionSource A1, 
			PersonAssignment PA, 
			Ref_PostGrade R, 
			Position Po, 
			Person E
	 WHERE  A.Mission   = '#Action.Mission#'
	   AND  A.MandateNo = '#Action.MandateNo#'
	    AND Po.PostGrade = R.PostGrade
	   AND  A.ActionDocumentNo = A1.ActionDocumentNo
	   AND  A1.ActionSourceNo  = PA.AssignmentNo
	   AND  PA.PositionNo      = Po.PositionNo
	   AND  E.PersonNo         = PA.PersonNo
	   AND  A.ActionDocumentNo = '#URL.ID4#'  
	           
   <cfelse>
   
   	 SELECT E.PersonNo, 
	        E.IndexNo, 
			E.FirstName, 
			E.LastName, 
			E.Gender,
			E.Nationality,
			R.PostOrder,
			PA.ContractLevel,
			PA.ContractType,
			PA.AppointmentStatus,
			PA.ContractStep,
			PA.DateEffective, 
			PA.DateExpiration		  
			
     FROM   EmployeeAction A, 
	        EmployeeActionSource A1, 
			PersonContract PA,
			Ref_PostGrade R, 
			Person E
	  WHERE  A.Mission  = '#Action.Mission#'
	   AND  A.MandateNo = '#Action.MandateNo#'
	   AND  PA.ContractLevel = R.PostGrade
	   AND  A.ActionDocumentNo  = A1.ActionDocumentNo
	   AND  A1.ActionSourceId = PA.Contractid	   
	   AND  E.PersonNo = PA.PersonNo
	   AND  A.ActionDocumentNo = '#URL.ID4#'
	         
   </cfif>
   
   </cfsavecontent>
      
	
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfif action.ActionSource eq "Assignment">

	<cfset fields[1] = {label   = "IndexNo", 	                   
						field   = "IndexNo",
						search  = "text"}>
						
	<cfset fields[2] = {label   = "Last name", 	                    
						field   = "LastName",
						filtermode = "1",
						search  = "text"}>					
						
	<cfset fields[3] = {label   = "First name", 	                   
						field   = "FirstName",
						filtermode = "1",
						search  = "text"}>
							
	<cfset fields[4] = {label   = "S", 						
						field   = "Gender",					
						filtermode = "2",    
						search  = "text"}>					
						
	<cfset fields[5] = {label      = "PostType",    						
						field      = "PostType",
						filtermode = "2",
						fieldsort  = "PostType",
						search     = "text"}>
						
	<cfset fields[6] = {label      = "Grade",   						
						field      = "PostGrade",
						filtermode = "2",
						fieldsort  = "PostOrder",
						search     = "text"}>		
						
	<cfset fields[7] = {label      = "Number",    						
						field      = "SourcePostNumber",						
						search     = "text"}>												
											
	<cfset fields[8] = {label      = "Effective", 						
						field      = "DateEffective",
						search     = "date",
						formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
						
	<cfset fields[9] = {label      = "Expiration",  						
						field      = "DateEffective",
						formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	


<cfelse>
	
	<cfset fields[1] = {label   = "IndexNo", 	                   
						field   = "IndexNo",
						search  = "text"}>
						
	<cfset fields[2] = {label   = "Last name", 	                 
						field   = "LastName",
						filtermode = "1",
						search  = "text"}>					
						
	<cfset fields[3] = {label   = "First name", 	                 
						field   = "FirstName",
						filtermode = "1",
						search  = "text"}>
							
	<cfset fields[4] = {label   = "S", 
						field   = "Gender",					
						filtermode = "2",    
						search  = "text"}>					
						
	<cfset fields[5] = {label      = "Grade", 						
						field      = "ContractLevel",
						filtermode = "2",
						fieldsort  = "PostOrder",
						search     = "text"}>
						
	<cfset fields[6] = {label      = "Step",  					
						field      = "ContractStep"}>	
						
	<cfset fields[7] = {label      = "Contract",  						
						filtermode = "2",
						fieldsort  = "ContractType",
						field      = "ContractType"}>	
						
	<cfset fields[8] = {label      = "Appointment",  						
						filtermode = "2",
						fieldsort  = "AppointmentStatus",
						field      = "AppointmentStatus"}>												
											
	<cfset fields[9] = {label      = "Effective", 						
						field      = "DateEffective",
						search     = "date",
						formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
						
	<cfset fields[10] = {label      = "Expiration",   						
						field      = "DateEffective",
						formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>	
						
</cfif>															
							
<cf_listing
    header        = "Inception Action"
    box           = "contract"
	link          = "#SESSION.root#/Staffing/Application/Inception/TransformView/TransformViewGeneral.cfm?id4=#url.id4#"
    html          = "No"
	show          = "50"
	datasource    = "AppsEmployee"
	listquery     = "#myquery#"
	listkey       = "personNo"
	listorder     = "LastName"
	listorderdir  = "ASC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "window"
	drillargument = "940;1100;false;false"	
	drilltemplate = "Staffing/Application/Employee/PersonView.cfm?id="
	drillkey      = "PersonNo">   
     
</cfoutput>   