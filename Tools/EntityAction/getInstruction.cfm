
<!--- instruction --->

<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObjectAction OA, 
	           Ref_EntityActionPublish P		
	   WHERE   ActionId = '#URL.ActionId#' 
	   AND     OA.ActionPublishNo = P.ActionPublishNo
	   AND     OA.ActionCode = P.ActionCode 	  
	</cfquery>

<cfoutput>

<table style="height:100%"><tr class="labelmedium">
<td valign="top">#Action.ActionSpecification#</td></tr></table>

</cfoutput>