
<cfparam name="attributes.mode"          default="header">

<!-- identify the column fields --->

<cfset cnt = 0>
<cfloop index="itm" list="#session.listingdata[box]['colnfield']#">
     <cfset cnt = cnt+1>
	 <cfparam name="pivotcol#cnt#" default="#itm#">	 	 
</cfloop>

<!--- we obtain data from the grouped data, later we have to add the formula in case we have more than one column level potentiall  --->

<cftry>
				
     <cfquery name="subtotal" dbtype="query">
		 SELECT * FROM  SearchGroup WHERE  #url.listgroupfield# = '#val#'			 
	  </cfquery>			  
	  
	  <cfif subtotal.recordcount eq "0"> 						  
	  			  								  
		  <cfquery name="subtotal" dbtype="query">
			 SELECT * FROM   SearchGroup WHERE  #url.listgroupfield# LIKE '#val#%'			 
		  </cfquery>			  
	  
	   </cfif>
	  
	  <!--- query-of-query does not mix integer and strings --->	
			  
	  <cfcatch>		
	  
	  	<cfif val eq "">
			 <cfset val = 0>
		</cfif>
	    	
		<cfquery name="subtotal" dbtype="query">
		    SELECT  * FROM SearchGroup WHERE #url.listgroupfield# = #val#									 					 
		</cfquery>	
														  
	  </cfcatch>
	    
</cftry>		
  
<cfoutput>

<cfset myVal = ArrayNew(2)>
<cfset ArrayClear(myVal)>

<!--- we pass the result into an array --->

<cfloop query="subtotal">

	<cfset myval[currentrow][1] = evaluate("#pivotcol1#")>	
	<cfset cnt = 1>
	<!-- these are the summary fields as we have them in aggregate : dynamic --->
	<cfloop index="itm" list="#session.listingdata[box]['aggrfield']#">	
	     <cfset cnt = cnt+1>		 
         <cfset myval[currentrow][cnt] = evaluate("#itm#")>
	</cfloop>
			
</cfloop>

<!--- LATER we do this on the fly with different colums --->
<cfset columntype = "month">

<cfif columntype eq "month">

	<cfloop index="itm" list="#colnfield#"> 
	
		<cfquery name="getRange" dbtype="query">
			 SELECT   MIN(#pivotcol1#) as ColStart,
			          MAX(#pivotcol1#) as ColEnd			  
			 FROM     SearchGroup <!--- this is the base content which we generated or kept in memory --->										
		</cfquery>
	
	</cfloop>
		
	<cfset yr = left(getRange.ColStart,4)>
	<cfif len(getRange.colStart) eq "6">
		<cfset mt = mid(getRange.ColStart,6,1)>
	<cfelse>
		<cfset mt = mid(getRange.ColStart,6,2)>
	</cfif>
	<cfset str = createDate(yr, mt,"1")>
	
	<cfset yr = left(getRange.ColEnd,4)>
	<cfif len(getRange.colStart) eq "6">
		<cfset mt = mid(getRange.ColEnd,6,1)>
	<cfelse>
		<cfset mt = mid(getRange.ColEnd,6,2)>
	</cfif>
	<cfset end = createDate(yr, mt,"1")>
	
	<!--- define range --->	
	<cfset ystr  = year(STR)>
	<cfset mstr  = month(STR)>
	<cfset yend  = year(END)>
	<cfset mend  = month(END)>

	<table style="height:100%">
	
		<cfif attributes.mode eq "header">
	    
			<tr class="labelmedium line xhide" style="height:15px;border-top:1px solid silver">
					
				<cfloop index="yr" from="#ystr#" to="#yend#">
			
					<cfif yr eq ystr>
						<cfset st = mstr>
						<cfset ed = 12>		
					<cfelseif yr gt ystr and yr lt yend>
						<cfset st = 1>
						<cfset ed = 12>			    
					<cfelse>
						<cfset st = 1>
						<cfset ed = mend>				
					</cfif>
					<cfset yearcol[yr][1] = st>
					<cfset yearcol[yr][2] = ed>
					<cfset colspan = ed-st+1>	
								
					<td align="center" style="border-left:1px solid silver;" colspan="#colspan#">#yr#</td>
					
				</cfloop>
				
				<td align="center" style="border-left:1px solid silver;" colspan="1"><cf_tl id="Total"></td>
			
			</tr>
			
			<tr class="labelmedium">
			
				<cfloop index="yr" from="#ystr#" to="#yend#">
				
					<cfset st = yearcol[yr][1]>
					<cfset ed = yearcol[yr][2]>
						
					<cfloop index="mth" from="#st#" to="#ed#">	
					
						<cfif mth gte "10">
						    <cfset month = mth>
						 <cfelse>
						 	<cfset month = "0#mth#">
						 </cfif>				 				 
															
					     <td style="text-align:center;min-width:65px;border-left:1px solid silver;padding-right:4px">#left(monthasstring(mth),3)#</td>						
						 
					</cfloop>
				
				</cfloop>
				
				<td style="text-align:center;min-width:75px;border-left:1px solid silver;padding-right:4px"></td>	
			
			</tr>
			
		<cfelse>	
		
			<!--- data column --->
								
			<cfloop index="yr" from="#ystr#" to="#yend#">
		
				<cfif yr eq ystr>
					<cfset st = mstr>
					<cfset ed = 12>		
				<cfelseif yr gt ystr and yr lt yend>
					<cfset st = 1>
					<cfset ed = 12>			    
				<cfelse>
					<cfset st = 1>
					<cfset ed = mend>				
				</cfif>
				<cfset yearcol[yr][1] = st>
				<cfset yearcol[yr][2] = ed>
				<cfset colspan = ed-st+1>				
								
			</cfloop>
					
			<tr class="labelmedium2">
			
				<cfset tot = 0>
			
				<cfloop index="yr" from="#ystr#" to="#yend#">
				
					<cfset st = yearcol[yr][1]>
					<cfset ed = yearcol[yr][2]>
						
					<cfloop index="mth" from="#st#" to="#ed#">	
					
						<cfif mth gte "10">
						    <cfset month = mth>
						 <cfelse>
						 	<cfset month = "0#mth#">
						 </cfif>		
						 
						 <cfset filter = "#yr#-#month#">		 				 
										 			
						<cfscript>
							subSet=myval.filter(function(item){ return item[1]=="#yr#-#month#"; });
						</cfscript>
					
						<cfif ArrayLen(subSet) neq 0>				
						     <!---IMPORTANT this takes the second field which we want to make dynamic --->	
							 <cfif cnt gte "3">					
							 <cfset val = NumberFormat(subSet[1][3],',')> 
							 <cfelse>
							 <cfset val = NumberFormat(subSet[1][2],',')>
							 </cfif>
							 <td style="text-align:right;min-width:65px;border-left:1px solid silver;padding-right:4px"
							 onclick="listgroupshow('#GroupKeyValue#','#rowdata#','#pivotcol1#','#filter#')">#NumberFormat(val,',')#</td>
							 <cfset tot = tot + val>
						<cfelse>
						     <td style="background-color:##eaeaea80;min-width:65px;border-left:1px solid silver;padding-right:4px"></td>
						</cfif>	 
						 
					</cfloop>
				
				</cfloop>
				
				<td style="text-align:right;min-width:75px;border-left:1px solid silver;padding-right:4px;font-weight:bold" onclick="listgroupshow('#GroupKeyValue#','#rowdata#')">							 					
					 #NumberFormat(tot,',')#
     			 </td>
			
			</tr>
		
		</cfif>
	
	</table>
	
</cfif>	

</cfoutput>
