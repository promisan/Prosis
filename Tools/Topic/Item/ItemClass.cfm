
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cfquery name="check" datasource="AppsMaterials">
		SELECT  * 
		FROM    ItemTopic
		WHERE   ItemNo = '#url.ItemNo#'
		AND     Topic  = '#url.Topic#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
			<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ItemTopic
				    (ItemNo,
					 Topic,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
				  ('#URL.ItemNo#',
					'#URL.Topic#',			
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
			</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ItemTopic
	  WHERE  ItemNo = '#url.ItemNo#'
	  AND    Topic   = '#URL.Topic#'
	</cfquery>
		
</cfif>

<cfquery name="Items" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT M.*
	  FROM   ItemTopic U, Item M
	  WHERE  U.Topic= '#URL.Topic#' 
	  AND    U.ItemNo = M.ItemNo
	</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">			
      
   <cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>	
		   
   <cfoutput query="Items">
   <tr><td colspan="7" bgcolor="DADADA"></td></tr>
   <tr #stylescroll#>
   	  <td height="17" width="20">#currentrow#.</td>
      <td width="60">#ItemNo#</td>
	  <td width="80%">#ItemDescription#</td>	 
	   
	  <td><A href="javascript:ColdFusion.navigate('#SESSION.root#/Tools/Topic/Item/ItemClass.cfm?action=delete&Topic=#URL.Topic#&ItemNo=#ItemNo#','l#url.Topic#_item')">
		   <img src="#SESSION.root#/images/delete5.gif" height="11" width="11" alt="delete" border="0" align="absmiddle">
		  </a>
	  </td>
   </tr>          
   </CFOUTPUT> 
   
   </table>
      