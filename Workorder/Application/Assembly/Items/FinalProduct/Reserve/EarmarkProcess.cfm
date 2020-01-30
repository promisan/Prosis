
<table width="100%" class="formpadding">

	<tr><td colspan="8" class="line"></td></tr>
	
	<tr>
	
		<td class="labelit"><cf_tl id="Quantity">:</td>		
		<td id="totals" class="labellarge" style="width:70px;padding-left:6px"></td>										
		<td style="padding-left:3px;padding-right:10px" class="labelit"><cf_tl id="BatchReference">:</td>		
		<td><input type="text" name="BatchReference" class="regularxl" style="width:290px" maxsize="40"></td>		
		<td style="padding-left:3px" align="right">
		
		<cf_tl id="Transfer and Earmark" var="transfer">
		
		<cfoutput>
			<input type="button" 
			  class="button10g" 
			  onclick="Prosis.busy('yes');ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/EarmarkSubmit.cfm','totals','','','POST','stockform')"
			  style="font-size:12px;width:190;height:25px" 
			  name="Submit" 
			  value="#Transfer#">
		 </cfoutput> 
		
		</td>
	  
	  </tr>
  
  </table>