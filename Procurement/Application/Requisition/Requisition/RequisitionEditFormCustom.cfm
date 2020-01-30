
<!--- define custom topics --->

<cfquery name="Line" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   RequisitionLine 
		WHERE  RequisitionNo = '#URL.Id#'		
</cfquery>	

<cfquery name="Check" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   ItemMaster I, Ref_EntryClass R
	WHERE  I.EntryClass = R.Code
	AND    I.Code = '#url.master#'		
</cfquery>	

<table width="100%">

<cfif Check.EmployeeLookup eq "1" and (Check.CustomDialog eq "Travel" or Check.CustomDialogOverwrite eq "Travel")>

<tr><td style="height:1px"></td></tr>

<tr class="labelmedium">
	<td height="38" style="min-width:171px"><cf_tl id="Individual">:</td>
	<td width="100%" style="padding-left:1px">
		  
		  	<cfoutput>
			
		    <cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Person
					WHERE PersonNo = '#Line.PersonNo#'	
			</cfquery>
			
			 <table cellspacing="0" cellpadding="0">
			 
				 <tr>
											
				 <cfif url.Mode eq "View">
				 
				 <td class="labelmedium">
					 <cfoutput>
					 <a href="javascript:EditPerson('#Line.PersonNo#')">#Person.FirstName# #Person.LastName# (#Person.IndexNo#)</a>
					 </cfoutput>
				 </td>
				 
				 <cfelse>
				 
					<td>
					
					<input type="Text"
					       name="fullname"
		                   id="fullname"
					       value="#Person.FirstName# #Person.LastName#"			     
					       required="Yes"
					       visible="Yes"
					       enabled="Yes"		     
					       size="60"
					       maxlength="60"
					       class="regularxl"
					       readonly  
						   style="text-align: left;">
					   
					</td>
					
					<td style="padding-left:2px">   
				   		<input type="text" name="indexno"   id="indexno"   class="regularxl" readonly value="#Person.IndexNo#" size="8" maxlength="10" style="text-align: center;">	
					</td>
					
					<td style="padding-left:2px">
					
					  <img src="#SESSION.root#/Images/search.png" alt="Select Employee" name="img9" 
						  onMouseOver="document.img9.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
						  onClick="selectperson('webdialog','personno','indexno','lastname','firstname','fullname','','')">		
					</td>
					
					<input type="hidden"  name="personno"  id="personno"  size="8" readonly value="#Person.PersonNo#">
				    <input type="hidden"  name="lastname"  id="lastname"  value="#Person.LastName#">
				    <input type="hidden"  name="firstname" id="firstname" value="#Person.FirstName#">
					
				</cfif>	
				
				</tr>
			
			</table>
				
			</cfoutput>	
							
	 </td>  
</tr>	

</cfif>

<cfquery name="Standard" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT R.* 
	FROM   ItemMasterStandard I, Ref_Standard R
	WHERE  I.StandardCode = R.Code
	AND    R.Operational = 1
	AND    I.ItemMaster = '#url.master#'		
</cfquery>	

<cfif Standard.recordcount gt "0">
		
	<tr class="labelmedium">    
		   <td valign="top" style="padding-top:4px;height:30px;min-width:171px">		  
		   <cf_tl id="Procurement Standard">:</td>
		   <td width="100%" style="padding-left:3px">
		   <table cellspacing="0" cellpadding="0">
		   
		       <cfif Standard.recordcount gte "1">
		       <tr class="line labelmedium">
			   <td width="40"></td>
		       <TD width="40">Code</TD>
			   <td width="400">Standard</td>
			   <td width="200">Scope</td>
			   <td width="100">Contract</td>
			   <td width="100">Expiration</td>
			   </tr>
			  			   
			   </cfif>
			   
			   <tr>
			       <td width="25"><input type="radio" class="radiol" name="StandardCode" id="StandardCode" value="" <cfif line.standardcode eq "">checked</cfif>></td>
				   <td height="20" class="labelmedium" colspan="5">Not applicable</td>			   	   
			   </tr>	
			   <cfoutput query="Standard">
			   			   	   
				   <tr class="linedotted labelmedium">
					   <td width="25"><input class="radiol" type="radio" name="StandardCode" id="StandardCode" value="#Code#" <cfif line.standardcode eq code>checked</cfif>></td>
					   <td height="18" width="100">#Code#</td>
					   <td width="400">#Description#</td>		
					   <td width="200">#Memo#</td> 
					   <td width="100">#Reference#</td>  
					   <td width="100">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
				   </tr>	
				   
				     <cf_filelibraryCheck			    	
    					DocumentPath  = "Standards"
						SubDirectory  = "#Code#" 
						Filter        = "">	
					
					<cfif Files gte "1">
					
					   <tr>
					   <td></td>
					   <td colspan="5">
				   
					   <cf_filelibraryN
							DocumentPath  = "Standards"
							SubDirectory  = "#Code#" 	
							Filter        = ""					
							LoadScript    = "1"		
							EmbedGraphic  = "no"
							Width         = "100%"
							Box           = "att#Code#"
							Insert        = "no"
							Remove        = "no">	
						
						</td>
						</tr>
					
					</cfif>
				      
			   </cfoutput>
		   </table>
		  </td>
		  
	</tr>	

