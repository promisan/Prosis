
<!--- only show if category is selected as it is driven by the category --->

<table style="width:100%" style="font-size:15px">
    
		<tr class="labelmedium2"><td><cf_tl id="Brand"></td></tr>
		
		<cfquery name="Make" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_Make		
		   WHERE     Code IN (SELECT Make FROM Item WHERE Category = '#url.category#')    
		</cfquery>
		
		<tr class="labelmedium2"><td colspan="2" style="padding:6px;font-size:15px">
		
		  <cf_UISelect name   = "filterMake"
		     class          = "regularxxl"
		     queryposition  = "below"
		     query          = "#Make#"
		     value          = "Code"
		     onchange       = "search()"		     
		     required       = "No"
		     display        = "Description"
			 filter         = "contains"
		     selected       = ""
			 separator      = "|"
		     multiple       = "yes"/>		
											 
				
	</td></tr>
	
	<tr class="labelmedium2"><td><cf_tl id="Subcategory"></td></tr>
	
	<tr><td colspan="2" style="padding:6px">
			
		<cfquery name="SubCat" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 
			 SELECT      CategoryItem, CategoryItemName
			 FROM        Ref_CategoryItem
			 WHERE       Category = '#url.category#'
			 ORDER BY    CategoryItemOrder
	    
	   </cfquery>

	   <cf_UISelect name   = "filterSubCat"
		     class          = "regularxxl"
		     queryposition  = "below"
		     query          = "#SubCat#"
		     value          = "CategoryItem"
		     onchange       = "search()"		     
		     required       = "No"
		     display        = "CategoryItemName"
		     selected       = ""
			 filter         = "contains"
			 separator      = "|"
		     multiple       = "yes"/>						
				
	</td></tr> 
	
	<cfquery name="Topics" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 	 SELECT     *
         FROM       Ref_Topic
         WHERE      Code IN
                      (SELECT    Code
                       FROM      Ref_TopicCategory
                       WHERE     Category = '#url.category#')
		AND        Operational = 1
		AND        TopicClass = 'Category'	
		AND        ValueClass IN ('List','Text','Lookup')		   
	</cfquery>				   
	
	<cfoutput query="topics">
	
	<tr class="labelmedium2"><td>#TopicLabel#</td></tr>
			
	<cfif ValueClass eq "List">
				
		<cfquery name="GetList" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT	T.*
				FROM 	Ref_TopicList T
				WHERE 	T.Code = '#Code#'  
				AND 	T.Operational = 1
				ORDER BY T.ListOrder ASC
		</cfquery>
		
		<cfif getList.recordcount lte "6">
				
		  <cfloop query="getList">
		  <tr class="labelmedium">
		  
		      <td style="padding-left:6px;font-size:13px">#ListValue#</td>
			  <td>
			  
			  <input type="checkbox" 
			    style="height:17px;width:16px" 
				name="filter#code#" onclick="search()"	value="#ListCode#">
				
			  </td>
			  
		  </tr>
		  </cfloop>	
		
		<cfelse>
		
		<tr><td colspan="2" style="padding:2px">
						
		 <cf_UISelect name   = "filter#code#"
		     class          = "regularxxl"
		     queryposition  = "below"
			 style          = "width:100%"
		     query          = "#GetList#"
		     value          = "ListCode"
		     onchange       = "search()"		     
		     required       = "No"
		     display        = "ListValue"
		     selected       = ""
			 separator      = "|"
		     multiple       = "yes"/>		
			 
		  </cfif>	 
		  
		  </td>
		  </tr>
															
		<cfelseif ValueClass eq "Lookup">
		
		    <!--- 
				
			<cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
			
					 SELECT     DISTINCT 
					            #ListPK# as ListCode, 
					            #ListDisplay# as ListValue,
							    #ListOrder# as ListOrder,
							    P.Value as Selected
					  FROM      #ListTable# 
					  WHERE     #PreserveSingleQuotes(ListCondition)#
					  ORDER BY  #ListOrder#
			
			</cfquery>
						
			 <cf_UISelect name   = "filter#code#"
			     class          = "regularxxl"
			     queryposition  = "below"
			     query          = "#GetList#"
			     value          = "ListCode"
			     onchange       = "search()"		     
			     required       = "No"
			     display        = "ListValue"
			     selected       = ""
				 separator      = "|"
			     multiple       = "yes"/>	
				 
				 --->
				 
	 </cfif>			 
				
	</cfoutput>	
		
</table>

