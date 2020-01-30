

<cfif url.inputmode eq "YesNo">

<select name="InputValuePass" class="regularxl">
	<option value="0" <cfif url.selected eq "0">selected</cfif>>No</option>
	<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>
</select>

<cfelseif url.inputmode eq "YesNoNA">

<select name="InputValuePass" class="regularxl">
	<option value="0" <cfif url.selected eq "0">selected</cfif>>No</option>
	<option value="1" <cfif url.selected eq "1">selected</cfif>>Yes</option>	
</select>

<cfelse>
	
	<cfoutput>
	<select name="InputValuePass" class="regularxl">
	   <cfloop index="itm" from="1" to="#url.inputmode#">
		<option value="#itm#" <cfif url.selected eq itm>selected</cfif>>#itm#</option>
	   </cfloop>			
	</select>
	</cfoutput>

</cfif>
<!--- get questionaire target --->