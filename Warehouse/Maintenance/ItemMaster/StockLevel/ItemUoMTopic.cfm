<!--
    Copyright © 2025 Promisan

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

<cfparam name="Mode" default="Warehouse">

<cfquery name="getTopics" 
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				
		SELECT	 P.Description,P.SearchOrder,T.*, T.Description as TopicDescription
		FROM     Ref_Topic T 
					-- AND  ValueClass IN ('List','Lookup')
				 INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent	
		WHERE    T.TopicClass = 'ItemUoM'		
		AND      T.Operational = 1													
				
</cfquery>	 

<cfoutput>
		 							 
	 <table>
	 
	  <tr class="line fixlengthlist labelmedium2">  	
		  
		  	<td height="23" style="padding-left:5px"><cf_tl id="Setting"></td>
											
		    <cfloop index="itm" list="System,OE">
			
				<cfif itm eq "OE">
				<td colspan="4" style="padding-left:14px"><cf_tl id="Expert opinion"></td>										
				<cfelse>
				<td colspan="3" style="padding-left:14px"><cf_tl id="Generated"></td>
				</cfif>
												
			</cfloop>
			
	 </tr>		
																						
	<cfloop query="getTopics">
									
		  <tr class="fixlengthlist labelmedium2">  	
		  
		  	<td height="23" style="border:1px solid solid silver;padding-left:5px" class="labelmedium2">#TopicDescription#: <cfif ValueObligatory eq "1"><font color="ff0000">*</font></cfif></td>
											
		    <cfloop index="src" list="System,OE">										
			  
				<cfquery name="getValue" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  	SELECT   DateEffective, 
					         ListCode, TopicValue, TopicAttribute1, TopicAttribute2, TopicAttribute3
                    FROM     ItemUoMTopic
                    WHERE    ItemNo    = '#URL.Id#' 
					AND      UoM       = '#ItemUoM.UoM#' 
					AND      Topic     = '#Code#' 
					AND      Source    = '#src#' 
					<cfif Mode eq "Warehouse">
					AND      Warehouse = '#w#' 					
					AND      Mission is NULL 
					<cfelse>
					AND      Warehouse IS NULL 					
					AND      Mission = '#mis#' 
					</cfif>
					AND      Operational = 1
                    ORDER BY DateEffective DESC 
					
				</cfquery>											
			
				<td style="padding-left:9px;padding-right:3px;min-width:100px">										
				
				<cfif getValue.dateEffective neq "">
				    <cfset st  = dateformat(getValue.dateEffective, client.dateformatshow)>
					<cfset sts = "#Dateformat(getValue.dateEffective, 'YYYYMMDD')#">
				<cfelse>
					<cfset st = dateformat(now(), client.dateformatshow)>
					<cfset sts = "#Dateformat('01/01/2020', 'YYYYMMDD')#">
				</cfif>
																								
				<cf_setCalendarDate
				      name     = "DateEffective_#row#_#Code#_#src#"     
					  id       = "DateEffective_#row#_#Code#_#src#"   											        
				      font     = "16"
					  edit     = "Yes"
					  class    = "regularxxl"				  
					  value    = "#st#"
				      mode     = "date"> 																				
				
				</td>								
			
			<td style="min-width:80px;padding-left:3px">																		
												   
				<cfif ValueClass eq "List">
				
				    <!---
				
					<cfquery name="GetList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT	T.*, 
									P.ListCode as Selected
							FROM 	Ref_TopicList T 
									LEFT OUTER JOIN #tbcl# P ON P.Topic = T.Code AND P.ItemNo = '#url.id#'
							WHERE 	T.Code = '#Code#'  
							AND 	T.Operational = 1
							ORDER BY T.ListOrder ASC
					</cfquery>
					
					<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
						<cfif ValueObligatory eq "0">
							<option value=""></option>
						</cfif>
						<cfloop query="GetList">
							<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
						</cfloop>
					</select> 
					
					--->
					
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
							  FROM      #ListTable# T LEFT OUTER JOIN 
									   	(SELECT ItemNo, Topic, ListCode As Value 
										 FROM   Materials.dbo.#tbcl# 
										 WHERE  ItemNo='#Item.ItemNo#') P ON P.Topic = '#GetTopics.Code#' 
							  WHERE     #PreserveSingleQuotes(ListCondition)#
							  ORDER BY  #ListOrder#
					
					</cfquery>
						
					<select class="regularxxl" name="Topic_#Code#" ID="Topic_#Code#">
						<cfif ValueObligatory eq "0">
							<option value=""></option>
						</cfif>
						<cfloop query="GetList">
							<option value="#ListCode#" <cfif Selected eq ListCode>selected</cfif>>#ListValue#</option>
						</cfloop>
					</select> 	
					
					--->
					   
				<cfelseif ValueClass eq "Text">																																								
					
					<cfinput type = "Text"
				       name       = "Topic_#row#_#Code#_#src#"
				       required   = "#ValueObligatory#"					     
				       size       = "#valueLength#"
					   style      = "width:99%;text-align:right;padding-right:4px;<cfif src eq 'System'>background-color:eaeaea<cfelse>background-color:ffffff</cfif>"
					   class      = "regularxxl enterastab"
					   message    = "Please enter a #Description#"
					   value      = "#GetValue.TopicValue#"
				       maxlength  = "#ValueLength#">   
					   
				<cfelseif ValueClass eq "Numeric">											
					
					<cfinput type = "Text"
				       name       = "Topic_#row#_#Code#_#src#"
				       required   = "#ValueObligatory#"					     
				       size       = "#valueLength#"
					   style      = "width:99%;text-align:right;padding-right:4px;<cfif src eq 'System'>background-color:eaeaea<cfelse>background-color:ffffff</cfif>"											 
					   validate   = "float"
					   class      = "regularxxl enterastab"
					   message    = "Please enter a #Description#"
					   value      = "#GetValue.TopicValue#"
				       maxlength  = "#ValueLength#">   				   
					  										    
				</cfif>
								
			</td>
			
			<cfif src eq "OE">
																				
				<td style="padding-left:3px;width:60%">
				  <input class="regularxxl" style="min-width:300px;width:99%;background-color:ffffcf" type="text" 
				  name="Memo_#row#_#Code#_#src#">
				</td>
				
				</cfif>		
			
			<td style="padding-left:2px">
			
			<input type="button" value="H" style="height:28px;width:30px;border:1px solid silver" class="button10g" title="History">
			
			</td>																	
			
			</cfloop>
			
			<td style="width:10%"></td>
												
			</tr>							
		
	</cfloop>	
	
	</table>
	
</cfoutput>	
		
	