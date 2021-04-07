
<cfparam name="gridcontent" default="row">


<cfswitch expression="#gridcontent#">

	<cfcase value="row">
		
		<cfset val = ltrim(rtrim(evaluate(url.listgroupfield)))>
		<cfset val = Replace( val, "'", "''", "ALL" )>	
		
		<!--- ------------------------------------------------------------ --->
		<!--- -------------------  get group row label ------------------- --->
		<!--- ------------------------------------------------------------ --->
		    			   					   
		<cfif evaluate(url.listgroupfield) neq "">							 
		   <cfset groupfield = url.listgroupfield>								 
		<cfelse>							   
		   <cfset groupfield = url.listgroup>																 
		</cfif>		
		
		<cfparam name="groupname" default="">
		   
		<cfloop array="#attributes.listlayout#" index="itm">		
		
			<cfparam name="itm.formatted" default="">
		
			<cfif itm.field eq groupfield or itm.formatted eq groupfield>		
												
				<cfif itm.formatted neq "" and itm.formatted neq "Rating">
					<cfset groupname = evaluate(itm.formatted)>
				<cfelse>
					<cfset groupname = evaluate(groupfield)>
				</cfif>																	
				
				<cfif groupname eq "">
					<cfset groupname = "Undefined">		
				</cfif>
					
			</cfif>
		  	
		</cfloop>	
		
		<cftry>
		
			<cfquery name="subtotal" dbtype="query">
				 SELECT  sum(total) as Records
				 FROM    SearchGroup
				 WHERE   #url.listgroupfield# = '#val#'									 					 
			</cfquery>	
		
		    <cfcatch>
			
				<cfset subtotal["records"] = "0">
						
						 
			 </cfcatch>
		
		</cftry>
		
	</cfcase>	
	
	<cfcase value="total">

		<cfquery name="subtotal" dbtype="query">
			 SELECT  sum(total) as Records
			 FROM    SearchGroup		 							 					 
		</cfquery>	
	
		<cfset groupname = "Overall total">
	
	</cfcase>

</cfswitch>
   
<!--- -------------------------------------------------------------- --->
<!--- ------------------GET cell record total ---------------------- --->
<!--- -------------------------------------------------------------- --->
	  	 	  
<cfoutput>
	    
	<!--- standard count metric : count which we only run if not yet for aggegrate --->      	
	<cfset counted = subtotal.records>	 
	
	<cfif url.ajaxid neq "append">  
	  
	        <!--- grouping record with class to be used for adding records on the fly --->
		 
		  <cfset rowdata = "#box#_group1_#currrow#">
		
		  <cfif navmode neq "manual">											
		     <tr class="fixrow240 navigation_row labelmedium2 line">			 	  
		  <cfelse>		  		
		     <tr class="navigation_row labelmedium2 line">				 
		  </cfif>		
			   			   
			   <cfif navmode eq "manual" and counted lte 1000 and gridcontent eq "row">		   
		           <td style="height:20px;" colspan="#headercols#" onclick="listgroupshow('#GroupKeyValue#','#rowdata#')">					  		   
			   <cfelse>
			       <td style="height:20px" colspan="#headercols#">				  
			   </cfif>		
			   
			        <!--- to keep this from moving --->
				    <div style="height:28px;position:relative;">
		              <div style="height:100%;width:100%;position:absolute;left:0;top:0;" class="sticky">
					  				  			   		 		   			   
					   <table style="height:100%;background-color:##ffffffCC;">
					   <tr class="labelmedium2">
						   <td align="center" style="min-width:30px;padding-left:4px;padding-right:4px">	
						   
						   <cfif gridcontent eq "row"> <!--- not shown for total row --->
						   				   
							   <cfif navmode eq "manual" and counted lte 1000>	
								    <img src="#client.virtualdir#/Images/Logos/System/ListCollapsed.png" id="#rowdata#_exp" class="regular" style="height:20px">															
								    <img src="#client.virtualdir#/Images/Logos/System/ListExpanded.png"  id="#rowdata#_col" class="hide"    style="height:20px"> 	
							   <cfelse>
								    <img id="#rowdata#_exp" class="regular" style="height:20px">															
								    <img id="#rowdata#_col" class="hide"    style="height:20px">			   
							   </cfif>							     
						   
						   </cfif>
						   
						   </td>
						   
						   <td style="min-width:314px;font-size:16px;padding-left:5px;<cfif navmode neq 'manual'>font-weight:bold</cfif>"><cfif len(groupname) gte "32">#left(groupname,32)#..<cfelse>#groupname#</cfif>&nbsp;<font size="2">[#subtotal.records#]</font></td>
					   </tr>
					   </table>
					  			   
					   </div>       
			        </div> 	
			   			   
			   </td>	
			  
		       <cfif url.listcolumn1 neq "" and url.listcolumn1 neq "summary" and navmode eq "manual">
					
				   <!--- we show columns --->	
				   					   			     		   
			   	   <td colspan="#cols-headercols#" style="border-right: 1px solid silver">							    				   		   
				    <cfset attributes.mode = "Line">																														 
				    <cfinclude template="ListingContentHTMLGroupShowColumn.cfm">										
				   </td>
			   
			   <cfelse>
			   
			   	  <!--- we show cells that are set to aggregate --->		
				  	   
			   	  <cfinclude template="ListingContentHTMLGroupShowAggregate.cfm">  
				     			   
				  <cfloop index="itm" from="#headercols-pre+1#" to="#cols-pre#">
					   <cfparam name="grp[#itm#]" default="">			   
					   <cfif grp[itm] eq "">
					       <td colspan="1"></td>	
					   <cfelse>
						   <td align="right" style="border-left:1px solid silver;font-size:14px;padding:1px">
						   <table style="height:99%;width:100%">
						     <tr><td align="right" 
								  style="padding-left:10px;width:90%;background-color:##ffffaf80;font-size:16px;padding-right:3px;border:1px solid silver">	
								  #grp[itm]#
								  <!--- 							  
								  <cftry>
								  #numberformat(grp[itm],',.__')#
								  <cfcatch>
								  #grp[itm]#
								  </cfcatch>
								  </cftry>--->
								  </td></tr>
						   </table>					   
						   </td>	
					   </cfif>
				   </cfloop>	
			   
			   </cfif>
				   				   				   
			  </tr>				 			 		  
			  <!--- data is ajax added prior to this record one by one --->
			  <tr class="#rowdata#"><td colspan="#cols#"></tr>	
			  <cfif content eq "line">		  								
			  	<cfset lst = evaluate(url.listgroupfield)>	 
			  </cfif>
			  
	<cfelse>
	   
	   <!--- ajax  --->	 			   	   
	   <cfinclude template="ListingContentHTMLGroupShowAggregate.cfm">		
					  
	</cfif>		
   
</cfoutput>  



