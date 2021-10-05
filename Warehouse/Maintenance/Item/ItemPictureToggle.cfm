<cfparam name="URL.Id" default="">
<cfparam name="URL.ItemNo" default="">

<cfif URL.id eq "">

	<cfset URL.Id = URL.ItemNo> 
	
	<cfquery name="Item" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT *
				FROM   Item
				WHERE  ItemNo      = '#URL.ItemNo#'
	</cfquery>	
	
</cfif>	

<cfoutput>

<cfquery name="Image" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   ItemImage
		WHERE  ItemNo      = '#URL.Id#'
</cfquery>		

<cfif Image.recordcount neq 0>		
       <tr>
       <div style="height:92px;margin-left: 5px;border-bottom: 1px solid ##efefef;">
           <div style="float: left;">
              <a href="#session.rootDocument#/#Image.ImagePath#"
	             class='lightview'
               	 data-lightview-group='Items'
	             data-lightview-title="#Image.ItemNo#<br>(#Item.ItemNoExternal#)"
	             data-lightview-caption="#Item.ItemDescription#<br>#Item.Mission#"
                 data-lightview-options="skin: 'mac'">
               <img style="max-width: 120px;height:auto;border: 1px solid ##efefef;" src="#session.rootDocument#/#Image.ImagePath#" width="800" height="600">
            </a>
            </div>		
       </div>
       </tr>
</cfif>

</cfoutput>        