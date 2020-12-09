
<cfoutput>

<cfquery name="Amount" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   FinancialObject O, 
	        FinancialObjectAmount OA
	 WHERE  O.ObjectId = OA.Objectid
	        #preserveSingleQuotes(condition)# 
</cfquery>
						
<script>
	
	function setclassification(id,ser,code,act,row,cls,scope) {
					
		var se = document.getElementById(row+"_"+cls)
		var cells = se.getElementsByTagName("td")	
				
		
		for (var i = 0; i < cells.length; i++) {
		 cells[i].className = "regular"; 
    	}
				
		var inp = se.getElementsByTagName("input")	
		
		for (var i = 0; i < inp.length; i++) {
		 if (inp[i].name != row+"_"+cls+"_"+code) {
		 inp[i].checked = false; 
		 }
    	}
					
		se1 = document.getElementById(row+"_"+code+"_1")
		se2 = document.getElementById(row+"_"+code+"_2")
		if (act == true) {
			se1.className = "highlightc4"
			se2.className = "highlightc4"
		} else {
			se1.className = "regular"
			se2.className = "regular"
		}
		_cf_loadingtexthtml='';					
		url = "#SESSION.root#/tools/financeObject/Tagging/ObjectClassificationUpdate.cfm?scope="+scope+"&mode=#attributes.entry#&id="+id+"&ser="+ser+"&code="+code+"&act="+act
		ptoken.navigate(url,'tagsave')		 
	}
	
		
	function setprogram(id,ser,code,act,row,cls,scope) {
		_cf_loadingtexthtml='';									
		url = "#SESSION.root#/tools/financeObject/Tagging/ObjectClassificationUpdate.cfm?scope="+scope+"&mode=#attributes.entry#&id="+id+"&ser="+ser+"&code="+code+"&act="+act		
		ptoken.navigate(url,'tagsave')		
		 
	}
	
	function selectprogram(mis,per,des1,fld1,id,ser,row)	{
							
		ret = window.showModalDialog(root + "/Gledger/Application/Lookup/ProgramSelect.cfm?period="+per+"&mission="+mis+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:750px; dialogWidth:700px; help:no; scroll:no; center:yes; resizable:yes");		
		if (ret) {
			val = ret.split(";");
			document.getElementById(des1).value = val[0];
			document.getElementById(fld1).value = val[2];			
			setprogram(id,ser,val[2],true,row,'program','program')																	
			}						
	}
		
	function editamount(id,ser) {				
		url = "#SESSION.root#/tools/financeObject/Tagging/ObjectAmountEdit.cfm?mode=#attributes.entry#&objectid="+id+"&serialno="+ser
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'amt'+ser)			
	}
	
	function saveamount(id,ser,amt)	{	
		valt = document.getElementById("tagamount"+ser).value			
		url = "#SESSION.root#/tools/financeObject/Tagging/ObjectAmountEditSubmit.cfm?mode=#attributes.entry#&objectid="+id+"&serialno="+ser+"&amount="+valt+"&lbl=#attributes.label#&obj=#Attributes.Object#&key=#Attributes.ObjectKey#"
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'label')			
	}
	
	function delamount(id,ser) {	
		url = "#SESSION.root#/tools/financeObject/Tagging/ObjectAmountDelete.cfm?mode=#attributes.entry#&objectid="+id+"&serialno="+ser+"&lbl=#attributes.label#&key=#Attributes.ObjectKey#"
		_cf_loadingtexthtml='';	
		ptoken.navigate(url,'label')			
	}	
	
</script>
	
</cfoutput>	
	
<cfif amount.recordcount eq "1" and amount.amount eq "0">

	<!--- hide --->
 
