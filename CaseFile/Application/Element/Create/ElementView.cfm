
<cfif key neq "">
	
	<cfquery name="get" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT    *
		     FROM      Element		
			 WHERE     ElementId = '#key#'			
	</cfquery>
	
	<cfquery name="getTopicList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT    R.*, S.ElementClass
		     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE     ElementClass = '#get.elementclass#'	
			 AND       Operational = 1
			 AND       TopicClass != 'Person'
			 ORDER BY  S.ListingOrder,R.ListingOrder 
	</cfquery>
	
	<cfset element          = get.elementid>
	<cfset personno         = get.personno>
	<cfset elementclass     = get.elementclass>
	
	<cfparam name="colorlabel"    default="black">
	<cfparam name="fontsizelabel" default="1">
	<cfparam name="fontsize"      default="2">
	<cfparam name="showcols"      default="3">
	
	<table width="100%" >
	
	<cfinclude template="../Create/ElementViewCustom.cfm">
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="6" class="linedotted"></td></tr>
	
	<tr><td colspan="6">
	    
			<cf_filelibraryN
				DocumentPath="CaseFileElement"
				SubDirectory="#key#" 						
				Filter = ""							
				Insert="no"
				Color = "transparent"
				Remove="no"							
				width="100%"			
				border="1">	
	  
	 </td>
	 </tr>
	
	</table>
	
</cfif>	

	