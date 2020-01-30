<cfquery name="Approval" datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	SELECT * 
	FROM Approval_#Session.ACC#_#SESSION.FileNo#
</cfquery>
	
<cfif Approval.recordcount neq "0">

	<table width="100%" style="border:0px solid silver" class="navigation_table">
			 <tr><td class="approval linedotted labellarge" colspan="8" style="padding-left:5px">Approved</td></tr>
			    
			 <cfoutput query="Approval" group="Period">
			 
				   <cfquery name="Total"
					dbtype="query">
					SELECT    sum(ReservationAmount) as Amount
					FROM      Approval
					WHERE     Period = '#Period#'
				  </cfquery>
			 
				 <tr bgcolor="ffffaf" class="labelmedium approval"> 		
				    <td></td>      
					<td height="18" colspan="6">#Period#</td>		  
					<td align="right" style="padding-right:16px"><b>#NumberFormat(Total.Amount,",.__")#</b></td>					 
				 </tr>				 
				
				 <cfset oe = replace(URL.ObjectCode,".","","ALL")> 
				 <cfset oe = replace(oe," ","","ALL")>
			    
				 <cfoutput>
				 
					 <tr class="approval labelmedium line navigation_row">
					 	<td width="4%" align="center" height="15" style="padding-top:3px">
						   <cf_img icon="open"  onClick="ProcReqEdit('#RequisitionNo#','dialog')" tooltip="Open Requisition">					 
					   </td>
					   <td width="10%"><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')"><font color="0080C0">#Reference#</font></a></td>
					   <td width="80">#ObjectCode#</td>
					   <td colspan="4" width="80%">#ItemMasterDescription# #RequestDescription#</td>					   		 
					   <td width="10%" align="right" style="padding-right:16px">#NumberFormat(ReservationAmount,",.__")#</b></td>				 					  
					 </tr>									 
				 
				 </cfoutput>
								 
			 </cfoutput> 
	
	</table>
	
</cfif>
 
<cfset ajaxOnLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>	
