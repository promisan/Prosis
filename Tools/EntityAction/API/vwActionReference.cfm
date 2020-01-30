<cfparam name="attributes.objectid" default="">


<cfquery name="Actions" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     OA.ActionFlowOrder, 
		           R.ActionDescription, 
				   OA.ActionCode, 
				   OA.ActionReferenceDate, 
				   OA.ActionReferenceNo
		FROM       OrganizationObjectAction OA INNER JOIN
                   Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
		WHERE      OA.ObjectId = '#attributes.ObjectId#' 
		   AND     OA.ActionFlowOrder IN
                          (SELECT     MAX(ActionFlowOrder)
                            FROM          OrganizationObjectAction
                            WHERE      ObjectId = OA.ObjectId AND ActionCode = OA.ActionCode) 
			AND   R.ActionReferenceEntry = 1
        ORDER BY OA.ActionFlowOrder
		</cfquery>
				
		<tr><td height="4"></td></tr>		
		<cfoutput query="Actions">
			<tr>
			<td height="22">&nbsp;&nbsp;&nbsp;#ActionDescription#</td>
			<td>
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="100">#DateFormat(actionReferenceDate,CLIENT.DateFormatShow)#</td>
				<td>#ActionReferenceNo#</td>
			</tr>
			</table>		
			</td>
			</tr>
		</cfoutput>