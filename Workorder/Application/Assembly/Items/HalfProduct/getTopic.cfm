<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.find" default="">

<cfquery name="getItemUoM" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ItemUoM
	WHERE   ItemNo = '#url.ItemNo#'		
</cfquery>

<!---- 12-19-2013 removed by dev
	<cfoutput>#url.itemno#</cfoutput>
--->


<cfquery name="getTopic" 
      datasource="AppsMaterials"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Topic 
		  WHERE    Code = '#Code#'							  
</cfquery>
	
<cfif getTopic.valueClass eq "List">

	    <cfquery name="GetList" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT   T.*
			  FROM     Ref_TopicList T
			  WHERE    T.Code = '#Code#'		
			  AND      T.Operational = 1		
			  <cfif url.find neq "">
			  AND      T.ListValue LIKE '%#url.find#%'
			  </cfif>
			  			  			 
			  <cfif url.ip eq "UoM" and getItemUoM.recordcount gte "1">
			  AND    ListCode IN (#quotedValueList(getItemUoM.UoMCode)#)			  
			  
			  </cfif>
			  ORDER BY ListOrder
		</cfquery>
				
		<cfif getList.recordcount eq "0" and url.find eq "">
				
			  <cfquery name="GetList" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT   T.*
				  FROM     Ref_TopicList T
				  WHERE    T.Code = '#Code#'		
				  AND      T.Operational = 1		
				  <cfif url.find neq "">
				  AND      T.ListValue LIKE '%#url.find#%'
				  </cfif>				  
				  ORDER BY ListOrder
			</cfquery>
		
		</cfif>
		
<cfelseif getTopic.valueClass eq "Lookup">
		
		 <cfquery name="GetList" 
		  datasource="#getTopic.ListDataSource#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		
			 SELECT    DISTINCT 
			           #getTopic.ListPK# as ListCode, 
			           #getTopic.ListDisplay# as ListValue,
					   #getTopic.ListingOrder# as ListOrder
			  FROM     #getTopic.ListTable# 
			  WHERE    #PreserveSingleQuotes(getTopic.ListCondition)# 
			  <cfif url.find neq "">
			  AND      #getTopic.ListDisplay# LIKE '%#url.find#%'
			  </cfif>			  		  
			  <cfif url.ip eq "UoM" and getItemUoM.recordcount gte "1">			  
			  AND      #getTopic.ListPK# IN (#quotedValueList(getItemUoM.UoMCode)#)			  			  
			  </cfif>
			  
			  ORDER BY #getTopic.ListingOrder#
		
		</cfquery>		
		
		<cfif getList.recordcount eq "0" and url.find eq "">
				
			<cfquery name="GetList" 
			  datasource="#getTopic.ListDataSource#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			
				 SELECT    DISTINCT 
				           #getTopic.ListPK# as ListCode, 
				           #getTopic.ListDisplay# as ListValue,
						   #getTopic.ListingOrder# as ListOrder
				  FROM     #getTopic.ListTable# 
				  WHERE    #PreserveSingleQuotes(getTopic.ListCondition)#
				  <cfif url.find neq "">
				  AND      #getTopic.ListDisplay# LIKE '%#url.find#%'
				  </cfif>			 
				  ORDER BY #getTopic.ListingOrder#
			
			</cfquery>		
				
		</cfif>										
			
</cfif>
	
<cfoutput>

<cfset lastSelected = "">

	<!--- Prosis.busy('yes'); --->
					
	<select class = "regularxl" 
			onchange  = "ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/HalfProduct/HalfProductRecordItem.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&itemno=#url.itemno#&uom=#url.UoM#','finalproduct','','','POST','selectionform')"
			style     = "border:0px;height:200px;width:160px"
			multiple 
			name      = "Topic_#Code#" 
			ID        = "Topic_#Code#">
							
			<cfloop query="GetList">	
																		
				<option value="'#GetList.ListCode#'" <cfif  GetList.ListCode eq lastSelected>selected</cfif>>#GetList.ListValue# </option>					
							
			</cfloop>
		
	</select>	
	
</cfoutput>	
