<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
