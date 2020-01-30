   
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
		     	   						  
		  <tr id="locates" bgcolor="transparent">
		  
		      <td height="30" valign="top" style="padding-left:30px">
			  
				<table border="0" cellspacing="0" cellpadding="0" class="formspacing">
										
						<tr><td height="8"></td></tr> 
						
						<tr>
						
						  <td class="labelmedium" style="font-size:20px;padding-left:10px"><cf_tl id="Find">:</td>
						  
						    <td style="padding-left:4px">
						  
						  <select name="scope" id="scope" style="width:210px;font-size:17px;height:32px" class="regularxl">
						  
							  <option value="employee" selected>Employee / Candidate</option>
							  <option value="orgunit"><cf_tl id="Organization"></option>
							  <option value="location"><cf_tl id="Location"></option>
							  <option value="position"><cf_tl id="Position"> / <cf_tl id="Recruitment Track"></option>
							  <option value="project"><cf_tl id="Program">/<cf_tl id="Project"></option>
						  						  
						  </select>
						  
						 </td> 	
												 						 
						  <td class="cellcontent" style="padding-left:3px">
							  <input type="text" id="fieldsearch" size="15" class="regularxl" maxlength="40" style="padding-top:2px;height:32;font-size:17px" 
							  class="regular" onKeyUp= "quicksearch(event)">
						  </td>
						  				 
						 
							  <td style="padding-left:4px">
							  <input type="checkbox" class="radiol" id="option" value="1" checked>
							  </td>
							  <td style="padding-left:4px" class="labelit"><cf_tl id="Use word variants"></td>						    	
							  					 				  
						  
						 <td class="labelmedium hide" style="padding-left:10px"><cf_tl id="Sort">:
						  <select id="sorting" class="regularxl" style="font:17px;height:37px">
								<option value="Function"><cf_tl id="Function"></option>
								<option value="Grade" selected><cf_tl id="Post grade"></option>
								<option value="Name"><cf_tl id="Name"></option>
								<option value="Nationality"><cf_tl id="Nationality"></option>
						 </select>
						 
						 </td>	
						 
						 <td colspan="4" style="padding-left:10px">
							<cfoutput>
						    <cf_tl id="Search" var="1">
    					    <input type="button" id="gosearch" name="gosearch" value="#lt_text#" class="button10g" style="font-size:12px;height:31;width: 120px;" onClick="search(document.getElementById('scope').value,document.getElementById('snapshot').value)">
						    </cfoutput>
							</td>
						 						  
						</tr>
						
				   
			       </table>		  			  
		  				
			</td>
			
		</tr>
						
		<tr><td height="4"></td></tr> 
						  
		<tr><td height="1" colspan="3" class="line"></td></tr>
															  
		 <tr class="hide" id="dsearch">
			  	<td colspan="3" height="100%" style="padding:20px;" valign="top">							
				   <cf_divscroll id="isearch" style="height:100%;padding-right:7px"/>											  
				</td>
			 </tr>
			
		   		   
  </table>   