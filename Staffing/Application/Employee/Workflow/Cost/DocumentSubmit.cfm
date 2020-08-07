

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PersonMiscellaneous
WHERE    PersonNo   = '#Object.ObjectKeyvalue1#'
AND      CostId     = '#Object.ObjectKeyvalue4#'
</cfquery>

<cfif Entitlement.recordCount eq 1> 
			
	  <cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE  PersonMiscellaneous
		   SET     DateEffective = #STR#,					  
				   Currency      = '#Form.Currency#',
				   Amount        = '#Form.Amount#'
		   WHERE   PersonNo      = '#Object.ObjectKeyvalue1#'
		   AND     CostId        = '#Object.ObjectKeyvalue4#'
	  </cfquery>
		  
	  <cfquery name="Justification" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    PersonMiscellaneousAction 
			WHERE   PersonNo   = '#Object.ObjectKeyValue1#'
			AND     CostId     = '#Object.ObjectKeyValue4#'
			AND     ActionCode = 'Justification'
	  </cfquery>
	
	  <cfif Justification.recordcount eq "1">
	
		<cfquery name="EditJustification" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE  PersonMiscellaneousAction
			   SET     ActionContent = '#Form.ActionContent#'
			   WHERE   PersonNo      = '#Object.ObjectKeyvalue1#'
			   AND     CostId        = '#Object.ObjectKeyvalue4#'
			   AND     ActionCode    = 'Justification'
		   </cfquery>
	
	  <cfelse>
	
		<cfquery name="InsertJustification" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO PersonMiscellaneousAction
				         (PersonNo,
						  CostId,
						  ActionCode,
						  ActionContent, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)				
			  VALUES ('#Object.ObjectKeyvalue1#',
			          '#Object.ObjectKeyvalue4#',
					  'Justification',
					  '#Form.ActionContent#',
			          '#session.acc#',
					  '#session.last#',
					  '#session.first#')
	     </cfquery>		
	
	  </cfif>
	  
 </cfif>
	
	