</cfif>  

<cfquery name="GetTopics" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Code 
                  FROM   Ref_TopicEntryClass 
				  WHERE  EntryClass = '#Check.EntryClass#'
				 )
  AND    (Mission = '#Line.Mission#' or Mission is NULL)				 
  AND    Operational = 1 
</cfquery>

<cfoutput query="GetTopics">

<tr class="labelmedium">    
	   <td style="height:30px;min-width:171px"><cf_tl id="#Description#">:</td>
	   <td width="100%" style="padding-left:0px">
	    			   
	   <cfif URL.Mode neq "edit">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT   T.*, P.ListCode as Selected
				  FROM     Ref_TopicList T, RequisitionLineTopic P
				  WHERE    T.Code = '#GetTopics.Code#'
				  AND      P.Topic = T.Code
				  AND      P.ListCode = T.ListCode
				  AND      P.RequisitionNo = '#URL.ID#'		  
				  ORDER BY T.ListOrder
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   <cf_tl id="N/A">
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   RequisitionLineTopic P
				  WHERE  P.Topic = '#GetTopics.Code#'						 
				  AND    P.RequisitionNo = '#URL.ID#'				  
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="No"></cfif>
					   
				   <cfelseif ValueClass eq "Date">
				   
				        <cftry>
				   		#dateformat(GetList.TopicValue,CLIENT.DateFormatShow)#			
						<cfcatch></cfcatch>	   	   
						</cftry>
				   
				   <cfelse>
				   
				   		#GetList.TopicValue#
						
				   </cfif>
			   						   
				<cfelse>
				
				   <cf_tl id="N/A">
				   
				</cfif>  					
			
			</cfif>			    
		
	   <cfelse>
	   
	   	   <cfquery name="GetValue" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   RequisitionLineTopic
				  WHERE  Topic = '#GetTopics.Code#'		
				  AND    RequisitionNo = '#URL.ID#'					 
			</cfquery>			
	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM   Ref_TopicList T LEFT OUTER JOIN RequisitionLineTopic P ON P.Topic = T.Code AND P.RequisitionNo = '#URL.ID#'
					  WHERE  T.Code = '#GetTopics.Code#'		
					  AND    T.Operational = 1		
 					  ORDER  BY T.ListOrder
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
				
				<cfquery name="qSelected" dbtype="query">
					SELECT * 
					FROM   GetList
					WHERE  Selected IS NOT NULL 
				</cfquery>		
					
				<cfif qSelected.recordcount neq 0>
					<cfset def = qSelected.Selected>
				<cfelse>				    
					<cfset def = Def.ListCode>				
				</cfif>			
				
			    <select class="regularxl" name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#">
				
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>		
					
					<cfloop query="GetList">					  
						<option value="#GetList.ListCode#" <cfif compare(GetList.ListCode,Def) eq 0>selected</cfif>>#GetList.ListValue#</option>
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
					  WHERE    #PreserveSingleQuotes(ListCondition)#
					  ORDER BY #ListOrder#
				</cfquery>

			    <select class="regularxl" name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#">
					<cfif ValueObligatory eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="GetList">
						<option value="#PK#" <cfif compare(GetList.PK,GetValue.TopicValue) eq 0>selected</cfif>> #Display#</option>
					</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
										
				<input type="Text"
				       name="Topic_#GetTopics.Code#"
	                   id="Topic_#GetTopics.Code#"
				       required="#ValueObligatory#"					     
				       size="#valueLength#"
					   class="regularxl"
					   message="Please Enter a #GetTopics.Description#"
					   value="#GetValue.TopicValue#"
				       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Date">
						
				   <cf_intelliCalendarDate9
						FieldName="Topic_#GetTopics.Code#" 
						Default="#dateformat(GetValue.TopicValue,CLIENT.DateFormatShow)#"
						class="regularxl"
						AllowBlank="#ValueObligatory#">	
								
			<cfelseif ValueClass eq "Boolean">	
							
				<input type="Checkbox" class="radiol"
				       name="Topic_#GetTopics.Code#" 
	                   id="Topic_#GetTopics.Code#"
					   <cfif GetValue.TopicValue eq "1">checked</cfif>
				       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>	
		    
 </cfoutput>	
  
 </table>
 