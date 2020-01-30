
<cfsavecontent variable="option">
	
	<cfoutput>
		
		    <cf_tl id="Close" var="1">
					
			<input type="button" 
				onclick="toggle('locatebox')" 
				class="button10s" 
				style="height:23px"
				name="togglebutton" 
				id="togglebutton"
				value="Hide Search Criteria">
			
	</cfoutput>

</cfsavecontent>

<cf_tl id="Record Incoming Invoice" var="1">

<cf_screenTop bannerheight="75" 
	    option="#option#" 
		label="#lt_text#" 
		layout="webapp" 
		jquery="Yes"
		SystemModule="Procurement"
		FunctionClass="Window"
		FunctionName="Invoice entry"	 
		banner="gray" 
		scroll="no" 
		user="Yes">
		
<cfoutput>

<table style="height:100%;width:100%">
	<tr style="height:1px">
		<td id="locatebox" class="regular" valign="top">
		<cfinclude template="LocatePurchase.cfm">		
		</td>
	</tr>
	<tr class="hide"><td height="100" id="processmanual"></td></tr>
	<tr>	
		<td align="center">
		
			<iframe src="" 
			    name="detail"
				id="detail"
		        width="98%"
		        height="99%"
		        align="middle"
		        scrolling="no"
		        frameborder="0"></iframe>
				
		</td>
	</tr>
</table>

</cfoutput>
