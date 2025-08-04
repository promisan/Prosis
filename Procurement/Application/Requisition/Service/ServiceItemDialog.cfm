<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- dialog screen for editing or adding --->

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine 
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Period" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_MissionPeriod
	WHERE  Mission = '#Line.Mission#'
	AND    Period  = '#Line.Period#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission  = '#Line.Mission#'	
</cfquery>
  
<cfquery name="UoMList" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_UoM
</cfquery>
 
<cfif url.mode eq "default">

   <!--- if default determine if to be shown ---> 
       
   <cfif Parameter.RequestDescriptionMode eq "1">
      
   		<cfset url.mode = "extended">
   		
   </cfif>
  
</cfif>

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineService 
	WHERE  RequisitionNo = '#URL.ID#'
	<cfif url.id2 neq "new">
	AND    ServiceId = '#url.id2#'
	<cfelse>
	AND 1=0
	</cfif>
</cfquery>

<!---

<cf_screentop 
    label   = "Service detail" 
    height  = "100%" 
	scroll  = "No" 
	layout  ="webapp" 
	bannerheight="50"
	line    = "no"
	user    = "no"
	banner  = "gray" 
	close   = "ColdFusion.Window.hide('dialogservice')">
	
	--->

<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="white">

<tr><td valign="top" style="padding-top:5px">

