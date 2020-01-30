
<cfset vDefault = evaluate("Form.#Code#_Default")>
<cfset vContext = evaluate("Form.#Code#_Context")>

<cfquery name="UpdateServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_TopicServiceItem
	SET    FieldDefault 	 = '#vDefault#',
		   ShowInContext	 = '#vContext#'
	WHERE  ServiceItem       = '#URL.ID1#'		
	AND    Code			     = '#code#'
</cfquery>

<cfset URL.Code = "">
<cfinclude template="ServiceItemTopic.cfm">	