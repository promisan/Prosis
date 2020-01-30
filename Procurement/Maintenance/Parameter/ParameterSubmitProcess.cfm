
<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET LinesInView              = '#Form.LinesInView#',
    	RequisitionProcessMode	 = '#Form.RequisitionProcessMode#',
		EnableActorMail          = '#Form.EnableActorMail#',
		OfficerUserId 	 		 = '#SESSION.ACC#',
		OfficerLastName  		 = '#SESSION.LAST#',
		OfficerFirstName 		 = '#SESSION.FIRST#',
		Created          		 =  getdate()				
	WHERE Mission                = '#url.Mission#'
</cfquery>


<cfinclude template="ParameterEditReqProcess.cfm">
