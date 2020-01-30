<cfparam name="url.showLocation" default="yes">

<cfoutput>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
</cfquery>

<cfif url.mode eq "standard">
	
	<select name="uom" id="uom" class="enterastab regularxl">
	<cfloop query="get">
		<option value="#UoM#">#UoMDescription#</option>
	</cfloop>
	</select>

	<cfif url.showLocation eq "yes">
		<script language="JavaScript">
			document.getElementById('submitbox0').className = "regular"		
			document.getElementById('submitbox1').className = "regular"
		</script>
	</cfif>

<cfelse>
		
	<select name="uom" id="uom" class="enterastab regularxl"
	  	<cfif url.showLocation eq 'yes'>
		  onchange="ptoken.navigate('../Transaction/getLocation.cfm?mode=#url.mode#&warehouse='+document.getElementById('warehouse').value+'&itemno=#url.ItemNo#&uom='+this.value+'&workorderid='+document.getElementById('workorderid').value,'locbox')"
	  	</cfif>>
	<cfloop query="get">
		<option value="#UoM#">#UoMDescription#</option>
	</cfloop>
	</select>
	
	<cfif url.showLocation eq "yes">
		<script language="JavaScript">
			ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getLocation.cfm?mode=#url.mode#&warehouse='+document.getElementById('warehouse').value+'&itemno=#url.ItemNo#&uom=#get.uom#&workorderid='+document.getElementById('workorderid').value,'locbox')				
			document.getElementById('submitbox0').className = "regular"
			document.getElementById('submitbox1').className = "regular"
			document.getElementById('loclabel').className   = "regular"
			document.getElementById('uomlabel').className   = "regular"
		</script>
	</cfif>
	
</cfif>

</cfoutput>		

