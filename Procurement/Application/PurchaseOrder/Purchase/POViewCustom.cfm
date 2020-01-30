
<!--- define custom topics --->


 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo = '#URL.Id1#'		
</cfquery>	

  <cfquery name="GetTopics" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Code 
                  FROM   Ref_TopicOrderType 
				  WHERE  OrderType = '#url.type#'
				 )
  AND    (Mission = '#PO.Mission#' or Mission is NULL)				 
  AND    Operational = 1 
</cfquery>

<table cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput query="GetTopics">

<tr>    
	   <td class="labelmedium" style="width:170;padding-right:10px">#Description#: <cfif ValueObligatory eq "1"><font color="FF0000">*)</font></cfif><cf_space spaces="50"></td>
	   <td width="50%" style="height:20px" class="labelmedium">
	    			   
	   <cfif URL.Mode neq "edit" and url.mode neq "add">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM Ref_TopicList T, PurchaseTopic P
					  WHERE T.Code = '#GetTopics.Code#'
					  AND P.Topic = T.Code
					  AND P.ListCode = T.ListCode
					  AND P.PurchaseNo = '#URL.ID1#'		  
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   N/A
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   PurchaseTopic P
					  WHERE  P.Topic = '#GetTopics.Code#'						 
					   AND   P.PurchaseNo = '#URL.ID1#'			  
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1">Yes<cfelse>No</cfif>
					   
				   <cfelseif ValueClass eq "Date">
				   
				        <cftry>
				   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#			
						<cfcatch></cfcatch>	   	   
						</cftry>
				   
				   <cfelse>
				   
				   		#GetList.TopicValue#
						
				   </cfif>
			   						   
				<cfelse>
				
				   N/A
				   
				</cfif>  					
			
			</cfif>			    
		
	   <cfelse>
	   
	   		<cfquery name="GetValue" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   PurchaseTopic
				  WHERE  Topic = '#GetTopics.Code#'		
				  AND    PurchaseNo = '#URL.ID1#'					 
			</cfquery>		
	
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM   Ref_TopicList T LEFT OUTER JOIN PurchaseTopic P ON P.Topic = T.Code AND P.PurchaseNo = '#URL.ID1#'
					  WHERE  T.Code = '#GetTopics.Code#'		
					  AND    T.Operational = 1		
				</cfquery>				
				
				 <cfquery name="Def" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_TopicList
					  WHERE  Code = '#GetTopics.Code#'		
					  AND    ListDefault = 1		
				</cfquery>		
				
				
				<cfif getValue.ListCode neq "">
					<cfset def = getValue.ListCode>
				<cfelse>				    
					<cfset def = getValue.ListCode>				
				</cfif>				
			   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="regularxl enterastab" style="width:200px">
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#GetList.ListCode#" <cfif def eq ListCode>selected</cfif>>#GetList.ListValue#</option>
					</cfloop>
				</select>				
				
			<cfelseif ValueClass eq "Lookup">
						
			   <cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				 	  SELECT   DISTINCT 
					           #ListPK# as PK, 
					           #ListDisplay# as Display,
							   0 as DEF
					  FROM     #ListTable#
					  <cfif listorder neq "">
					  ORDER BY #ListOrder#
					  </cfif>
				</cfquery>
								   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="regularxl enterastab" style="width:200px">
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#PK#" <cfif GetList.Display eq GetValue.TopicValue>selected</cfif>>#PK# #Display#</option>
					</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
						
				<input type="Text"
			       name="Topic_#GetTopics.Code#"
                   id="Topic_#GetTopics.Code#"
			       required="#ValueObligatory#"					     
			       size="#valueLength#"
				   class="regularxl enterastab"
				   message="Please Enter a #GetTopics.Description#"
				   value="#GetValue.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">
					
				   <cf_intelliCalendarDate9
						FieldName="Topic_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						class="regularxl enterastab"
						AllowBlank="#ValueObligatory#">	
								
			<cfelseif ValueClass eq "Boolean">
					
				<input type="Checkbox"
			       name="Topic_#GetTopics.Code#" 
                   id="Topic_#GetTopics.Code#"
				   class="radiol"
				   <cfif GetValue.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>			   
	    
  </cfoutput>	
  </table>