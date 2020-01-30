<cfoutput>
<table bgcolor="EaEaEa">
	<tr><td style="border:1px solid silver">					
	<img src="#SESSION.root#/images/up6.png" 
			 id="#attributes.id#_up" 
			 width="#attributes.width#" 
			 height="#attributes.height#" 
			 style="cursor:pointer" 
			 onclick="var num= $('###attributes.id#').val() - 1 + 2; $('###attributes.id#').val(num);;$('###attributes.id#').change();"
			 border="0"></td></tr>	
	<tr><td style="border:1px solid silver">
	<img src="#SESSION.root#/images/down6.png" 
			id="#attributes.id#_down" 
			width="#attributes.width#" 
			onclick="var num= $('###attributes.id#').val() - 1; $('###attributes.id#').val(num);$('###attributes.id#').change()"
			height="#attributes.height#" 	
			style="cursor:pointer" 		
			border="0">						
	</td></tr>	
</table>	
</cfoutput>	