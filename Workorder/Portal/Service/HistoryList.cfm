
<!--- Check pending clearance --->
<cfparam name="Form.Reference" default="">
<cfparam name="Form.datestart" default="">
<cfparam name="Form.dateend" default="">

  <cfset condition = "">
  
  <cfif Form.Reference neq "">
        <cfset condition  = "#condition# AND (R.Reference LIKE '%#Form.Reference#%')">
  </cfif>	
  
  <cfif Form.DateStart neq "">
	     <cfset dateValue = "">
		 <CF_DateConvert Value="#Form.DateStart#">
		 <cfset dte = #dateValue#>
		 <cfset condition = "#condition# AND R.RequestDate >= #dte#">
  </cfif>	
  
  <cfif Form.DateEnd neq "">
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#Form.DateEnd#">
		 <cfset dte = #dateValue#>
		 <cfset condition = "#condition# AND R.RequestDate <= #dte#">
  </cfif>	

<cfquery name="Result" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     R.RequestId,
	           R.Reference, 
	           R.RequestDate, 
			   R.OrgUnit, 
			   R.ActionStatus, 
			   L.ServiceItem, 
			   SI.Description AS Description, 
			   CL.Description AS ServiceClass, 
			   SUM(L.Amount) AS Amount
	FROM       Request R INNER JOIN
	           RequestLine L ON R.RequestId = L.RequestId INNER JOIN
	           ServiceItem SI ON L.ServiceItem = SI.Code INNER JOIN
	           ServiceItemClass CL ON SI.ServiceClass = CL.Code
	WHERE      R.OfficerUserId = '#SESSION.acc#'
        
			  <cfif URL.Mode eq "pending" or URL.Mode eq "history">
			   AND      R.ActionStatus IN ('0','1')
			  <cfelse>
			   AND      R.ActionStatus IN ('2')
			  </cfif>
			 
			   #preservesingleQuotes(condition)#
	GROUP BY   R.RequestId,
	           R.Reference, 
	           R.RequestDate, 
			   R.OrgUnit, 
			   R.ActionStatus, 
			   L.ServiceItem, 
			   SI.Description, 
			   CL.Description 
	ORDER BY  R.RequestDate		
	  
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR>
		<TD height="20"></TD>
		<TD width="80"><cf_tl id="RequestNo"></TD>
		<TD width="20%"><cf_tl id="Class"></TD>
		<TD width="20%"><cf_tl id="Service"></TD>				
		<TD><cf_tl id="Date"></TD>		
		<TD><cf_tl id="Unit"></TD>	
		<TD  align="center"><cf_tl id="Status"></TD>			
		<TD align="right"><cf_tl id="Amount"></TD>
		<TD></TD>
	</TR>
	<tr><td colspan="9" height="1" bgcolor="silver"></td></tr>
	
	<cfset total = 0>
	
<cfoutput query="Result">
	
		
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#">
	<td align="center" height="17" width="40">
	
			<img src="#SESSION.root#/Images/icon_expand.gif" alt="More details" 
				id="#requestid#Exp" border="0" class="show" 
				align="absmiddle" style="cursor: hand;" 
				onClick="more('#requestId#')">
				
				<img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="#requestid#Min" alt="More details" border="0" 
				align="absmiddle" class="hide" style="cursor: hand;" 
				onClick="more('#requestid#')">
	</td>		
	
	<td><a href="javascript:more('#requestId#')" title="More details"><font color="0080FF">#Reference#</a>
	
		<!---
			 <img src="#SESSION.root#/images/print_small5.gif" 
			    align="absmiddle" 
				style="cursor:hand"
				alt="Print Requisition" 
				border="0" 
				onclick="mail2('print','#Reference#')">	
				
		--->		
		
	</td>	
	
	<TD><a href="javascript:more('#requestId#')" title="More details">#ServiceClass#</a></TD>
	<TD><a href="javascript:more('#requestId#')" title="More details">#Description#</a></TD>
	<td>#Dateformat(RequestDate, CLIENT.DateFormatShow)#</td>
	<td>#Orgunit#</td>
	
	<TD align="center">
	   <cfif actionstatus eq "0" or actionstatus eq "1">
		  Pending			  
	   <cfelse>
	   	  Completed			
	   </cfif>
	</TD>
	
	<td align="right" id="amount_#requestId#">#NumberFormat(Amount,'__,____.__')#</td>

	<td width="35" align="center">&nbsp;&nbsp;
       <cfif actionstatus eq "0"> 
	       <A href="javascript:reqpurge('#requestid#','0')">
	           <img src="#SESSION.root#/images/delete5.gif" alt="Purge" name="Cancel" id="Cancel" width="11" height="11" border="0" align="middle">
	       </a>
	   </cfif>
    </td>
	<cfset total = total + Amount>
	</TR>
	
	<cfset wflnk = "..\Request\ServiceView.cfm">
			   
    <input type="hidden" 
          name="workflowlink_#requestid#" 
          value="#wflnk#"> 
	
	<tr id="b#RequestId#" class="hide">
		<td colspan="10" id="i#RequestId#"></td>
	</tr>
	
	<tr><td colspan="9" height="1" bgcolor="E5E5E5"></td></tr>
	
</cfoutput>

<cfoutput>
	
		<tr>
			<td colspan="5"></td>
			<td colspan="2"><!--- <cf_tl id="Total">: ---></td>
		    <td colspan="1" align="right" id="total"><b>#NumberFormat(total,'__,____.__')#</b></td>
			<td></td>
		</tr>
		<tr><td height="3"></td></tr>
		
</cfoutput>

<tr><td height="5"></td></tr>

</TABLE>	
