<cfinclude template="check-auth.cfm">
<cfset request.title = "FuseGuard: Log Detail">
<cfinclude template="views/header.cfm">
<cftry>
	<cfparam name="url.id" type="string">
	<cfimport prefix="vw" taglib="views/">
	<cfoutput><h2><img src="#request.urlBuilder.createStaticURL('views/images/target.png')#" border="0" class="icon"> Log Detail</h2></cfoutput>
	<cfset reader = request.firewall.getLogReader()>
	<cfset log = reader.getLogDetail(url.id)>
	<cfset priors = reader.getCountFor(field="ip_address", ip=log.ip_address)>
	<vw:log-detail log="#log#" priors="#priors.num#">

	<cfcatch type="any">
		<cfmodule template="views/catch.cfm" catch="#cfcatch#" /><cfabort>
	</cfcatch>
</cftry>

<cfinclude template="views/footer.cfm">

