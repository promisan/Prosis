<cfif URL.id eq "" OR URL.id2 eq "" OR URL.id3 eq "" OR URL.id4 eq "" OR URL.eff eq "">
	<script>
		alert('Please define all the inputs');
	</script>
	<cfabort>
</cfif>

<cfquery name="qDelete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ItemMasterRipple
	WHERE Code             = '#URL.id#' 
	AND   TopicValueCode   = '#URL.id1#' 
	AND   Mission          = '#URL.id2#'
	AND   RippleItemMaster = '#URL.id3#'
	AND   RippleObjectCode = '#URL.id4#'
	AND   DateEffective    = '#url.eff#' 
</cfquery>

<cfoutput>
<script>
	ptoken.navigate('Budgeting/RecordRipple.cfm?Code=#URL.id#&mode=view','ripple');
</script>
</cfoutput>	