<cfoutput>

	<cfform method="POST" name="serviceform">
			
			<table width="90%" cellspacing="0" align="center" class="formpadding">			
			   				
			    <input type="hidden" name="id" id="id" value="<cfoutput>#URL.ID#</cfoutput>">
				 
				 <tr>
				    <td class="labelmedium"><cf_tl id="Reference">:</td>  
				    <td>
				   	   <input type="Text" 
					     value="#detail.PersonnelActionNo#" 
						 name="svcref" 
	                     id="svcref"
						 style="width:100"
						 maxlength="20" 
						 class="regularxl enterastab">
		           </td>	
				  </tr>
				 		   	
				  <cfif url.mode eq "extended">
				  			  
				   <TR>
					    <td class="labelmedium"><cf_tl id="Quantity">: <font color="FF0000">*</font></td> 
					    <td height="20">
						 
					   	   <input type="Text"
					       name="svcservicequantity"
	                       id="svcservicequantity"
					       value="<cfif detail.servicequantity eq "">1<cfelse>#detail.servicequantity#</cfif>"
					       validate="float"		
						   style="text-align: right;width:30;padding-right:2px;" 		   
					       required="Yes"
						   onchange="ColdFusion.navigate('../Service/ServiceItemDialogTotal.cfm?sqty='+this.value+'&qty='+document.getElementById('svcquantity').value+'&rate='+document.getElementById('svcrate').value,'svctotal')"
					       size="4"
					       maxlength="6"					   
					       class="regularxl enterastab">
						  
			           </td>
				   </tr>
				   
				   <tr>
					   <td class="labelmedium" width="100"><cf_tl id="Description">: <font color="FF0000">*</font></td>  
					   <td>
					   	   <input type="Text" 
						    value="#detail.servicedescription#" 
							name="svcdescription" 
	                        id="svcdescription"
							style="width:330"
							maxlength="100" 
							class="regularxl enterastab">
			           </td>
				  </tr>
				  
				  <tr> 
				   
				   <td class="labelmedium" width="100"><cf_tl id="Unit">:</td>
				   <td>				   			   
				   
						<cfquery name="OrgUnit" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Organization
						WHERE    Mission     = '#Line.mission#'
						AND      MandateNo   = '#Period.MandateNo#'	
						ORDER BY HierarchyCode
						</cfquery>
				   	  
					  <select name="svcorgunit" id="svcorgunit" style="width:200px" class="regularxl enterastab">
					   <option value=""></option>
					   <cfloop query="Orgunit">
					     <option value="#OrgUnit#" <cfif detail.serviceorgunit eq orgunit>selected</cfif>>#OrgUnitCode# #OrgUnitName#</option>
					   </cfloop>	 
					  </select>
					 
		           </td>
				   
				  </tr>
				   				
				   <tr>
				       <td class="labelmedium"><cf_tl id="Quantity">:<font color="FF0000">*</font></td>
					   <td>
						   <table cellspacing="0" cellpadding="0">
						     <tr>
								 <td>
								 
							   	   <input type="Text"
								       name="svcquantity"
		                               id="svcquantity"
								       value="#detail.quantity#"	
								       onchange="ColdFusion.navigate('../Service/ServiceItemDialogTotal.cfm?sqty='+document.getElementById('svcservicequantity').value+'&qty='+this.value+'&rate='+document.getElementById('svcrate').value,'svctotal')"				    						   				      
									   style="height:25px;text-align:right;width:40;" 
								       maxlength="5"
								       class="regularxl enterastab">
								   
					             </td>
								 <td style="padding-left:2px">
							      <select name="svcuom" id="svcuom" style="height:25px" class="regularxl enterastab">				  
								   	<cfloop query="UoMList">
									   <option value="#Code#" <cfif Detail.UoM eq Code>selected</cfif>>#Description#</option>
									</cfloop>
							   	   </select>	
								 </td>
							 </tr>
						   </table>		   
					   </td>
					</tr> 
					
					<tr>
					<td class="labelmedium"><cf_tl id="Rate">:<font color="FF0000">*</font></td>
				    <td>
									
				   	   <input type="Text"
					       name="svcrate"
		                   id="svcrate"
						   style="text-align: right;width:80;padding-right:2px;" 
					       value="#detail.UoMRate#"
						   onchange="ColdFusion.navigate('../Service/ServiceItemDialogTotal.cfm?sqty='+document.getElementById('svcservicequantity').value+'&qty='+document.getElementById('svcquantity').value+'&rate='+this.value,'svctotal')"				    						   				      						      			    
					       size="10"
					       maxlength="10"
					       class="regularxl enterastab">
		           </td>	
				   </tr> 
						
				  <cfelse>		  	
												
					 <tr>
					   <td class="labelmedium"><cf_tl id="Start">:</td>
					   <td style="z-index:2; position:relative;">
						   			   				
							  <cf_intelliCalendarDate9
								FieldName="svceffective" 					
								Default="#Dateformat(detail.serviceEffective, CLIENT.DateFormatShow)#"	
								class="regularxl enterastab"	
								AllowBlank="True">	
						
						</td>
					</tr>
					<tr>
						<td class="labelmedium"><cf_tl id="End">:</td>
						<td style="z-index:1; position:relative;">
						
							  <cf_intelliCalendarDate9
								FieldName="svcexpiration" 					
								Default="#Dateformat(detail.serviceExpiration, CLIENT.DateFormatShow)#"	
								class="regularxl enterastab"		
								AllowBlank="True">	
						
						</td>	
					</tr>
					
					<tr>
					   <td class="labelmedium" width="100"><cf_tl id="Description">:</td>  
					   <td>
					   	   <input type="Text" 
							    value="#detail.servicedescription#" 
								name="svcdescription" 
		                        id="svcdescription"
								style="width:330"
								maxlength="100" 
								class="regularxl enterastab">
			           </td>
					 </tr>
					
					 <tr> 
				   
					   <td class="labelmedium" width="100"><cf_tl id="Unit">:</td>
					   <td>				   
					   
							<cfquery name="OrgUnit" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM   Organization
							WHERE  Mission     = '#Line.mission#'
							AND    MandateNo   = '#Period.MandateNo#'	
							ORDER BY HierarchyCode
							</cfquery>
					   	  
						  <select name="svcorgunit" id="svcorgunit" style="width:300px"  class="regularxl enterastab">
						   <option value=""></option>
						   <cfloop query="Orgunit">
						     <option value="#OrgUnit#" <cfif detail.serviceorgunit eq orgunit>selected</cfif>>#OrgUnitCode# #OrgUnitName#</option>
						   </cfloop>	 
						  </select>
					 
		           </td>
				   
				  </tr>
					
				  <TR>
					    <td class="labelmedium"><cf_tl id="Quantity">:</td> 
					    <td height="20">
						   <table cellspacing="0" cellpadding="0">
						   <tr><td>
					   	   <input type="Text"
						       name="svcservicequantity"
		                       id="svcservicequantity"
						       value="#detail.servicequantity#"
						       validate="float"				   
						       required="Yes"
							   onchange="_cf_loadingtexthtml='';ColdFusion.navigate('../Service/ServiceItemDialogTotal.cfm?sqty='+this.value+'&qty=1&rate='+document.getElementById('svcrate').value,'svctotal')"				    						   				      						      			    			      					  
						       maxlength="6"
							   style="text-align:right;width:80;" 
						       class="regularxl enterastab">
						   </td>
						   <td style="padding-left:3px">				   
						   <select name="svcuom" id="svcuom" class="regularxl enterastab">				  
							   	<cfloop query="UoMList">
								   <option value="#Code#" <cfif Detail.UoM eq Code>selected</cfif>>#Code#</option>
								</cfloop>
						   </select>	
						   </td>
						   </tr>
						   </table>   
			           </td>
				    </tr>
					
					<tr>
					<td class="labelmedium"><cf_tl id="Rate">:</td>
				    <td>
				   	   <input type="Text"
				       name="svcrate"
					   id="svcrate"
					   style="text-align: right;width:80;" 
				       value="#detail.UoMRate#"
				       validate="float"
					   onchange="_cf_loadingtexthtml='';ptoken.navigate('../Service/ServiceItemDialogTotal.cfm?sqty='+document.getElementById('svcservicequantity').value+'&qty=1&rate='+this.value,'svctotal')"				    						   				      						      			    			      			      
				       maxlength="10"
				       class="regularxl enterastab">
		           </td>	
				   </tr>
						
				</cfif>
				 
				 <tr>
					<td class="labelmedium"><cf_tl id="Total">:</td>
				    <td id="svctotal">
					
					<input type="Text"
					   name="svctotal"
					   style="text-align: right;" 
				       value="#numberformat(detail.amount,',.__')#"	
					   readonly		       
					   style="width:80"
					   maxlength="10"
					   class="regularxl enterastab">
				   	  
		           </td>	
				 </tr>
				 
				 <tr><td></td></tr>
				
				 <tr>		  	 
				   
				   <td style="padding-top:4px" colspan="2" align="center" class="line">
				   			   
					   <cf_tl id="Save" var="1">
					   
					   <input type="button" 
					   	    value   = "#lt_text#" 
							style   = "width:120;height:26px"
					    	class   = "button10g"
						    onclick = "ptoken.navigate('../Service/ServiceItemSubmit.cfm?ID=#URL.ID#&ID2=#url.id2#&mode=#url.mode#','iservicesave','','','POST','serviceform')">
					
					</td>
			    </TR>	
				
				<tr class="hide"><td id="iservicesave"></td></tr>		
					
			</table>
	
	</cfform>

</cfoutput>

</td></tr>

</table>

<cfset ajaxonload("doCalendar")>

