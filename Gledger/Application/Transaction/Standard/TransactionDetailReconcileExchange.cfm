
<cfoutput>

 <script>
			 document.getElementById('exc_#url.field#').value = "#NumberFormat(url.exchange,'_,____._____')#"
		</script>

<!---		
<input type="text" 
 name="exc_#url.field#" 
 id="exc_#url.field#" 
 value="#NumberFormat(url.exchange,'_,____._____')#" 
 size="10" 
 maxlength="12" 
 onchange="recalcline('#url.line#','#url.field#')"				 							
 class="regular3" 
 style="background-color:ffffaf;text-align: right;padding-top:0px;width:100%;height:18px;">
 --->
 </cfoutput>