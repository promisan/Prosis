
<!--- A. do not change --->

<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">

<!--- B. customise below --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" border="0">

<tr>

	<td align="left" height="25">
	
		<td>
		
		<table>
		<tr>
			<td><input style="height:18px;width:18px" type="radio" id="itemscope" name="itemscope" value="PostGradeBudget" <cfif url.item eq "PostGradeBudget">checked</cfif>  onclick="reload('PostGradeBudget','yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Grade</td>
			<td><input style="height:18px;width:18px" type="radio" id="itemscope" name="itemscope" value="ParentNameShort" <cfif url.item eq "ParentNameShort">checked</cfif>  onclick="reload('ParentNameShort','yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Unit</td>
			<td><input style="height:18px;width:18px" type="radio" id="itemscope" name="itemscope" value="PostClass" <cfif url.item eq "PostClass">checked</cfif>  onclick="reload('PostClass','yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Class</td>
			<td><input style="height:18px;width:18px" type="radio" id="itemscope" name="itemscope" value="OccGroupAcronym" <cfif url.item eq "OccGroupAcronym">checked</cfif>  onclick="reload('OccGroupAcronym','yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Occupational group</td>
		
		</tr>
		</table>
	
	</td>
	
	<td style="padding-bottom:3px;">

		<cf_tl id="Summary" var="1">
		<cf_button2 
			mode="icon" 
			image="Summary.png" 
			onclick="inspect('all')" 
			text="#lt_text#" 
			title="#lt_text#" 
			onmouseover="this.style.backgroundColor='E0E0E0';"
			onmouseout="this.style.backgroundColor='';">
			
	</td>
	
	<cfoutput>
	
	<td>
		
		<table>
		<tr>
			<td><input style="height:18px;width:18px" type="radio" id="scope" name="scope" value="all" <cfif url.scope eq "all">checked</cfif>  onclick="reload(document.getElementById('itemselected').value,'yes','all')"></td><td style="padding-left:4px;padding-right:8px" class="labelit">All Posts</td>
			<td><input style="height:18px;width:18px" type="radio" id="scope" name="scope" value="vac" <cfif url.scope eq "vac">checked</cfif>  onclick="reload(document.getElementById('itemselected').value,'yes','vac')"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Vacant</td>
			<td><input style="height:18px;width:18px" type="radio" id="scope" name="scope" value="inc" <cfif url.scope eq "inc">checked</cfif>  onclick="reload(document.getElementById('itemselected').value,'yes','inc')"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Incumbent</td>
		</tr>
		</table>
	
	</td>
	
	<input type="hidden" id="itemselected"    name="itemselected"    value="#client.graph#">
	<input type="hidden" id="scopeselected"   name="scopeselected"   value="all">
	<input type="hidden" id="formatselected"  name="formatselected"  value="bar">
	
	<td><input style="height:18px;width:18px" type="radio" id="format" name="format" value="Bar" checked onclick="document.getElementById('formatselected').value='bar';reload(document.getElementById('itemselected').value,'yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Bar</td>
	<td><input style="height:18px;width:18px" type="radio" id="format" name="format" value="Line"        onclick="document.getElementById('formatselected').value='line';reload(document.getElementById('itemselected').value,'yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Line</td>
	<td><input style="height:18px;width:18px" type="radio" id="format" name="format" value="Pie"         onclick="document.getElementById('formatselected').value='pie';reload(document.getElementById('itemselected').value,'yes',document.getElementById('scopeselected').value)"></td><td style="padding-left:4px;padding-right:8px" class="labelit">Pie</td>
	
	</cfoutput>

</tr>

<tr><td colspan="10" class="line"></td></tr>

<tr><td align="center" colspan="8" id="graphdata">	
		<cfset url.format = "bar">	
		<cfinclude template="../#path#/GraphData.cfm">	
	</td>
</tr>

</table>
