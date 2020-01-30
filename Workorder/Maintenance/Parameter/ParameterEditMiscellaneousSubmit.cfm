
<cfset dateValue = "">
<CF_DateConvert Value="#form.DateChargesCalculate#">
<cfset chargesDate = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#form.DatePostingStart#">
<cfset postingDateStart = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#form.DatePostingCalculate#">
<cfset postingDate = dateValue>

<cfquery name="Update" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE 	Ref_ParameterMission
SET 	TreeCustomer          = <cfif trim(form.TreeCustomer) eq "">null<cfelse>'#Form.TreeCustomer#'</cfif>,
		CustomerDetail        = #Form.CustomerDetail#,
		DocumentHost          = <cfif trim(form.DocumentHost) eq "">null<cfelse>'#Form.DocumentHost#'</cfif>,
		DocumentLibrary       = <cfif trim(form.DocumentLibrary) eq "">null<cfelse>'#Form.DocumentLibrary#'</cfif>,
		DateChargesCalculate  = #chargesDate#,
		DatePostingStart      = #postingDateStart#,
		DatePostingCalculate  = #postingDate#,
		PostingMode           = <cfif trim(form.PostingMode) eq "">null<cfelse>'#Form.PostingMode#'</cfif>,
		OfficerUserId 	 	  = '#SESSION.ACC#',
		OfficerLastName  	  = '#SESSION.LAST#',
		OfficerFirstName      = '#SESSION.FIRST#',
		Created               =  getdate()		
WHERE 	mission               = '#Form.mission#'
</cfquery>

<cfoutput>
<script>
	ColdFusion.navigate('ParameterEditMiscellaneous.cfm?ID1=#Form.mission#','contentbox1')
</script>
</cfoutput>