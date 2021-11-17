
<cfset mission = "">

<cf_verifyOnBoard PersonNo = "#URL.ID#">
 
<cfquery name="AddressType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AddressType
</cfquery>

<cfquery name="Relationship" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Relationship
</cfquery>

<cfquery name="Contact" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_Contact
</cfquery>

<cfform name="personaddressform" onsubmit="return false">

<table width="100%" align="center" class="formpadding">

  <tr><td id="addressprocess"></td></tr>
  <tr><td style="border:0px dotted silver;padding:2px">
  
<cfoutput><input type="hidden" name="PersonNo" id="PersonNo" value="#URL.ID#" class="regular"></cfoutput>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <cfoutput>
      
	  <tr>
	    <td align="left" valign="middle" class="labellarge" style="height:60px;font-size:28px;padding-bottom:3px">
		<cfoutput>
		    
		    <img src="#SESSION.root#/Images/address.png" height="48" alt="Click to view details" border="0" align="absmiddle">
	    	<cf_tl id="Register"><cf_tl id="Contact Information"></b></font>
		</cfoutput>
	    </td>
			    
	  </tr> 
	  
  </cfoutput>	  
       
  <tr>
    <td width="100%" colspan="2" style="padding-top:2px">
			
    <table width="96%" align="center" class="formpadding">
	
	<TR class="fixlengthlist">
    <TD class="labelmedium" style="padding-left:8px;min-width:133px"><cf_tl id="Address type">: <font color="FF0000">*</font</TD>
	
    <TD>
	
		<table>
		<tr>
		<td>
	
	   	<select name="AddressType" required="No" class="regularxl enterastab" style="width:280px">
		    <cfoutput query="AddressType">
				<option value="#AddressType#">#Description#</option>
			</cfoutput>
	   	</select>		
		</TD>
		
	    <TD class="labelmedium" style="padding-left:8px"><cf_tl id="Effective date">:</TD>
	   			
			   	<td style="padding-left:15px">
			
					<cf_intelliCalendarDate9
						FormName="addressentry"
						class="regularxl enterastab"
						FieldName="DateEffective" 
						DateFormat="#APPLICATION.DateFormat#"
						message="Please enter an effective date"
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"	
				    	AllowBlank="False">
				
				</td>
							
				<TD class="labelmedium" style="padding-left:10px"><cf_tl id="Expiry">:</TD>
			    
				<TD style="padding-left:15px">
				
					<cf_intelliCalendarDate9
						FormName="addressentry"
						class="regularxl enterastab"
						FieldName="DateExpiration" 
						DateFormat="#APPLICATION.DateFormat#"
						Default=""
						AllowBlank="True">				
					
				</TD>
		
		</tr>
		
	   </table>
						
	</TD>	
						
	</TR>	
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
			
	<tr><td colspan="2" valign="top">	
	    <!--- address object --->	
		<cf_address mode="edit" styleclass="labelmedium" addressscope="Employee" mission="#mission#" emailrequired="No">				
	</td></tr>
		
	<!--- address contact --->	
	
	<tr><td style="height:3px"></td></tr>
		
	<TR>
	    <TD class="labelmedium" width="10%" style="min-width:177px;padding-left:6px"><cf_tl id="Contact">:</TD>
	    <TD style="padding-left:0px;" align="left">
		
		 <table cellspacing="0" cellpadding="0">
		 <tr>
			
			
			<td>
		
			   	<input type="Text"   name="ContactIndexno"   id="ContactIndexno" value="" size="20" maxlength="20" class="regularxl enterastab">	
				<input type="hidden" name="ContactPersonNo"  id="ContactPersonNo" value="" size="20" maxlength="20">	
				<input type="hidden" name="Contactlastname"  id="Contactlastname" size="10" maxlength="20" readonly>
				<input type="hidden" name="Contactfirstname" id="Contactfirstname" size="10" maxlength="20" readonly>
			
			</td>
			
			 <td style="padding-left:3px">
	
				 <cfoutput>	  
			     <img src="#SESSION.root#/Images/contract.gif" alt="Select employee" name="img0" 
					  onMouseOver="document.img0.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="16" height="18" border="0" align="absmiddle" 
					  onClick="selectperson('webdialog','ContactPersonNo','ContactIndexno','Contactlastname','Contactfirstname','Contact','','')">
				</cfoutput>		
			
			</td>
		</tr>
		</table>

		</td>
	</tr>
	
	<tr><td style="height:3px"></td></tr>
							
	<TR>
	    <TD class="labelmedium" style="min-width:170px;padding-left:6px"><cf_tl id="Name">:</TD>
	    <TD width="100%" style="padding-left:0px;" align="left">
		
			<table cellspacing="0" cellpadding="0">
			
			<tr>
				<td>
				  			   
				   <select name="ContactRelationShip" required="No" class="regularxl enterastab>
				    <option value="" selected>n/a</option>
			    	<cfoutput query="Relationship">
						<option value="#Relationship#">#Description#</option>
					</cfoutput>
				   </select> 	
				   
				</td>				
				
				<td style="padding-left:4px"><input type="Text" name="Contact" id="Contact" size="40" maxlength="40" class="regularxl enterastab"></td>
			
			</tr>
	
			</table>	
				
		</TD>
	</TR>
	
	<tr><td style="height:3px"></td></tr>
		
	<TR>
	
    <TD class="labelmedium" style="padding-left:6px;padding-top:5px" valign="top" colspan="1"><cf_tl id="Contact numbers">:</td>
	
	<td style="padding-left:1px">
	   		
		<table class="formpadding">
		
		<cfset row = 0>
		
		<cfoutput query="Contact">
			<cfset row = row+1>
			<cfif row eq "1"><tr></cfif>		
				<td style="height:21;padding-right:10px" class="labelit"><cf_tl id="#Description#">:</td>				
			    <TD style="height:21;padding-left:5px;padding-right:15px"><input type="Text" name="Contact_#currentrow#" value="" size="13" maxlength="20" class="regularxl enterastab"></TD>
			<cfif row eq "3"></tr><cfset row = 0></cfif>	
		</cfoutput>
		
		</table>
		</td>
		
	</TR>	
			   			
   </table>
   
   </td>
   </tr>
   
   <tr><td height="1" colspan="2" class="line"></td></tr>

	<tr><td colspan="2" align="center" style="padding-top:4px">
	
	   <cfoutput>
	   
	    <cf_tl id="Back" var="1">   
	
	   <input type    = "button" 
	          style   = "width:120" 
			  name    = "cancel" 
			  id      = "cancel" 
			  value   = "#lt_text#" 
	          class   = "button10g" 
		      onClick = "ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Address/EmployeeAddressDetail.cfm?webapp=#url.webapp#&mode=edit&id=#url.id#','addressdetail')">
		
	   <cf_tl id="Reset" var="1">  
	   		  
	   <input class   = "button10g" 
	          style   = "width:120" 
			  type    = "reset"  
			  name    = "Reset" 
			  id      = "Reset" 
			  value   = "#lt_text#">
	
	   <cf_tl id="Save" var="1"> 		  
	   
	   <input class   = "button10g" 
	          style   = "width:120" 
			  type    = "button" 
			  name    = "Submit" 
			  id      = "Submit" 
			  value   = "#lt_text#" 
			  onclick = "personaddressentryvalidate('#url.webapp#')">	 
	   
	   </cfoutput>
	   
   </td>
   </tr>

</table>

</CFFORM>

<cfset ajaxonload("doCalendar")>
