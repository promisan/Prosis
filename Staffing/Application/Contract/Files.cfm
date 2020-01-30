<cfparam name="URL.mode" default="">

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mandate
	WHERE MandateNo = '#URL.ID1#'
	AND   Mission = '#URL.ID#'
</cfquery>

<cfquery name="GetParameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.ID#'
</cfquery>

<cfoutput>

<script>
function PrintCustom(ad) {
	window.open("#SESSION.root#/#GetParameter.PersonActionTemplate#?ID=#URL.ID#&ID1=#URL.ID1#&ID2="+ad)
}
</script>

</cfoutput>


<cf_screentop height="100%" scroll="Yes" html="No" layout="innerbox" title="#URL.ID# Staffing period">		 

<cfset URL.mode="pdf">
<cfinclude template="../Inception/MandateEditLines.cfm">