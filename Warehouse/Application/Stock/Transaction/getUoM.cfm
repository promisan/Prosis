<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