<cfelse>	

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr class="hide"><td id="tagsave"></td></tr>	
	
	<tr>
	
	<td colspan="1" style="padding-left:10px">		
				
	    <cfset col = "5">					
		
		<table width="<cfoutput>#Attributes.TableWidth#</cfoutput>"
		       border="0" class="formpadding" align="center">
		
			   <cfif attributes.label eq "Yes">
				<tr><td colspan="5" height="25" class="labelmedium linedotted">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/tag.gif" align="absmiddle" alt="" border="0">
				<cf_tl id="Label the amount">:</td>
				</tr>
			   </cfif>
	    	   
			 
		<cfif attributes.entry eq "Single">	   
				
			<tr>
			   <cfif amount.recordcount gte "2">
				   <td width="30" class="labelmedium" align="center"><cf_tl id="No"></td>
			    </cfif>
			    <td style="padding-left:10px" class="labelmedium" align="left"><cf_tl id="Classification"></td>				 
			</tr>
							
		</cfif>		
							
		<cfset row = 0>
										 
		<cfloop query="Amount">
		
		  <cfset row = row + 1>
		  <tr>				  		 
		   
		  <cfif amount.recordcount gte "2">
		   <td width="20" align="center">		   
		      <cfoutput>#CurrentRow#.</cfoutput>
		   </td>		   
		  </cfif>
		  		  		   	     
		  <td width="98%" style="padding-right:20px" id="<cfoutput>#serialNo#</cfoutput>">
		  		  		   
		   <cfset id  = ObjectId>
		   <cfset ser = SerialNo>
		   <cfset list = "">
		   
		  		   
		   <cfif EntityCode eq "INV">
		   
		       <cfquery name="Param" 
				 datasource="AppsPurchase"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   Ref_ParameterMission
					 WHERE  Mission = '#Attributes.Mission#'			 
			   </cfquery>
			   
			   <cfif Param.InvTagProgram eq "1">			   
			     <cfset list = "program">				 
			   </cfif>
					
			<cfelseif EntityCode eq "REQ">
			
			<cfquery name="Param" 
				 datasource="AppsPurchase"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT * 
					 FROM   Ref_ParameterMission
					 WHERE  Mission = '#Attributes.Mission#'			 
			   </cfquery>
			   
			   <cfif Param.ReqTagActivity eq "1">			   
			     <cfset list = "activity">				 
			   </cfif>
			   
			</cfif>   
						
		   <!--- tagging invoices based on program/project --->	   	   
		   
		   <cfif list eq "activity">
		   
		   <table style="width:100%"><tr><td style="width:100%">
		   
			    <cfquery name="Class" 
						 datasource="AppsPurchase"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 
				   SELECT   ActivityDescription, ActivityDescriptionShort, ActivityId, ActivityDateStart, ActivityDateEnd
				   FROM     Program.dbo.ProgramActivity
				   WHERE    (
				             ProgramCode IN (SELECT     ProgramCode
				                             FROM       RequisitionLineFunding
				                             WHERE      RequisitionNo = '#attributes.ObjectKey#') 
							 OR ProgramCode = 'PC6055'
							) 
				   AND      RecordStatus = '1'
				</cfquery>	
			
				<cfoutput>	
			
				<table cellspacing="0" cellpadding="0" border="0">
				       <tr>
					   <td>		
					   
					    <cfquery name="Selected" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
				        	SELECT Category
						    FROM   FinancialObjectAmountCategory 
							WHERE  ObjectId   = '#Objectid#'
							AND    SerialNo   = '#SerialNo#'
					    </cfquery>					   
					  					  										  				   		   
				       <select name="1selected" id="1selected" 
					       class="regularxl"  						 		  
					       onChange="setprogram('#id#','#ser#',this.value,true,'#row#','custom','custom')">
						   <option value="">N/A</option>						  						   
						   <cfloop query="class">
						   <option value="#ActivityId#" <cfif ActivityId eq selected.Category>selected</cfif>>#ActivityDescriptionShort#</option>						   
						   </cfloop>						   
					   </select>						     
					   
					   </td>
					   
					   <td width="50" align="center" class="labelmedium">#Currency#</td>
					   
					   <td width="120" align="right" id="amt#serialno#" class="labelmedium">#numberFormat(Amount,"__,__.__")# </td>
					   <td width="30%" height="21">	
					 		 <table cellspacing="0" cellpadding="0" class="formpadding">
								 <tr>
									 <td style="padding-left:4px;padding-top:1px">
										<cf_img icon="edit" onclick="editamount('#Objectid#','#SerialNo#')">
									 </td>
									 <td style="padding-left:3px;padding-top:1px">
									    <cf_img icon="delete" onclick="delamount('#Objectid#','#SerialNo#')"> 		
									 </td>
								 </tr>
							</table> 			
					     </td>							   
					   </tr>
				</table>	
				
				</cfoutput>				   
		   
		   </td></tr></table>
		   		 
		   <cfelseif list eq "program">		   
		   		   		   	   		
				   <cfquery name="Class" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT C.*, 
						        R.ProgramName, 
								R.ProgramCode 
						 FROM   Program.dbo.Program R INNER JOIN
			                    FinancialObjectAmountProgram C ON R.ProgramCode = C.ProgramCode		
						   AND  C.ObjectId = '#Objectid#'
						   AND  C.SerialNo = '#SerialNo#'
						 WHERE  R.Mission = '#Attributes.Mission#'							 			 
				   </cfquery>		      
				 		  
			       <cfoutput>	
				   
				   <table width="100%" cellspacing="0" cellpadding="0">
				   
				       <tr>					   
					   <td width="40"></td>					   
					   <td>	
					   			
						<table cellspacing="0" cellpadding="0">
						<tr><td>			
						   <cf_img icon="open" onClick="selectprogram('#Attributes.mission#','','programname#ser#','programcode#ser#','#Id#','#Ser#','#row#')">						  
							</td>
							<td style="padding-left:2px">		  
						  		<input type="text"   name="programname#ser#" id="programname#ser#" value="#Class.ProgramName#" class="regularxl" size="60" maxlength="80" readonly>
								<input type="hidden" name="programcode#ser#" id="programcode#ser#" value="#Class.ProgramCode#" size="20" maxlength="20" readonly>
						  </td>
						 </tr>
						 </table>
								   
					   </td>
					   
					    <td width="50" class="labelmedium" align="center">#Currency#</td>
					    <td width="120" class="labelmedium" align="right" id="amt#serialno#">#numberFormat(Amount,"__,__.__")#</td>
					    <td width="20%" height="21" align="right" style="padding-right:15px">
						    <table cellspacing="0" cellpadding="0" class="formpadding">
							<tr><td style="padding-top:1px">							    
						    	<cf_img icon="edit" onclick="editamount('#Objectid#','#SerialNo#')"> 								
							</td>
							<td style="padding-left:4px;padding-top:1px">							    
					 		    <cf_img icon="delete" onclick="delamount('#Objectid#','#SerialNo#')">		 								
							</td>
							</tr>	
							</table>		
					   </td>							   
					   </tr>
					   
				   </table>
				   
				   </cfoutput>		 
				   			   
		   <cfelseif attributes.entry eq "Single">
		   	   			
				   <cfquery name="Class" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT   R.Description, 
								  R.Code, 
								  CL.Code as Class, 
								  CL.Description as ClassDescription,
								  R.Operational								 
						 FROM     Ref_CategoryClass CL INNER JOIN
			                      Ref_Category R ON CL.Code = R.CategoryClass
						
						 ORDER BY CL.Code, R.Description 			 
				   </cfquery>
				   
				   <cfquery name="Selected" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
				        SELECT Category
					    FROM   FinancialObjectAmountCategory 
						WHERE  ObjectId   = '#Objectid#'
						AND    SerialNo   = '#SerialNo#'
					</cfquery>											
					 
				   <cfoutput>
			   	   				 				   
				   <table style="width:700" cellspacing="0" cellpadding="0" border="0">
				       <tr>
					   <td>				   
					  					  										  				   		   
				       <select name="1selected" id="1selected" 
					       class="regularxl" 
						   selected="#Selected.Category#" 
						   query="Class" 
						   value="Code" 
						   Display="Description"
						   queryposition="below"
						   Group="ClassDescription"
					       onChange="setprogram('#id#','#ser#',this.value,true,'#row#','custom','custom')">
						   <option value=""></option>						  						   
						   <cfloop query="class">
						   <option value="#Code#" <cfif code eq selected.Category>selected</cfif>>#Description#</option>						   
						   </cfloop>
						   
					   </select>						     
					   
					   </td>
					   <td width="50" align="center" class="labelmedium">#Currency#</td>
					   <td width="120" align="right" id="amt#serialno#" class="labelmedium">#numberFormat(Amount,",.__")# </td>
					   <td width="30%" height="21">	
					 		 <table cellspacing="0" cellpadding="0" class="formpadding">
								 <tr>
									 <td style="padding-left:4px;padding-top:1px">
										<cf_img icon="edit" onclick="editamount('#Objectid#','#SerialNo#')">
									 </td>
									 <td style="padding-left:3px;padding-top:1px">
									    <cf_img icon="delete" onclick="delamount('#Objectid#','#SerialNo#')"> 		
									 </td>
								 </tr>
							</table> 			
					     </td>							   
					   </tr>
				   </table>
				   </cfoutput>				    
			   
			   <cfelse>		   
			   		
				   <cfquery name="Class" 
						 datasource="AppsLedger"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT C.*, 
						        R.Description, 
								R.Code, 
								CL.Code as Class, 
								CL.Description as ClassDescription,
								R.Operational
						 FROM   Ref_CategoryClass CL INNER JOIN
			                    Ref_Category R ON CL.Code = R.CategoryClass LEFT OUTER JOIN
			                    FinancialObjectAmountCategory C ON R.Code = C.Category		
						   AND  C.ObjectId = '#Objectid#'
						   AND  C.SerialNo = '#SerialNo#'
						 WHERE  R.EntityCode = '#Attributes.EntityCode#'			
						 AND    (R.Mission is NULL or R.Mission = '#Attributes.Mission#')			
						 ORDER BY CL.Code, R.Description 			 
				   </cfquery>
			   
				   <table width="100%" cellspacing="0" cellpadding="0">
				   
				   <cfoutput>
				   
				   <tr>
				   
				      <td>
					      <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
							  <tr> 
							      <td width="40" class="labelmedium">#Currency#</td>
								  <td width="90" align="left" style="padding-left:4px" class="labelmedium" id="amt#serialno#">
								    #numberFormat(Amount,"__,__.__")#
								  </td>
								  <td width="80%" align="right" height="20">
								    <table cellspacing="0" cellpadding="0" class="formpadding">
									 <tr><td style="padding-top:1px">
									 <cf_img icon="edit" onclick="editamount('#Objectid#','#SerialNo#')">
									 </td>
									 <td style="padding-left:3px;padding-top:1px">
									  <cf_img icon="delete" onclick="delamount('#Objectid#','#SerialNo#')"> 		
									 </td>
									 </tr>
									</table>
								  </td>
							  </tr>
						  </table>
					  </td>		
					  		  
					</tr>
					
					</cfoutput>
					
					<tr><td class="line"></td></tr>
					  			   
					<cfset cl = "">		
												   				   
					<cfoutput query="Class" group="Class">
					
						   <cfif cl neq class> 
						   
							   <cfset cl = class>
							   <cfset cnt = "0">							   
							  
							   <tr class="line">
							      <td style="padding-left:1px"class="labelmedium">#ClassDescription#</td>
							   </tr>							   
							   <tr><td id="#row#_#class#">
							   
							   <table width="100%" cellspacing="0" cellpadding="0">
							   						   
						   </cfif>	  
						   
						   <cfset cnt = 0> 
											
						   <cfoutput>			   	   
					   
							   <cfset cnt = cnt+1>
							   
							   <cfif cnt eq "1">
							   	
								<tr>
								
							   </cfif>
							   
								   <td id="#row#_#Code#_2" width="3%" style="padding-left:10px;height:20;padding-right:5px"
									   class="<cfif Objectid neq "">highlightc4</cfif>">
									   
									  	<input type = "checkbox" 
								           name     = "#row#_#class#_#code#" 
										   id       = "#row#_#class#_#code#"
									       value    = "#Code#" 
										   class    = "radiol"
										   <cfif operational eq "0">disabled</cfif>
										   onClick  = "setclassification('#Id#','#Ser#','#Code#',this.checked,'#row#','#class#','custom')" <cfif Objectid neq "">checked</cfif>>
											   
								   </td>
								   
								   <td id="#row#_#Code#_1" style="padding-left:4px" width="22%" class="labelmedium <cfif Objectid neq "">highlightc4</cfif>">#Description#
								   </td>		
								
							   <cfif cnt eq "4">	
							   			
								   </tr>
								   <cfset cnt = 0>
								   
							   </cfif>	
						   
						   </cfoutput>
						   
						   </table>
						   </td>
						   </tr>
						   
					</cfoutput>	   
										   
				   </table>
			   
			   </cfif>
			   
		   </td>
		</tr>	
					   		
		</cfloop>
		
		<tr><td height="4"></td></tr>		
				
		</table>
		
		
	
	</td>	
	</tr>
		   
	</table>	
		
</cfif>		
