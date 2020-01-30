
<cfparam name="url.webapp"  default="">
<!--- Query returning search results --->

<cfquery name="Search" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*,
	         B.Name, 
		     R.Description as AddressTypeDescription
	FROM     vwPersonAddress A, 	        
	         System.dbo.Ref_Nation B, 
		     Ref_AddressType R
	WHERE    PersonNo      = '#URL.ID#'
	AND      A.Country     = B.Code
	AND      A.AddressType = R.AddressType
	ORDER BY A.AddressType DESC
</cfquery>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
 
  <tr>
    <td style="padding-top:4px;height:65px;padding-left:10px;font-size:23px" class="labellarge">
        <img src="<cfoutput>#session.root#/Images/Contact.png</cfoutput>" style="height:65px;float:left;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Address Information</h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Maintain your contact information.</p>
        <div class="emptyspace" style="height: 30px;"></div>        
	</td>
        
    <cfoutput>
    <td align="right" style="padding-right:5px;padding-bottom:3px" valign="bottom">
			
        <cfif mode eq "edit">
		   
			<cf_tl id="Add new Contact" var="1">			
			<a href="javascript:personaddressentry('#URL.ID#')"><font size="2" face="Verdana" color="0080C0">[#lt_text#]</font></a>	
				
		</cfif>
			
	</cfoutput>
    </td>
  </tr>
     
  <td width="100%" colspan="2">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
		
	<tr><td class="line" colspan="9"></td></tr>	
	
	<TR  class="labelmedium line">
	    <td height="20" width="2%"></td>
	    <td width="20%"><cf_tl id="Type"></td>
		<TD width="25%"><cf_tl id="Address"></TD>
		<TD width="15%"><cf_tl id="City"></TD>		
		<TD width="10%"><cf_tl id="Zone"></TD>	
		<TD width="20%"><cf_tl id="Contact"></TD>
		<TD width="5%"><cf_tl id="Source"></TD>
		<TD width="23%" align="right"><cf_tl id="Effective"></TD>
	</TR>
	
	<cfset last = '1'>
	
	<cfif search.recordcount eq "0">
	
		<tr>
		<td colspan="9" height="200" align="center" class="labelit"><font face="Calibri" size="2" color="gray">There are no address records to show in this view.</font>
		 <cfoutput>				
			<a href="javascript:personaddressentry('#URL.ID#')"><font size="2" color="0080C0"><u><cf_tl id="Add new Contact"></font></a>	
		 </cfoutput>
		 </td>
		</tr>
		
	</cfif>
	
	<cfoutput query="Search">
	
		<TR class="cellcontent navigation_row line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
		
		<td align="center" style="padding-left:12px;padding-top:4px;padding-right:12px"> 		   
		    <cf_img icon="edit" navigation="yes" onclick="personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')">		  			
		</td>	
		
		<td><a href="javascript:personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')"><font color="0080C0">#AddressTypeDescription#</a></td>
		
		<td style="padding-left:4px">
		    <a href="javascript:personaddressedit('#URL.ID#','#AddressId#','#url.webapp#')"><font color="0080C0">#Address# #Address2# #AddressRoom#</a>
		</td>
		
		<td>#AddressCity#, #Name#</td>
		
		<td>
		<cfif AddressZone neq "">
		
			<cfquery name = "qAddressZone" 
			Datasource = "AppsEmployee">
				SELECT * 
				FROM   Ref_AddressZone	
				WHERE  Code = '#AddressZone#'
			</cfquery>
			#qAddressZone.Description#	
			
		</cfif>	
		</td>
		<TD>#Contact# #ContactRelationship#</TD>
		<td>#source#</td>
		<td align="right" style="padding-left:4px;padding-right:4px">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
		</TR>
	
		<TR class="cellcontent line navigation_row_child" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
	
		    <td colspan="1"></td>
			<td colspan="8" align="left">
					
			<cfquery name="ContactNo" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT P.*, (
				      SELECT ContactCallSign 
					  FROM   PersonAddressContact 
					  WHERE  PersonNo = '#personno#' 
					  AND Addressid = '#AddressId#'
					  AND ContactCode = P.Code ) as CallSign
			    FROM Ref_Contact P
			</cfquery>
			
				<table cellspacing="0" cellpadding="0">
				<tr>
				<cfset row = 0>
				
					<cfloop query="contactNo">	
					  	
					  <cfset row = row+1>
					  	
					  <cfif row eq "4">
					  
					    <tr>
						<cfset row = 0>
						
					  </cfif> 
					  
					  <td style="padding-left:10px" class="labelit"><cf_tl id="#Description#">:</td>
					  <td style="padding-left:10px" class="labelit">						  
					      <font color="gray">
					      <cfif callsign eq "">n/a<cfelse><b>#CallSign#</cfif></b>	
					      </font>
					  </td>
					  <td>&nbsp;&nbsp;</td>
					  
					</cfloop>	
					
				</tr>
				</table>	
			
			</td>
	
		</TR>
		
	</cfoutput>
	
	</TABLE>
	
</td></tr>

</table>

<cfset ajaxonload("doHighlight")>