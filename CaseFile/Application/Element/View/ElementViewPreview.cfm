
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
		 AND       R.TopicClass != 'Person'
		 ORDER BY  S.ListingOrder,R.ListingOrder
</cfquery>

<cfset element          = get.elementid>
<cfset personno         = get.personno>
<cfset elementclass     = get.elementclass>

<cfparam name="colorlabel" default="gray">
<cfparam name="fontsize"   default="2">

<cfinclude template="../Create/ElementViewCustom.cfm">

	