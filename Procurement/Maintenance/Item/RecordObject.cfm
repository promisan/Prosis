
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	
		<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemMasterObject
			    (ItemMaster,
				 ObjectCode)
			VALUES
			  ('#URL.ItemMaster#',
				'#URL.ObjectCode#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM ItemMasterObject
		  WHERE ItemMaster  = '#url.ItemMaster#'
		  AND   ObjectCode   = '#URL.ObjectCode#'
	</cfquery>
		
</cfif>

<cfquery name="Clean" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ItemMasterObject
	  WHERE  ObjectCode NOT IN (SELECT Code FROM Program.dbo.Ref_Object)
</cfquery>

<cfquery name="Object" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*
		  FROM   ItemMasterObject U, Program.dbo.Ref_Object M
		  WHERE  U.ItemMaster = '#URL.ItemMaster#' 
		  AND    U.ObjectCode = M.Code
</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">			
      
   <cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>	
		   
   <cfoutput query="Object">
   
	   
	   <tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
	   
	   	  <td height="17" width="20">#currentrow#.</td>
	      <td width="60">#CodeDisplay#</td>
		  <td width="90">#ObjectUsage#</td>
		  <td width="70%">#Description#</td>	 
		   
		  <td style="padding-top:3px;">
			 <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/Procurement/Maintenance/Item/RecordObject.cfm?action=delete&ItemMaster=#URL.ItemMaster#&ObjectCode=#Code#','l#url.ItemMaster#_object');">
		  </td>
		  
	   </tr>  
           
   </CFOUTPUT> 
   
   </table>
      