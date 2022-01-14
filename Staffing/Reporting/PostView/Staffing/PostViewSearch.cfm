   
	<table width="100%" height="100%">
		     	   						  
		  <tr id="locates" bgcolor="transparent" >
		  
		      <td height="30" valign="top" style="padding-left:30px;border-bottom:1px solid silver">
			  
				<table class="formspacing">
										
						<tr><td height="8"></td></tr> 
						
						<tr >
						
						  <td class="labelmedium" style="font-size:15px;padding-left:10px"><cf_tl id="Find">:</td>
						  
						    <td style="padding-left:4px">
						  
						  <select name="scope" id="scope" style="border:0px;background-color:f1f1f1;width:350px;font-size:16px;height:32px" class="regularxxl">
						  
							  <option value="employee" selected><cf_tl id="Employee"> / <cf_tl id="Recruitment Candidate"></option>
							  <option value="orgunit"><cf_tl id="Organization"></option>
							  <option value="location"><cf_tl id="Location"></option>
							  <option value="position"><cf_tl id="Position"> / <cf_tl id="Recruitment Track"></option>
							  <option value="project"><cf_tl id="Program">/<cf_tl id="Project"></option>
						  						  
						  </select>
						  
						 </td> 	
												 						 
						 <td class="cellcontent" style="padding-left:3px">
							<input type="text" id="fieldsearch" size="15" class="regularxxl" maxlength="40" style="padding-left:4px;border:0px;background-color:f1f1f1;padding-top:2px;height:32px;font-size:19px" 
							  onKeyUp= "quicksearch(event)">
						 </td>
						  				 
						 
						 <td style="padding-left:4px">
							<input type="checkbox" class="radiol" id="option" value="1" checked>
						 </td>
						 <td style="padding-left:4px" class="labelit"><cf_tl id="Use word variants"></td>						    	
							  					 				  
						  
						 <td class="labelmedium hide" style="padding-left:10px"><cf_tl id="Sort">:
						    <select id="sorting" class="regularxl" style="border:0px;background-color:f1f1f1;font-size:18px;height:37px">
								<option value="Function"><cf_tl id="Function"></option>
								<option value="Grade" selected><cf_tl id="Post grade"></option>
								<option value="Name"><cf_tl id="Name"></option>
								<option value="Nationality"><cf_tl id="Nationality"></option>
						    </select>						 
						 </td>	
						 
						 <td colspan="4" style="padding-left:10px">
							<cfoutput>
						    <cf_tl id="Search" var="1">
    					    <input type="button" id="gosearch" name="gosearch" value="#lt_text#" class="button10g" style="font-size:17px;height:32px;width:190px;" onClick="search(document.getElementById('scope').value,document.getElementById('snapshot').value)">
						    </cfoutput>
							</td>
						 						  
						</tr>
						
				   
			       </table>		  			  
		  				
			</td>
			
		</tr>
						
		<tr><td height="4"></td></tr> 
																	  
		<tr class="xhide" id="dsearch">
		  	<td colspan="3" height="100%" style="padding-left:10px;padding-right:10px" valign="top">							
			   <cf_divscroll id="isearch" style="height:100%;padding-right:7px"/>											  
			</td>
		</tr>			
		   		   
  </table>   