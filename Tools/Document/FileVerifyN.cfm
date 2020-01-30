
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<CFParam name="Attributes.Root"      default="#SESSION.rootPath#">
<CFParam name="Attributes.Directory" default="yes"> 
<CFParam name="Attributes.File"      default="SQL.cfm">   
<CFParam name="Attributes.TimeStamp" default="01/01/01">

<cfset caller.filestatus = "same">
<cfset caller.filestamp  = "#Attributes.TimeStamp#">

<!---
<cftry>
--->

<cfif Get.EnableCM eq "1">
	
	<cfif DirectoryExists("#attributes.root#\#Attributes.Directory#")>
	      
		  <cfdirectory action="LIST" 
		directory="#attributes.root#\#Attributes.Directory#" 
		name="GetFiles" 
		sort="DateLastModified DESC" 
		filter="#Attributes.File#">
				
		<cfif GetFiles.DateLastModified gt Attributes.TimeStamp 
		   or getFiles.DateLastModified eq "">
		   	   
				<cfset caller.filestatus = "changed">
				<cfset caller.filestamp  = "#GetFiles.DateLastModified#">
				
		<cfelse>	
		
				<cfset caller.filestatus = "same">	
				<cfset caller.filestamp  = "#GetFiles.DateLastModified#">
						
		</cfif>			  		  
	
	<cfelse> 
	
			<cfset caller.filestatus = "notfound #attributes.root#\#Attributes.Directory#">		
		   <!--- <cfdirectory action="CREATE" 
             directory="#SESSION.rootDocumentPath#\#Attributes.DocumentPath#\#Attributes.SubDirectory#">
			 --->
	</cfif>
	
	<!---	
	<cfcatch></cfcatch>	
	</cftry>	
	--->

</cfif>
