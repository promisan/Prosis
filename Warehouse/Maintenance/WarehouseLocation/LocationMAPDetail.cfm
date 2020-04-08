
<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseLocation AS WL INNER JOIN
	         Location AS L ON WL.LocationId = L.Location
	WHERE    WL.Warehouse = '#url.warehouse#' 
	AND      WL.Location= '#url.location#'
</cfquery>

<cfoutput>

	<table width="350" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td><font face="Verdana" size="1"><cf_tl id="Code">:</td><td><font face="Verdana" size="2">#get.Location#</td></tr>
	<tr><td><font face="Verdana" size="1"><cf_tl id="Name">:</td><td><font face="Verdana" size="2">#get.Description#</td></tr>
	<tr><td><font face="Verdana" size="1"><cf_tl id="Address">:</td><td><font face="Verdana" size="2">#get.Address#</td></tr>
	<tr><td><font face="Verdana" size="1"><cf_tl id="City">:</td><td><font face="Verdana" size="2">#get.AddressCity#</td></tr>
	<tr><td colspan="2"><font face="Verdana" size="1"><cf_tl id="Fuel Levels">:</td></tr>
	<tr><td height="40" colspan="2" style="border:1px solid gray">
	<table width="90%" align="center"><tr><td></td></tr></table>
	</td></tr>
	<tr><td height="4"></td></tr>
	<tr><td align="center"><a href="javascript:editwarehouselocation('#URL.Warehouse#','#url.location#')">[<cf_tl id="Click here to Maintain">]</font></a></td></tr>
	</table>
	
</cfoutput>
