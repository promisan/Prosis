
<table width="97%" cellspacing="0" cellpadding="0" class="formpadding" align="center">

	<tr><td height="4"></td></tr>
    <tr><td colspan="2" class="labellarge"><span style="font-weight: 200;font-size: 24px;margin: 20px 0 20px;display: block;color: #52565B;"><cf_tl id="Signature"></span></td></tr>
			
	<cfoutput>	
	<tr><td colspan="2">
	
	   <iframe src="../Signature/Signature.cfm?account=#SESSION.acc#"
        width="100%"
        height="300"
        frameborder="0">
	   </iframe>
	   
	</td></tr>
	</cfoutput>
	
</table>	

<script>
	Prosis.busy('no');	
</script>