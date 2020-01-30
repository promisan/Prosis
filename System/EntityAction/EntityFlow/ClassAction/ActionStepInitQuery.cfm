<cf_screentop height="100%" title="Question" scroll="yes" html="No">

<cfoutput>

<script language="JavaScript1.1">

function setReturn() {

var collection;
var x
collection = document.all['YesNo'];

for (i=0;i<collection.length;i++) {
   if (collection[i].checked)
   		x = collection[i].value;
	}

window.returnValue = x
window.close()

}


</script>
<table width="80%" height="100%"  border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="808080">

   <tr>
   <td height="3" colspan="2">
   </td></tr>
   
	<tr>
	<td colspan="2" align="center">
	Make action initial step
	</td>
	</tr>
	
	<tr><td height="7"></td></tr>
	
	<tr>
	    <td width="50%" valign="top" align="center">				
							
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				 
				 <!--- background="#SESSION.root#/images/decisiongreen.jpg" --->
				 <tr>
				 <td align="center"  
				 bordercolor="808080" style="background-color:00C600;border: 1px solid;">
				 <b><cf_tl id="Yes"></td></tr>

				 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="green"></td></tr>
			    	</table>
				 </td>
				 </tr>		
				 
				 
			<tr>
			<td height="10" align="center">
		    <input type="radio" name="YesNo" id="YesNo" value="yes" checked>
			</td>
			</tr>
				 

			</table>
  	    </td>
		
		<td valign="top" width="50%" align="center">
		
				 								 				 			 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">

				 <tr>
				 <td align="center" 
				  
				 bordercolor="808080" 
				 style="background-color:ff979f;border: 1px solid;">
				 <b><cf_tl id="No"></td></tr>
				 
				 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="red"></td></tr>
			    	</table>
				 </td>
				 </tr>			 
	 				 					
			<tr>
			<td height="10" align="center">
		    <input type="radio" name="YesNo" id="YesNo" value="no">
			</td>
			</tr>


			</table>
	    </td>
   </tr>
   
   <tr>
   <td height="3">
   </td></tr>
   
   <tr>
   <td colspan="2" align="center">
	   <input type="button" name="Submit" id="Submit" value="Submit" class="button10g" 
	   onClick="setReturn()">
   </td></tr>
   
   				
</table>

</cfoutput>
