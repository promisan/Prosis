
<cfquery name="Drop"
	datasource="#url.dsn#">
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>

<cfparam name="session.listingquery" default="">

<cfset substr = left(session.listingquery,30)>

<cfif findNoCase(" TOP ",substr)>

    <cfset qry =  session.listingquery> 	
	
<cfelse>

    <cfif findNoCase("DISTINCT",substr)>
		<cfset qry =  replaceNoCase(session.listingquery,"SELECT DISTINCT","SELECT DISTINCT TOP 5000")> 	
	<cfelse>
		<cfset qry =  replaceNoCase(session.listingquery,"SELECT","SELECT TOP 5000")> 	
	</cfif>
	
</cfif>	

<cfquery name="Listing" 
    datasource="#url.dsn#">
	CREATE VIEW dbo.vwListing#SESSION.acc# AS 
	#preservesinglequotes(qry)#    	
</cfquery> 

<cfset table1   = "vwListing#SESSION.acc#">	
