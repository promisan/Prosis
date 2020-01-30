
<!--- Query returning search results --->

<!---- 
<cfquery name="Search" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		         
	SELECT   A.*,
	         N.Name,
			 T.Description AddressTypeDescription,
			 CA.DateEffective
	FROM     System.dbo.Ref_Address A 
			 INNER JOIN CustomerAddress CA
			 	ON    A.AddressId = CA.AddressId AND CA.CustomerId = '#url.customerid#'
			 INNER JOIN System.dbo.Ref_Nation N
			 	ON    N.Code = A.Country
			 INNER JOIN Ref_AddressType T
			 ON    CA.AddressType = T.AddressType
</cfquery>
--->

<cfquery name="Search" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*,
	         B.Name, 
		     R.Description as AddressTypeDescription
	FROM     vwCustomerAddress A, 	        
	         System.dbo.Ref_Nation B, 
		     Ref_AddressType R
	WHERE    CustomerId    = '#URL.CustomerId#'
	AND      A.Country     = B.Code
	AND      A.AddressType = R.AddressType
	ORDER BY A.AddressType DESC 
</cfquery>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
 
  <tr>
    <td height="30" class="labelmedium" style="height:40px;font-size:25px;padding-left:2px;font-weight:200">
	<cfoutput>	
	<cf_tl id="Address">/<cf_tl id="Contact"></b>
	</td>
    <td align="right">
		   
		<cf_tl id="New Address" var="1">			
		<a href="javascript:addressentry('#URL.CustomerId#')">[#lt_text#]</a>	
			
	</cfoutput>
    </td>
  </tr>
     
  <td width="100%" colspan="2">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table formpadding">
			
	<TR class="line labelmedium">
	    <td height="20" width="2%"></td>
	    <td width="14%"><cf_tl id="Type"></td>
		<TD width="30%"><cf_tl id="Address"></TD>
		<TD width="15%"><cf_tl id="City"></TD>
		<TD width="15%"><cf_tl id="Country"></TD>
		<TD width="23%" align="right"><cf_tl id="Effective"></TD>
	</TR>
		
	<cfoutput query="Search">
	
		<TR class="navigation_row line labelmedium">
		<td align="center" style="padding-left:12px;padding-top:2px;padding-right:12px"> 		   
		    <cf_img  icon="edit" navigation="Yes" onclick="addressedit('#URL.CustomerID#','#AddressId#')">		  			
		</td>	
		
		<td><a href="javascript:addressedit('#URL.CustomerId#','#AddressId#')"><font color="0080C0">#AddressTypeDescription#</a></td>		
		<td style="padding-left:4px">#Address# #Address2# #AddressRoom#</td>		
		<td>#AddressCity#</td>
		<td>#Name#</td>		
		<td align="right"><cf_space spaces="30">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
		</TR>
			
	</cfoutput>
	
	<cfif search.recordcount eq 0>
	
		<tr>
		<td colspan="6" height="200" align="center" class="labelmedium"><cf_tl id="There are no address records to show in this view" class="message">.</font>
		 <cfoutput>				
			<a href="javascript:addressentry('#URL.CustomerId#')"><font color="0080C0"><u><cf_tl id="New Address"></font></a>	
		 </cfoutput>
		 </td>
		</tr>
	
	</cfif>
	
	</TABLE>
	
</td></tr>

</table>	

<cfset ajaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>
