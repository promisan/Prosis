
				
<cfswitch expression="#Level#">
	
	<cfcase value="1">
	
		  <cfquery name="Master" 
			   datasource="appsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				SELECT C.Category, 
				       C.Description, 
					   COUNT(*) as counted
				FROM   Ref_Category C 
					INNER JOIN Userquery.dbo.#SESSION.acc##Mission#AssetTree AI ON AI.AssetClass = C.Category 						
				WHERE  AI.Mission = '#Mission#'		
				AND    AI.Operational = '1'
				AND    C.Category IN (SELECT Category 
			                          FROM   Item
						              WHERE  ItemClass = 'Asset')
							
				<!--- has been used --->		   
				AND    C.Category IN (SELECT  I.Category 
				                      FROM    AssetItem A, Item I 
								      WHERE   A.ItemNo = I.ItemNo 
								      AND     A.Mission = '#Mission#')	
								   

			  	AND  AI.AssetId IN (SELECT AssetId FROM Userquery.dbo.#SESSION.acc##Mission#AssetTree)				

				GROUP BY C.Category, C.Description
		  </cfquery>			
		  
		  <cfset exist  = FALSE>
		  
		  <cfloop query="Master">	
			    <cfset exist  = TRUE>
				<cfset mas = #Category#>
	        	<cfset s = StructNew()> 
		        <cfset s.value = "#mas#"> 
		        <cfset s.display = "<span class='labelit'>#Description#<font color='53A9FF'>(#counted#)</span>"> 
				<cfset s.parent  = "Class">
				<cfset s.href    = "javascript:listshow('CLS','#Mas#','#mission#')">

				<cfset arrayAppend(result,s)/>				

			</cfloop>				
			<cfif NOT exist>
	        	<cfset s = StructNew()> 
		        <cfset s.value = "Class_Not_Found"> 
		        <cfset s.display = "<i>Empty</i>"> 
				<cfset s.parent  = "Class">
				<cfset s.leafnode=true/>
				<cfset arrayAppend(result,s)/>				
			</cfif>
				  
	</cfcase>

	<cfcase value="2">

		<cfquery name="Item" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   R.CategoryItem, R.CategoryItemOrder, CategoryItemId, count(*) as Counted
					FROM     Item I, 
					         AssetItem A, 
						     Ref_CategoryItem R
					WHERE    I.ItemNo = A.ItemNo
				    AND      A.Mission = '#mission#'
					AND      I.Category = '#vmid#' 
					AND      I.ItemClass = 'Asset'	
					AND      I.Category = R.Category		
					AND      A.Operational = 1				
					AND      I.CategoryItem = R.CategoryItem
					AND      A.AssetId IN (SELECT AssetId FROM Userquery.dbo.#SESSION.acc##Mission#AssetTree)
					GROUP BY R.CategoryItemOrder, R.CategoryItem, CategoryItemId
					ORDER BY R.CategoryItemOrder, R.CategoryItem
					
		</cfquery>					
	
		<cfloop query="Item">	   
	        	<cfset s = StructNew()> 
		        <cfset s.value   = "#CategoryItemId#"> 
		        <cfset s.display = "<span class='labelit'>#CategoryItem#<font color='53A9FF'>(#counted#)</span>"> 
				<cfset s.parent  = "#vmid#">
				<cfset s.href    = "javascript:listshow('ITM','#CategoryItemId#','#mission#')">

				<cfset arrayAppend(result,s)/>		
		</cfloop>	
		
	</cfcase>
	
	<cfcase value="3">
	
				<cfquery name="MakeList" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT Make, count(*) as Counted
						FROM   AssetItem
						WHERE  Mission = '#mission#'
						AND    ItemNo IN 
							     (SELECT ItemNo 
								  FROM   Materials.dbo.Item I, Materials.dbo.Ref_CategoryItem R 
								  WHERE  I.Category = R.Category 
								  AND    I.CategoryItem = R.CategoryItem 
								  AND    CategoryItemId = '#vmid#')								  
						AND  AssetId IN (SELECT AssetId FROM Userquery.dbo.#SESSION.acc##Mission#AssetTree)		  
						GROUP BY Make	

				</cfquery>
				
				<cfloop query="MakeList"> 
		        	<cfset s = StructNew()> 
			        <cfset s.value   = "#Make#_#currentrow#"> 
			        <cfset s.display="<span class='labelit'>#make#<font color='53A9FF'>(#counted#)</span>">
					<cfset s.parent  = "#vmid#">
					<cfset s.Expand  = "No">
					<cfset s.href    = "javascript:listshow('IMK','#vmid#','#mission#','#make#')">
					<cfset s.leafnode=true/>
					<cfset arrayAppend(result,s)/>		  
				 </cfloop>			
	</cfcase>
	
</cfswitch>

