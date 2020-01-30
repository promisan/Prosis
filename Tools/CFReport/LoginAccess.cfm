
<cfparam name="SESSION.login" default=""> 
<cfparam name="SESSION.dbpw"  default=""> 
<cfparam name="SESSION.root"  default="">

<cfquery name="Parameter" 
   	 datasource="AppsInit">
	 SELECT  *
	 FROM    Parameter
	 WHERE   HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfif SESSION.login eq "" or SESSION.root eq "">

	<cfif Len(Trim(Parameter.DefaultPassword)) gt 20> 
    	  <!--- encrypt password --->
	      <cf_decrypt text = "#Parameter.DefaultPassword#">
		  <cfset password = Decrypted>
	      <!--- end encryption --->
	<cfelse>	  
    	  <cfset password = Parameter.DefaultPassword>
	</cfif>	  

	<cfset SESSION.dbpw            = "#password#">
	<cfset SESSION.login           = "#Parameter.DefaultLogin#">	
		  
</cfif>	

<cfset SESSION.root            = "#Parameter.ApplicationRoot#"> 
<cfset SESSION.rootPath        = "#Parameter.ApplicationRootPath#"> 
<cfset SESSION.rootreport      = "#Parameter.ReportRoot#"> 
<cfset SESSION.rootReportPath  = "#Parameter.ReportRootPath#">      