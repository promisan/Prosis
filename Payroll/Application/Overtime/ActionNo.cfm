<cfquery name="GetLastNumber" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * FROM Parameter
	 </cfquery>
	 
	 <cfset Caller.NoAct = GetLastNumber.ActionNo + 1>
	 
	 <cfquery name="GetLastNumber" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 UPDATE Parameter
	 SET ActionNo = #Caller.NoAct#
	 </cfquery>
	 
	  <cfquery name="InsertActivity" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO EntitlementAction
         (ActionDocumentNo,
		 ActionCode,
		 ActionPersonNo,
		 ActionSource,
		 ActionDescription,
		 Mission,
		 MandateNo,
		 PostType,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,
		 ActionDate)
      VALUES (
          #Caller.NoAct#,
		  '',
		  '#Attributes.Person#',
		  '#Attributes.Action#',
		  '',
		  '',
		  '',
		  '',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  '#DateFormat(Now(),CLIENT.dateSQL)#')
	 </cfquery>
	 