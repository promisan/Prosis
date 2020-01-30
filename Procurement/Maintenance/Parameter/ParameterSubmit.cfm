
<cfif Form.MissionPrefix eq "">
	
	<script>
	alert("You must submit a entity prefix.")		
	</script>	
	<cfabort>

</cfif>

<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission  != '#url.Mission#' and MissionPrefix = '#Form.MissionPrefix#'
</cfquery>

<cfif Check.Recordcount gte "1">

	<script>
	alert("You must submit a unique entity prefix.")	
	</script>
	<cfabort>

</cfif>

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET    MissionPrefix         = '#Form.MissionPrefix#',
		   DefaultEMailAddress   = '#Form.DefaultEMailAddress#',
		   EnableReview          = '1',
		   OfficerUserId 	 = '#SESSION.ACC#',
		   OfficerLastName  = '#SESSION.LAST#',
		   OfficerFirstName = '#SESSION.FIRST#',
		   Created          =  getdate()		   				
	WHERE  Mission               = '#url.Mission#'
</cfquery>

