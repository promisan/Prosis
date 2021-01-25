
<cfquery name="Drop"
	datasource="#url.dsn#">
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>

<cfparam name="session.listingdata['#url.box#']['sql']" default="">

<cfset substr = left(session.listingdata[url.box]['sql'],30)>

<cfif findNoCase(" TOP ",substr)>

    <cfset qry =  session.listingdata[url.box]['sql']> 	
	
<cfelse>

    <cfif findNoCase("DISTINCT",substr)>
		<cfset qry =  replaceNoCase(session.listingdata[url.box]['sql'],"SELECT DISTINCT","SELECT DISTINCT TOP 50000")> 	
	<cfelse>
		<cfset qry =  replaceNoCase(session.listingdata[url.box]['sql'],"SELECT","SELECT TOP 50000")> 	
	</cfif>
	
</cfif>	

<cfquery name="Listing" 
    datasource="#url.dsn#">	
	CREATE VIEW dbo.vwListing#SESSION.acc# AS 
	#preservesinglequotes(qry)#    
	
</cfquery> 

<cfset table1   = "vwListing#SESSION.acc#">	
