<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cfoutput>

<cfif URL.Mode eq "Edit">
	  
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
    	FROM Ref_ParameterMission
		WHERE Mission = '#PO.Mission#' 
	</cfquery>
		
	<cfquery name="Nation" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_Nation
	</cfquery>

     <cfloop index="tpe" list="#Parameter.AddressTypeInvoice#,#Parameter.AddressTypeTransport#,#Parameter.AddressTypeShipping#" delimiters=",">
	 
		<cfif tpe neq "">	
		
		<cfquery name="Address" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   PurchaseAddress
			WHERE  PurchaseNo = '#URL.ID1#'
			AND    AddressType = '#tpe#'
		</cfquery>
		
		<cfif Address.recordcount eq "0">
											
				   <cfquery name="Insert" 
			         datasource="AppsPurchase" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
				     INSERT INTO PurchaseAddress
					 		(PurchaseNo, 
							 AddressType, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
				     VALUES ('#URL.ID1#','#tpe#', 
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#')				    
			       </cfquery>
				   
		 	 <cfquery name="Address" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT *
			    FROM   PurchaseAddress
				WHERE  PurchaseNo = '#URL.ID1#'
				AND    AddressType = '#tpe#'
				</cfquery>
		
		</cfif>

		<input type="hidden" name="AddressType" id="AddressType" value="#Address.AddressType#">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td align="left" valign="middle" style="height:34px;font-size:19px" class="labelmedium">
			<cfoutput>#Address.AddressType#</cfoutput>
		    </td>
		    <td height="23" align="right">
		    </td>
		  </tr> 	
		  
		  <tr><td colspan="2" class="line"></td></tr>
		     
		  <tr>
		    <td width="100%" colspan="2">
			
		    <table class="formpadding">
			
			<TR class="labelmedium">
		    <TD style="min-width:200px"><cf_tl id="Address">:</TD>
		    <TD colspan="3">
			   	<input class="regularxl enterastab" type="Text" name="Address1_#tpe#" id="Address1_#tpe#" value="#Address.Address1#" size="50" maxlength="100">			   
			</TD>
			</TR>
			
			<TR class="labelmedium">
		    <TD><cf_tl id="Address 2">:</TD>
		    <TD colspan="3">
			   	<input class="regularxl enterastab" type="Text" name="Address2_#tpe#" id="Address2_#tpe#" value="#Address.Address2#" size="50" maxlength="100">
			</TD>
			</TR>
			
			<TR class="labelmedium">
		    <TD><cf_tl id="Postal code">:</TD>
			<td width="160">				   	
					<input class="regularxl enterastab" type="Text" value="#Address.PostalCode#" name="PostalCode_#tpe#" id="PostalCode_#tpe#" size="20" maxlength="10">
			</td>
			<TD style="padding-left:40px;min-width:200px"><cf_tl id="City">:</TD>
			<td width="100%">
				   	<cfinput class="regularxl enterastab" type="Text" name="City_#tpe#" value="#Address.City#" message="Please enter an city" required="No" size="30" maxlength="40">
			</td>	
			</TR>
			
			<TR class="labelmedium">
		    <TD style="padding-right:10px"><cf_tl id="State/Province">:</TD>
		    <td width="160">				   
				   <input class="regularxl enterastab" type="Text" value="#Address.State#" name="State_#tpe#" id="State_#tpe#" size="20" maxlength="20">
		 	</td>
			<TD style="padding-left:40px;padding-right:10px" width="120"><cf_tl id="Country">:</TD>
			<td width="100%">
				 	<select name="Country_#tpe#" required="No" class="regularxl enterastab">
				    <cfloop query="Nation" >
					<option value="#Code#" <cfif #Address.Country# eq #Code#>selected</cfif>>#Name#</option>
					</cfloop>
			</td>	
			
			</TR>
			
			<TR class="labelmedium">
		    <TD><cf_tl id="Telephone">:</TD>		   
			<td width="160">
			   		<input type="Text" name="TelephoneNo_#tpe#" id="TelephoneNo_#tpe#" value="#Address.TelephoneNo#" size="10" maxlength="30" class="regularxl enterastab">
			</td>				
			<td style="padding-left:40px" width="120">Fax:</TD>
			<td width="100%">
				<input type="Text" name="FaxNo_#tpe#" id="FaxNo_#tpe#" value="#Address.Faxno#" size="12" maxlength="30" class="regularxl enterastab">
			</td>				
			</TR>
			
			<TR class="labelmedium">
		    <TD><cf_tl id="eMail">:</TD>
		    <TD colspan="3">
			   	<cfinput type="Text" name="emailaddress_#tpe#" value="#Address.emailaddress#" validate="email" message="Please enter a valid eMail address" required="No" size="20" maxlength="50" class="regularxl enterastab">
		 	</TD>
			</TR>
			
			<TR class="labelmedium">
			    <TD><cf_tl id="Contact">:</TD>
			    <TD colspan="3"><input type="Text" name="Contact_#tpe#" id="Contact_#tpe#" value="#Address.Contact#" size="50" maxlength="80" class="regularxl enterastab"></TD>
			</TR>
			
			</table>
			
			</td>
			
			</table>
			
			<br>
			
		</cfif>	
		
			 
	 </cfloop>

<cfelse>

	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
    	FROM Ref_ParameterMission
		WHERE Mission = '#PO.Mission#' 
	</cfquery>

		<cfquery name="Address" 
             datasource="AppsPurchase" 
             	 username="#SESSION.login#" 
            	 password="#SESSION.dbpw#">
              	 SELECT  * FROM PurchaseAddress
			     WHERE PurchaseNo = '#URL.ID1#'
		 </cfquery>		 
				
		<cfif Address.recordcount eq "0">
		
			<cfloop index="itm" 
		    	list="#Parameter.AddressTypeInvoice#,#Parameter.AddressTypeShipping#,#Parameter.AddressTypeTransport#">
											
				   <cfquery name="Insert" 
			         datasource="AppsPurchase" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
				     INSERT INTO PurchaseAddress
					 		(PurchaseNo, 
							 AddressType, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
				     VALUES ('#URL.ID1#','#itm#', 
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#')
				   
			       </cfquery>
													
			</cfloop>
			
			 <cfquery name="Address" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT *
			    FROM PurchaseAddress
				WHERE PurchaseNo = '#URL.ID1#'
				</cfquery>
		
		</cfif>
					
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formspacing">
		
		<cfloop query="Address">
		<cfif currentrow neq "1">
		<tr><td colspan="5" class="line"></td></tr>
		</cfif>
		<tr class="labelmedium">
		   <td align="center" bgcolor="white">
		   
		  <cfif URL.Mode eq "Edit">
		  
		  	<cf_img icon="edit" onClick="javascript:addressEdit('#URL.ID1#','edit');">
		  						 
		  <cfelse>
		  
		   <img src="#SESSION.root#/Images/address.gif"
		     name="img2_#addresstype#"
		     border="0"			 
			 bordercolor="silver"
		     align="absmiddle">
			 
		  </cfif>			  
		  
		  
		  </td>
		  
		  <td bgcolor="white">#AddressType#</td>
		  <td bgcolor="white">#Address1#</td>
		  <td bgcolor="white">#City# #Country#</td>
		  <td bgcolor="white">#Contact#</td>
		</tr>
		<cfif postalcode neq "" or address2 neq "" or state neq "">
		<tr class="labelmedium">
		   <td align="center">
		   </td>
		  <td>#PostalCode#</td>
		  <td>#Address2#</td>
		  <td>#State# </td>
		  <td>#TelephoneNo#</td>
		</tr>
		</cfif>
				
		</cfloop>
		
		</table>

</cfif>		
	
</cfoutput>	