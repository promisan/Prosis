
<!--- set batch progress --->


<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     BatchNo,	
			  ActionStatus,		    
			  (SELECT  count(*) FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo) as Lines,	
			  (SELECT  count(*) FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo and ActionStatus='1') as Cleared				  			   	   			  			   
    FROM      WarehouseBatch B 
	WHERE     B.BatchNo = '#url.BatchNo#'
</cfquery>	

<cfoutput>  

<cfif get.recordcount eq "0">

<cfelseif get.ActionStatus eq "9">

	<table>
 	<tr class="labelmedium">
	   <td style="color:red;font-weight:bold" align="center"><cf_tl id="Cancelled"></td>	  
    </tr>
   </table> 

<cfelseif get.ActionStatus eq "1">

	<table>
 	<tr class="labelmedium">
	   <td style="font-size:16px;color:green;" align="center"><cf_tl id="Confirmed"></td>	  
    </tr>
   </table> 

<cfelseif get.cleared lt get.Lines>

	<table>
 	<tr class="labelmedium">
	   <td style="width:30px;font-size:16px" align="center">#get.cleared#</td>
	   <td style="font-size:16px">|</td>
	   <td align="center" style="width:30px;font-size:16px">#get.lines#</td>
    </tr>
   </table>
   
<cfelse>  

	<table>
 	<tr class="labelmedium">
	   <td style="font-size:16px;color:green" align="center"><cf_tl id="Completed"></td>	  
    </tr>
   </table> 
	
</cfif>

</cfoutput>