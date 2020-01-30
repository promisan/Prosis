<cfquery name="List" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT A.*, S.ActionFieldEffective, (SELECT TOP 1 ActionFieldValue
	               FROM   EmployeeActionSource
				   WHERE  ActionDocumentNo = S.ActionDocumentNo
				   AND    ActionStatus = '9') as FieldValue
	  FROM   EmployeeAction A,
    		 EmployeeActionSource S
	  WHERE  A.ActionDocumentNo = S.ActionDocumentNo		 
            AND    S.PersonNo  = '#URL.ID#'
	  AND    S.ActionStatus = '1'
	  AND    A.ActionStatus != '9'
	  AND    A.ActionCode      = '#URL.ActionCode#'
	  ORDER BY A.Created DESC		
   </cfquery>

<table cellspacing="0" cellpadding="0">
  <tr class="line labelmedium">
  	<td style="min-width:200">Officer</td>
	<td style="min-width:100">Recorded</td>
	<td style="min-width:100">Expiry</td>
	<td style="min-width:200">Value</td>
	<td style="min-width:200">Memo</td>
  </tr>  
  <cfoutput query="List">
   <tr class="labelmedium line">
   <td>#OfficerLastName#</td>
   <td>#Dateformat(Created,CLIENT.DateFormatShow)#</td>
   <td>#Dateformat(ActionFieldEffective,CLIENT.DateFormatShow)#</td>
   <td>#FieldValue#</td>
   <td>#ActionDescription#</td>
   </tr>			  
  </cfoutput>
</table>		