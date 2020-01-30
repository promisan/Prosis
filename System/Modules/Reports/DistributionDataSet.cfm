
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ReportDistribution">

<cfquery name="FactTable" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     D.LayoutClass AS LayoutClass_dim, 
	           D.LayoutName AS LayoutName_dim, 
			   D.FileFormat AS Format_dim, 
			   D.Account AS Account_dim, 
	           U.FirstName + ' ' + U.LastName AS Account_nme, 
			   DATEDIFF(second, D.PreparationStart, D.PreparationEnd) AS PreparationTime_dim, 
	           YEAR(D.PreparationEnd) AS Year_dim, 
			   MONTH(D.PreparationEnd) AS Month_dim,
			   DistributionName,
			   DistributionEMail,
			   DistributionId as FactTableId,
			   PreparationEnd as Date
	INTO       UserQuery.dbo.#SESSION.acc#ReportDistribution		   
	FROM       UserReportDistribution AS D INNER JOIN
	           UserNames AS U ON D.Account = U.Account
	WHERE      D.ControlId = '#url.id#'   
	 AND       D.PreparationEnd > D.PreparationStart
	 AND       D.FileFormat <> 'Excel'
</cfquery> 


<cfquery name="FactTable" 
datasource="AppsqUERY" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
Select top 1 * FROM #SESSION.acc#ReportDistribution	
</cfquery>

<cf_waitEnd>

<cfif FactTable.recordcount eq "0">
<cf_message message="Sorry no records found" return = "no" layout="Round">
<cfabort>
</cfif>

<cfset client.table1_ds = "#SESSION.acc#ReportDistribution">