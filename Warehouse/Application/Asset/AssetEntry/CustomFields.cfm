
<cfparam name="url.assetid" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="GetTopics" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Topic
                  FROM   ItemTopic 
				  WHERE  ItemNo = '#ItemNo#')
  AND    Operational = 1
</cfquery>

<cfoutput query="GetTopics">

<tr>    
	   <td class="labelmedium" style="padding-left:0px">#Description# :<cfif ValueObligatory eq "1"><font color="FF0000">*</font></cfif></td>
	   <td height="20">
	    			   
	   <cfif URL.Mode neq "edit" and url.mode neq "add">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT T.*, P.ListCode as Selected
				  FROM Ref_TopicList T, AssetItemTopic P
				  WHERE T.Code = '#GetTopics.Code#'
				  AND P.Topic = T.Code
				  AND P.ListCode = T.ListCode
				  AND P.AssetId = '#URL.AssetId#'				  
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   N/A
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   AssetItemTopic P
				  WHERE P.Topic = '#GetTopics.Code#'						 
				  AND   P.AssetId = '#URL.Assetid#'				  
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1">Yes<cfelse>No</cfif>
					   
				   <cfelseif ValueClass eq "Date">
				   
				   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#				   	   
				   
				   <cfelse>
				   
				   		#GetList.TopicValue#
						
				   </cfif>
			   						   
				<cfelse>
				
				   N/A
				   
				</cfif>  					
			
			</cfif>			    
		
	   <cfelse>
	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM Ref_TopicList T LEFT OUTER JOIN AssetItemTopic P ON P.Topic = T.Code AND P.AssetId = '#URL.AssetId#'
					  WHERE T.Code = '#GetTopics.Code#'		
					  AND T.Operational = 1		
				</cfquery>
			   					   
			    <select class="regularxl enterastab" name="Topic_#Ass#_#GetTopics.Code#" ID="Topic_#Ass#_#GetTopics.Code#" class="enterastab">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
				</cfloop>
				</select>				
				
			<cfelseif ValueClass eq "Lookup">
			
				 <cfquery name="Current" 
				  datasource="appsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  AssetItemTopic
					  WHERE Topic = '#GetTopics.Code#'		
					  AND   AssetId = '#URL.AssetId#'					 
				</cfquery>			
			
			   <cfquery name="GetList" 
				  datasource="#ListDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				 	  SELECT   DISTINCT 
					           #ListPK# as PK, 
					           #ListDisplay# as Display,
							   0 as DEF
					  FROM     #ListTable#
					  ORDER BY #ListDisplay#
				</cfquery>
			   					   
			    <select class="regularxl enterastab" name="Topic_#Ass#_#GetTopics.Code#" id="Topic_#Ass#_#GetTopics.Code#" class="enterastab">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#PK#" <cfif GetList.Display eq Current.TopicValue>selected</cfif>>#Display#</option>
				</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
			
				 <cfquery name="GetValue"  
				  datasource="appsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  AssetItemTopic
					  WHERE Topic = '#GetTopics.Code#'		
					  AND   AssetId = '#URL.AssetId#'					 
				</cfquery>		
							
				<cfinput type="Text"
			       name="Topic_#Ass#_#GetTopics.Code#"
			       required="#ValueObligatory#"					     
			       size="#valueLength#"
				   class="regularxl enterastab"
				   message="Please enter a #GetTopics.Description#"
				   value="#GetValue.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">
			
				 <cfquery name="GetValue" 
				  datasource="appsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  AssetItemTopic
					  WHERE Topic = '#GetTopics.Code#'		
					  AND   AssetId = '#URL.AssetId#'					 
				</cfquery>			
				
				   <cfif ValueObligatory eq "1">
			
				   <cf_intelliCalendarDate9
						FieldName="Topic_#Ass#_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						Message="Please enter a valid date"
						class="regularxl enterastab"
						AllowBlank="false">	
						
				   <cfelse>
				   
				    <cf_intelliCalendarDate9
						FieldName="Topic_#Ass#_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						Message="Please enter a valid date"
						class="regularxl enterastab"
						AllowBlank="true">	
				   
				   
				   </cfif>		
								
			<cfelseif ValueClass eq "Boolean">
			
				 <cfquery name="GetValue" 
				  datasource="appsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT *
					  FROM  AssetItemTopic
					  WHERE Topic = '#GetTopics.Code#'		
					  AND   AssetId = '#URL.AssetId#'					 
				</cfquery>			
			
				<input type="Checkbox" class="enterastab"
			       name="Topic_#Ass#_#GetTopics.Code#" id="Topic_#Ass#_#GetTopics.Code#"
				   <cfif GetValue.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>			   
	    
  </cfoutput>	