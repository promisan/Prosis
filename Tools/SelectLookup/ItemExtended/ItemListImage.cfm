
<!--- item picture --->

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">     
    SELECT *
	FROM Item
	WHERE ItemNo = '#url.id#'
</cfquery>
	
<cfoutput>

  <img src="#SESSION.rootDocument#/#url.image#"
	  alt="#get.ItemDescription# [#get.itemno#]"
	  style="max-width: 200px;"
      border="0"                                       
      align="absmiddle">	
	  
</cfoutput>	  
	

	  