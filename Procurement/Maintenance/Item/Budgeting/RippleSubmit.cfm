
<cfif URL.id eq "" OR URL.id2 eq "" OR URL.id3 eq "" OR URL.id4 eq "">
	<script>
		alert('Please define all the inputs');
	</script>
	<cfabort>
</cfif>

	
<cfquery name="qCheck" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM ItemMasterRipple
	WHERE Code = '#URL.id#' AND TopicValueCode = '#URL.id1#' AND Mission = '#URL.id2#'
	AND RippleItemMaster = '#URL.id3#'
	AND RippleObjectCode = '#URL.id4#'
</cfquery>


<cfif qCheck.recordcount eq "0">
	<cfquery name="qInsert" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ItemMasterRipple
           (Code
           ,TopicValueCode
           ,Mission
           ,RippleItemMaster
           ,RippleObjectCode
           ,BudgetMode
           ,BudgetAmount
           ,Operational
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName)
     VALUES
           ('#url.id#',
		    '#url.id1#',
		    '#url.id2#',
		    '#url.id3#',
			'#url.id4#',
			'#url.id5#',
			'#url.id6#',
			1,
			'#Session.acc#',
			'#Session.first#',
			'#Session.last#'
		   ) 
	</cfquery>
	<cfoutput>
	<script>
		ColdFusion.navigate('Budgeting/RecordRipple.cfm?Code=#URL.id#&mode=view','ripple');
	</script>
	</cfoutput>	
<cfelse>
	<script>
		alert('An existing entry has been defined');	
	</script>
</cfif>	

