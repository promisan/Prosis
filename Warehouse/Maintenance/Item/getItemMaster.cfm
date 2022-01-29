<cfparam name="URL.CategoryItem" default="">
<cfparam name="URL.CategoryItemOld" default="">

<cfif trim(url.itemmaster) eq "">

	<cfif URL.CategoryItem neq "">	
	
		<cfquery name="qCategoryItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Item I
		WHERE  CategoryItem = '#URL.CategoryItem#' 	
		AND    Mission      = '#URL.Mission#'	  
		AND    EXISTS ( SELECT  'X'
	         		    FROM    Purchase.dbo.ItemMaster M
			            WHERE   M.Code     = I.ItemMaster
			            AND     M.Mission  = I.Mission
		)	    
		</cfquery>
		
		<cfset url.itemMaster = qCategoryItem.ItemMaster>
				
	<cfelseif URL.CategoryItemOld neq "">
	
		<cfquery name="qCategoryItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Item I
		WHERE  CategoryItem = '#URL.CategoryItemOld#' 	
		AND    Mission      = '#URL.Mission#'	   
		AND   EXISTS (
			          SELECT  'X'
			          FROM    Purchase.dbo.ItemMaster M
			          WHERE   M.Code = I.ItemMaster
			          AND     M.Mission  = I.Mission
		)
		</cfquery>
		
		<cfset url.itemMaster = qCategoryItem.ItemMaster>
		
	</cfif>
	
</cfif>

<cfif url.itemmaster eq "">
	
	<cfquery name="Master" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   ItemMasterMission
	   WHERE  Mission = '#URL.Mission#'	   
	</cfquery>

	<!--- <cfset url.itemmaster = Master.ItemMaster> --->

</cfif>

<cfquery name="Master" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT * 
   FROM   ItemMaster
   WHERE  Code    = '#URL.ItemMaster#' 	
   -- AND    Mission = '#URL.Mission#'	   
</cfquery>

<cfoutput>

<table>
	
  <tr>	  
  <td>	  
				  
	  <input type="Text"
	       name="itemmaster"
		   id="itemmaster"
	       value="#Master.Code#"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       message="Select an Item Master"    
	       size="5"
	       maxlength="6"
	       class="regularxl" readonly>
	   
	</td>	
	<td id="process"></td>	
	<td style="padding-left:2px">   
	  
  		<input type="text" name="itemmasterdescription" id="itemmasterdescription" value="#Master.Description#" size="60" class="regularxl" maxlength="80" readonly> 	
  		<input type="hidden" name="objectcode" id="objectcode" value="">
	
	</td>
	
	<td style="padding-left:3px">
		<img src="#SESSION.root#/Images/search.png" 
	      alt="Select item master" 
		  name="img3" 
		  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
		  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
		  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
		  onClick="selectmas('itemmaster',getElementById('mission').value,'','')">	  
    </td>	
	</tr>
</table>

</cfoutput>