
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	
		<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemMasterStandard
			    (ItemMaster,
				 StandardCode)
			VALUES
			  ('#URL.ItemMaster#',
				'#URL.StandardCode#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM ItemMasterStandard
		  WHERE ItemMaster  = '#url.ItemMaster#'
		  AND   StandardCode   = '#URL.StandardCode#'
	</cfquery>
		
</cfif>

	<cfquery name="Object" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*
		  FROM   ItemMasterStandard U, Ref_Standard M
		  WHERE  U.ItemMaster = '#URL.ItemMaster#' 
		  AND    U.StandardCode = M.Code
	</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">			
      
   <cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>	
		   
   <cfoutput query="Object">
   	   
	   <tr class="labelmedium" bgcolor="">
	   
	   	  <td height="17" width="24">#currentrow#.</td>
	      <td width="80">#Code#</td>		  
		  <td width="60%">#Description#</td>	
		  <td width="90">#DateFormat(dateExpiration,CLIENT.DateFormatShow)#</td> 
		   
		  <td style="padding-top:3px;">
			   <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/Procurement/Maintenance/Item/RecordStandard.cfm?action=delete&ItemMaster=#URL.ItemMaster#&StandardCode=#Code#','l#url.ItemMaster#_standard');">
		  </td>
		  
	   </tr>  
           
   </CFOUTPUT> 
   
   </table>
      