
<!--- register dataset --->
<cfoutput>
<cfset link = "">
<cfloop index="itm" list="#CGI.QUERY_STRING#" delimiters="&">
   <cfif left("#itm#",9) eq "ControlId" or left("#itm#",11) eq "AjaxRequest">
   <cfelse>
     <cfif link eq "">
	   <cfset link = "#itm#">
	 <cfelse>
	   <cfset link = "#link#&#itm#">
	 </cfif>
   </cfif>
</cfloop>

</cfoutput>

<cfquery name="Report" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Ref_ReportControl R
	    WHERE     ControlId = '#URL.ControlId#'  
</cfquery>

<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Ref_ReportControlOutput R
	    WHERE     ControlId         = '#URL.ControlId#'
		AND       OutputQueryString = '#link#'
</cfquery>
		
<cfif Check.recordcount eq "0">

	<cfquery name="Count" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    count(*) as Total
		FROM      Ref_ReportControlOutput
	    WHERE     ControlId = '#URL.ControlId#'
	</cfquery>
					
	<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ReportControlOutput
				(ControlId, 
				 DataSource, 
				 VariableName, 
				 OutputName, 
				 OutputQueryString,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName) 
		 VALUES
			 ('#controlId#',
			  'appsOLAP',
			   '#replaceNoCase("#Report.FunctionName#"," ","_")#_fact_#count.total+1#',
			   '#Report.FunctionName#',
			   '#link#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#')
	</cfquery>
	
	<cfset tble = replaceNoCase("#Report.FunctionName#"," ","_")>
				
	<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Ref_ReportControlOutput R
		    WHERE     ControlId = '#URL.ControlId#'
			AND       OutputQueryString = '#link#'
	</cfquery>
		
		<cfset tble = "#Report.FunctionName#_fact_#count.total+1#">
		
<cfelse>	

		<cfset tble = "#Check.VariableName#">	
		
</cfif>

<cfset tble = replaceNoCase("#Check.VariableName#"," ","_")>

<!--- perform query --->

<cf_droptable 
  dbname="AppsOLAP" 
  tblname="#tble#">

<!--- locate the template and the querystring to be performed ---> 

<cfinclude template="../../#report.ReportPath#">

<cfparam name="DetailKey"      default="">
<cfparam name="DetailTemplate" default="">
	
<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControlOutput
	SET    DetailKey         = '#DetailKey#',
	       DetailTemplate    = '#DetailTemplate#',
	       OfficerUserId     = '#SESSION.acc#',
	       OfficerLastName   = '#SESSION.last#',
		   OfficerFirstName  = '#SESSION.first#',
		   Created = #now()#
	WHERE  OutputId = '#Check.OutputId#' 
</cfquery>

<cfinvoke component="Service.Dataset.Dataset" 
	 method="Listing"
	 ControlId        = "#URL.ControlId#">	 



