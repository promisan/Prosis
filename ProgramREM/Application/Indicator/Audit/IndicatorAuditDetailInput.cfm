
<cfset orgunit= "">

<cfoutput>

<input type="hidden" name="Indicator_#lor#_#CurrentRow#" id="Indicator_#lor#_#CurrentRow#" value="#Target.TargetId#" ></td>

    <cfif Target.Recordcount neq "0">
	
	<tr bgcolor="f4f4f4">
	
	  <td align="center">#CurrentRow#.</td>	
	    
	  <td>	  
		<img src="#SESSION.root#/Images/arrowright.gif" alt="View details" 
		id="#lor#_#CurrentRow#Exp" border="0" class="show" height="12"
		align="middle" style="cursor: pointer;" 
		onClick="moredetail('#lor#_#CurrentRow#','','#Target.TargetId#')">
		
		<img src="#SESSION.root#/Images/arrowdown.gif" height="12"
		id="#lor#_#CurrentRow#Min" alt="Hide details" border="0" 
		align="middle" class="hide" style="cursor: pointer;" 
		onClick="moredetail('#lor#_#CurrentRow#','','#Target.TargetId#')">
	  </td>
	  
	  <td colspan="3" height="24" >
	  	<a href="javascript:moredetail('#lor#_#CurrentRow#','','#Target.TargetId#')"><font face="Calibri" size="3" color="gray">#IndicatorDescription#</font></a>
	  </td>
	  
	  <td align="center">
	    
	  </td>
	 			 
	  <td colspan="1" align="right" style="padding-right:4px">
	   <font face="Calibri" size="1" color="silver">Target: </font>
	   <font face="Calibri" size="3" color="gray">
	     <cfif Target.TargetValue eq ""><font color="FF8080">Undefined</font>
		 <cfelse>
			 <cfif Indicator.IndicatorType eq "0001">
			 <b>#numberFormat(Target.TargetValue,"__,__#p#")#</b>
			 <cfelse>
			 <b>#numberFormat(Target.TargetValue*100,"__,__._")#%</b>
			 </cfif>
		 </cfif>		
	     #IndicatorUoM#</b></td>
	  <td></td>
	  <td align="center"> </td>
	  
	</tr>
	<tr bgcolor="f4f4f4">
	  <td align="center"></td>
	  <td></td>
	  <td colspan="5"><font face="Calibri" size="2" color="gray">#IndicatorMemo#</td>
	  <td colspan="2"></td>
	</tr>
	<tr bgcolor="Fafafa"><td height="2" colspan="9"></td></tr>
							
	<tr><td colspan="8">
	
	 <table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	 
	 <cfif access eq "0">
	 
	 	<cfinvoke component="Service.Access"
			Method        = "indicator"
			OrgUnit       = "#url.OrgUnit#"
			Indicator     = "'#IndicatorCode#'"
			Role          = "ProgramAuditor"
			ReturnVariable= "Access">
		
	<cfelse>
	
		<cfset access = "EDIT">
	
	</cfif>	
									
	<cfif AuditValue.AuditStatus eq "2">
	    <cfset access = "NONE">
	</cfif>
			
	<cfif Access eq "NONE" or Access eq "READ">
		
	   		<input type="hidden" name="Access_#lor#_#CurrentRow#" id="Access_#lor#_#CurrentRow#" value="0">
			
			<cfif #Indicator.IndicatorType# eq "0001">
			
			  <td width="10%"><cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse><cf_tl id="Count"></cfif>:</td>
			  <td colspan="5">
				 #numberFormat(AuditValue.AuditTargetValue,"__,__#p#")#
		   	  </td>
		   		  	
			<cfelse>
			
		      <td width="10%"><cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse><cf_tl id="Count"></cfif>:</td>
			  <td width="10%" align="right">
		     	#numberFormat(AuditValue.AuditTargetCount,"__,__#p#")#
		      </td>
		   
		      <td width="10%" align="right"><cfif Indicator.NameBase neq "">#Indicator.NameBase#<cfelse><cf_tl id="Base"></cfif>:</td>
			  <td width="10%" align="right">
			    #numberFormat(AuditValue.AuditTargetBase,"__,__#p#")#
		      </td>
		  
		      <td width="10%" align="right">Ratio:</td>
			  <td width="10%" align="right">
			   <cfif AuditValue.AuditTargetValue neq "">
			   #numberFormat(AuditValue.AuditTargetValue*100,"__,__._")#%
			   </cfif>
		      </td>
		    </tr>
			
			</cfif>
			
			<tr>
		      <td></td><td colspan="5"><td>
			      #AuditValue.AuditRemarks#
		      </td>
            </tr>
			
			<tr>
			   <td></td>
    		   <td colspan="5">
			   					   
				    <cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#orgunit#_#indicatorcode#_#AuditValue.AuditId#" 
						Filter=""
						Box="audit#currentrow#"
						Insert="no"
						Remove="no"
						loadscript="No"
						width="100%"
						Highlight="no"
						Listing="yes">
											  				   
				</td>
			</tr>
					
	<cfelse>
	
	    <input type="Hidden" name="Access_#lor#_#CurrentRow#" id="Access_#lor#_#CurrentRow#" value="1">
			
			<cfif AuditValue.AuditStatus eq "0">
				 <cfset cl = "regular">				
			<cfelse>
				 <cfset cl = "regular"> 
			</cfif> 
				 			  
			<cfif Indicator.IndicatorType eq "0001">
					
			      <td width="90"><cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse><cf_tl id="Count"></cfif>:&nbsp;</td>
				    <td colspan="5" width="90%">
			   		<cfinput type="Text" name="TargetValue_#lor#_#CurrentRow#" value="#AuditValue.AuditTargetValue#" message="Please enter a valid target" validate="float" 
					required="No" size="8" maxlength="12" class="#cl#" style="height:22;font:16px;text-align:right;padding-right:1px">
					
					<input type="checkbox" name="NA_#lor#_#CurrentRow#" value="1" 
					<cfif AuditValue.AuditStatus eq "0">checked</cfif>
					onclick="hideN('_#lor#_#CurrentRow#', this.checked)"> 
					<cf_tl id="Not available">
							
				    </td>
				  										  	
			<cfelse>
								      
					<td width="90"><cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse><cf_tl id="Count"></cfif>:&nbsp;</td>
					<td>
				     	<cfinput type="Text" name="TargetCount_#lor#_#CurrentRow#" 
						  value="#AuditValue.AuditTargetCount#" 
						  message="Please enter a valid counted amount/number" 
						  validate="float" 
						  required="No" 
						  size="8" 
						  style="height:22;font:16px;text-align:right;padding-right:1px"
						  maxlength="8" 
						  onchange="javascript: div('TargetCount_#lor#_#CurrentRow#','TargetBase_#lor#_#CurrentRow#','TargetValue_#lor#_#CurrentRow#')"
						  class="#cl#">
						  
						</td>
				     	<td>&nbsp;<cfif Indicator.NameBase neq "">#Indicator.NameBase#<cfelse><cf_tl id="Base"></cfif>:</td><td colspan="1">
					  	<cfinput type="Text" name="TargetBase_#lor#_#CurrentRow#" 
						style="height:22;font:16px;text-align:right;padding-right:1px"
						 value="#AuditValue.AuditTargetBase#" message="Please enter a valid base amount/number" validate="float" 
						 onchange="javascript: div('TargetCount_#lor#_#CurrentRow#','TargetBase_#lor#_#CurrentRow#','TargetValue_#lor#_#CurrentRow#')"
						 required="No" size="8" maxlength="8" class="#cl#">
				      </td>
					  
					   <td>&nbsp;<cf_tl id="Calculated ratio">:</td><td>
					   					   
					     	<input type="text" class="#cl#" name="TargetValue_#lor#_#CurrentRow#" 
							value="<cfif AuditValue.AuditTargetValue neq "">#numberFormat(AuditValue.AuditTargetValue*100,'__,__#p#')#%</cfif>" size="5" maxlength="8" 
							readonly style="font: text-align: center;"> 
							
				      </td>
					  <td>
					    <input type="checkbox" name="NA_#lor#_#CurrentRow#" value="1"
						  <cfif #AuditValue.AuditStatus# eq "0">checked</cfif>
						  onclick="javascript: hideR('_#lor#_#CurrentRow#', this.checked)"> 
				    
					  </td>
					  <td><cf_tl id="Not available"></td>
					  </tr>
							
					</cfif>
																						
					<tr>
				      <td><cf_tl id="Memo">:</td><td colspan="8">
					  <input type="text" style="width:99%" class="regular" name="Remarks_#lor#_#CurrentRow#" value="#AuditValue.AuditRemarks#" maxlength="100" class="regular">
				      </td>
					</tr>
					
					<tr>
					   <td><cf_tl id="Attachment">:</td>
					    <td colspan="5" width="70%">
												
					    <cf_filelibraryN
							DocumentPath="#Parameter.DocumentLibrary#"
							SubDirectory="#orgunit#_#indicatorcode#_#AuditValue.AuditId#" 
							Filter=""
							Box="audit#currentrow#"
							Insert="yes"
							Remove="yes"
							width="100%"
							loadscript="No"
							Highlight="no"
							Listing="yes">
												  				   
					   </td>
					
					</tr>		
														
	    </cfif>	
		
		</table>
		</td></tr>	
			
		<tr><td height="4" colspan="9"></td></tr>
		<tr><td colspan="10" class="line"></td></tr>	
		<tr id="#lor#_#CurrentRow#" class="hide"><td colspan="10">
		         <iframe name="i#lor#_#CurrentRow#"
				         id="i#lor#_#CurrentRow#" 
						 width="100%" 
						 height="#gh+36#" 
						 scrolling="no" 
						 frameborder="0"></iframe>
		</td></tr>
					  			
  <cfelse>
    <input type="hidden" name="TargetValue_#lor#_#CurrentRow#" id="TargetValue_#lor#_#CurrentRow#">
    <input type="hidden" name="Remarks_#lor#_#CurrentRow#" id="Remarks_#lor#_#CurrentRow#">
  </cfif>
  	  
</cfoutput>	  