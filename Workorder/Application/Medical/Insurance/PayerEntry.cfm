<cfparam name="URL.payerid"  default="">

<cfquery name="PayerTree" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT TreeCustomerPayer
	  FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.mission#'
	  AND    TreeCustomerPayer IS NOT NULL  		
</cfquery>	

<cfquery name="qPayer" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  SELECT  O.OrgUnitName,
	          CP.*
	  FROM    CustomerPayer CP INNER JOIN 
	          Organization.dbo.Organization O ON CP.OrgUnit = O.OrgUnit
	  <cfif URL.PayerId neq "">
	  WHERE   PayerId='#URL.PayerId#'
	  <cfelse>
	  WHERE   0=1
	  </cfif>	  	  
</cfquery>	

	
<cfoutput>

<cfform name="formpayer" id="formpayer" onsubmit="return false">	

	<table align="center" width="93%" cellspacing="0" cellpadding="0" border="0" class="formpadding formspacing">
	
	   <tr height="10px"><td colspan="4" id="process"></td></tr>
	 
	   <tr>
	   
	    <td colspan="2" width="100%" height="55" align="left" valign="middle" style="padding-top:10px;font-size:23px;height:45;padding-left:0px" class="labellarge">
		     	<cfif URL.payerid eq "">
		   			<cf_tl id="Entry Insurance record"></b>
		   		<cfelse>
		   			<cf_tl id="Edit Insurance record"></b>
		   		</cfif>
		   	</font>
		 </td>
	   </tr> 
	   
	   <tr height="5px"><td colspan="4" id="process"></td></tr>			
				
		<tr>
			
			<td width="10%" class="labelmedium">			
				<cf_tl id="Insurance">:				
			</td>			
			<td width="40%">

				<cfquery name="qOrganization" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT   *
				  FROM     Organization.dbo.Organization O
				  WHERE    Mission = '#PayerTree.TreeCustomerPayer#' 
				  ORDER BY OrgUnitName ASC
				</cfquery>	
																
				<input type="hidden" id="Mission1" name="Mission1" value="#PayerTree.TreeCustomerPayer#">
					
				<select name="ReferenceOrgUnit1" id="ReferenceOrgUnit1" class="regularxl">
				    <option value=""></option>
					<cfloop query="qOrganization">
						<option value="#OrgUnit#" <cfif OrgUnit eq qPayer.OrgUnit>selected</cfif>>#OrgUnitName#</option>
					</cfloop>
				</select>

			</td>		   
		</tr>
				
		
		
		<tr>
			
			<td class="labelmedium">
				<cf_tl id="Policy">:
			</td>			
			<td>
				<input type="text" id="accountNo" name="accountNo" class="regularxl enterastab" value="#qPayer.accountNo#" size="20" maxlength="20">
			</td>		   
		</tr>		
		
		<tr>
			
			<td class="labelmedium">
				<cf_tl id="Certification">:
			</td>			
			<td>
				<input type="text" id="Reference" name="Reference" class="regularxl enterastab" value="#qPayer.Reference#" size="20" maxlength="20">
			</td>		   
		</tr>						
		
		<tr>
			
			<td class="labelmedium">
				<cf_tl id="Date Effective">:
			</td>			
			<td>
				<cf_intelliCalendarDate9
				    FieldName="DateEffective" 			 
				    class="regularxl enterastab"			  
				    Default="#DateFormat(qPayer.DateEffective,CLIENT.DateFormatShow)#">

			</td>		   
		</tr>		
				
		<tr>
			
			<td class="labelmedium">
				<cf_tl id="Date Expiration">:
			</td>			
			<td>
				   <cf_intelliCalendarDate9
				      FieldName="DateExpiration" 			 
					  class="regularxl enterastab"			  
				      Default="#DateFormat(qPayer.DateExpiration,CLIENT.DateFormatShow)#">
			</td>		   
		</tr>			

		<tr>
			
			<td class="labelmedium">
				<cf_tl id="Remarks">:
			</td>			
			<td>
				<textarea class="regular" style="width:100%;font-size:13px;padding:4px" cols="70" rows="3" name="Remarks" id="Remarks" >#qPayer.Memo#</textarea>
			</td>		   
		</tr>	
						
		<tr>
			
			<td style="padding-top:10px" colspan="2" width="100%">
				  <table align="center" cellspacing="0" cellpadding="0" class="formspacing">
				  	<tr>
					
					   <td>
					   
					     <cf_tl id="Cancel" var="1">
						 <input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
					       class="button10g"  
						    onClick="closeInsurance('#URL.owner#','#URL.id#')">   
					   
					   </td>		
					   			  
					   <td style="pading-left:3px">
					   
					     <cf_tl id="Save" var="1">
					   	 <cfif URL.payerId eq "">
						 
						 	<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
					       	class="button10g"  
						   	onClick="addInsurance('#URL.owner#','#URL.id#')">
							
						 <cfelse>
						 
						 	<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
					       	class="button10g"  
						   	onClick="updateInsurance('#URL.payerId#')">						  
							
						 </cfif>  
					   	 
					    </td>
					</tr>
				   </table>
			</td>
		</tr>				


		
	</table>
</cfform>
</cfoutput>

<cfset AjaxOnload("doCalendar")>