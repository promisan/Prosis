
<cfquery name="Delete" 
 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    OutputShow = 0
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId = '#URL.ID#'
	 AND    OutputClass IN ('Detail','Group1','Group2')
	 <cfif  URL.Name neq "">
	 AND    FieldName = '#URL.Name#'
	 </cfif>
</cfquery>

<!--- open screen again --->

<cfinclude template="FormatExcelDetail.cfm">

