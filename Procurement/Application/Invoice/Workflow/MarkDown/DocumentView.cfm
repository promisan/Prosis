
<cfif NOT isDefined("Object.ObjectKeyValue4")>
	<cf_screentop height="100%" band="No" html="No" scroll="No" banner="gray" user="No" jquery="Yes" label="Amount Payable" layout="webapp">		  
</cfif>

<cfform style="height:100%" action="DocumentSubmit.cfm?mode=onhold&dialog=1" method="POST" name="forminvoice" target="result">

<input type="hidden" id="_requests" name="_requests" value="">

<table width="100%" style="height:99%">
    
	<tr class="hide"><td height="100" width="100%">
	  <iframe name="result" id="result" height="100" width="100%" frameborder="0"></iframe></td>
	</tr>
		
    <tr><td style="height:94%">
		
		<cf_divscroll style="height:94%">

			<cfset url.dialog = 1>	
			<cfinclude template="Document.cfm">
		
		</cf_divscroll>
		
	</td></tr>

	<tr><td class="line"></td></tr> 
	<tr>
		<td align="center" height="30" style="padding-bottom:10px">		
		  <input type="submit" class="button10g" style="width:150px;height:27" align="center" value="Save"  name="Save" id="Save">
		</td>
    </tr>
	
</table>

</cfform>


	