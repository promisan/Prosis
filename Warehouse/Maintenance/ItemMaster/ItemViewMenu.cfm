
<cf_submenuleftscript>

<cfset fcolor = "002350">
	 
<input type="hidden" name="optionselect" id="optionselect">	 
	 	 
<table width="210" border="0" cellspacing="0" cellpadding="0">

<tr><td height="8"></td></tr>
<tr><td style="padding-left:7px">
	<cfset heading = "Specifications">
	<cfset module = "'Warehouse'">
	<cfset img          = "condition.gif">	
	<cfset selection = "'Item'">
	<cfset menuclass = "'Maintain'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>
<tr><td style="padding-left:7px">
	<cfset heading = "Inquiry">
	<cfset module = "'Warehouse'">
	<cfset img          = "locate3.gif">	
	<cfset selection = "'Item'">
	<cfset menuclass = "'Inquiry'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>

</table>
