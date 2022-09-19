

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM UserNames 
	WHERE Account = '#SESSION.acc#'
</cfquery>

<cf_divscroll>

<cfform onsubmit="return false" method="POST" name="formsetting">

<table width="97%" class="formpadding" align="center">

	<tr><td height="4"></td></tr>
    <tr class="line"><td colspan="2" class="labellarge"><span style="font-size: 24px;margin: 10px 0 6px;display: block;color: #52565B;"><cf_tl id="Signature"></span></td></tr>
			
	<cfoutput>	
	<tr><td colspan="2">
	
	   <iframe src="../Signature/Signature.cfm?account=#SESSION.acc#"
        width="100%"
		style="height:500px"
        frameborder="0">
	   </iframe>
	   
	</td></tr>
		
	</cfoutput>
	
</table>	

</cfform>

</cf_divscroll>

<script>
	Prosis.busy('no');	
</script>