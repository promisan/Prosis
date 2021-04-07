
<cfoutput>

<table class="formpadding">

<tr>

<cfif url.action eq "add" or url.action eq "refresh">
	
	<td>
	<button class="button3" 
		style="width:26px;height:25px"
		type="button"
		onclick="savereportfields('0');embedtabdoc('#url.actionid#','#url.docid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#url.no#','delete')">
		<img src="#SESSION.root#/images/delete5.gif" height="20" width="20" alt="Remove" border="0" align="absmiddle">
	</button>
	</td><td>
	
	<button class="button3" 
	    style="width:26px;height:25px"	
		type="button"
		onclick="savereportfields('0');embedtabdoc('#url.actionid#','#url.docid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#url.no#','refresh')">
		<img src="#SESSION.root#/images/refresh3.gif" alt="Refresh" height="20" width="20" align="absmiddle">									
	</button>	
	
	</td>
	
<cfelse>	

	<cf_tl id="Preview" var="1">
	
	<td> 
	
	 <input class="button10g" 
	 	type="button" style="width:200px;border-radius:15px;border:1px solid silver;font-size:15px" value="#lt_text#"
		onclick="savereportfields('0');embedtabdoc('#url.actionid#','#url.docid#',document.getElementById('signatureblock#documentcode#').value,document.getElementById('languagecode#documentcode#').value,document.getElementById('format#documentcode#').value,'#url.no#','add')">	
		
	</td> 

</cfif>

</tr>

</table>

</cfoutput>