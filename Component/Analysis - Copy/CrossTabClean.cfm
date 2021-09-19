
<cf_compression>

<cfquery name="Report" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *     
	FROM      Ref_ReportControlOutput
    WHERE     ControlId = '#URL.ControlId#' 
</cfquery>

<cfquery name="Drop"
	datasource="#Report.Datasource#">	
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>
