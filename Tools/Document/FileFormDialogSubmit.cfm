
<cfoutput>

<cfif url.accept eq "1">

    <cf_tl id="Cancel" var="1">
	
	<input type="button"  value="#lt_text#" class="button10g" onclick="parent.ProsisUI.closeWindow('attachdialog')">
		
		<input type="submit" 
		    name="save" 
			id="save"  
			value="Attach File" 
			class="button10g" 
			onclick="document.getElementById('save').className='hide';document.getElementById('busy').className='regular'">			
		
<cfelse>

   <table align="center"><tr><td align="center" class="labelmedium">
	 <font color="FF0000"><cf_tl id="Stop">:<b><cf_tl id="This file extension not supported"></font>
	</td></tr></table>
		
</cfif>		
</cfoutput>
