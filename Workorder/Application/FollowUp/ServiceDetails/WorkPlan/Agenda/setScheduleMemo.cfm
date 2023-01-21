
<cfset memo = evaluate("form.Memo_#left(url.id,8)#")>

<cfquery name="setWorkActionMemo" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE WorkPlanDetail
	SET    Memo = '#memo#'
	WHERE  WorkPlanDetailId = '#url.id#' 
</cfquery>
