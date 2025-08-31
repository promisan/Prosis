<!--
    Copyright © 2025 Promisan B.V.

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