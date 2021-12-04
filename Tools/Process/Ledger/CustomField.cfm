
<!--- central template to show custom value for a transaction in input or view mode --->

<cfquery name="Journal" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Journal
  WHERE  Journal = '#attributes.journal#' 
</cfquery>

<cfquery name="GetTopics" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Topic 
                  FROM   Ref_SpeedTypeTopic 
				  WHERE  Speedtype = '#Journal.Speedtype#')
  AND    Operational = 1
  AND    TopicClass = '#Attributes.TopicClass#'
  ORDER BY ListingOrder
</cfquery>

<cfparam name="attributes.stylelabel" default="padding-left:15px">
<cfparam name="attributes.stylefield" default="padding-left:5px">
<cfparam name="attributes.colspan"    default="1">

<cfoutput query="GetTopics">

<tr class="labelmedium2">    
	   <td style="#attributes.stylelabel#">#Description# :</td>
	   <td class="cellborder" colspan="#attributes.colspan#" style="#attributes.stylefield#">
	   
	    			   
	   <cfif attributes.Mode eq "view">
	   
	       <cfif ValueClass eq "List">
	   
			    <cfquery name="GetList" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT T.*, P.ListCode as Selected
				  FROM Ref_TopicList T, TransactionHeaderTopic P
				  WHERE T.Code = '#Code#'
				  AND P.Topic = T.Code
				  AND P.ListCode = T.ListCode
				  AND P.Journal = '#Attributes.Journal#'				  
				  AND P.JournalSerialNo = '#Attributes.JournalSerialNo#'
				</cfquery>
				
				<cfif GetList.ListValue neq "">
			   
				   #GetList.ListValue#
				   
				<cfelse>
				
				   N/A
				   
				</cfif>  
			
			<cfelse>
						
				 <cfquery name="GetList" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   TransactionHeaderTopic P
				  WHERE  P.Topic = '#Code#'		
				  AND P.Journal = '#Attributes.Journal#'				  
				  AND P.JournalSerialNo = '#Attributes.JournalSerialNo#'
				  				 				 			  
				</cfquery>
				
				<cfif GetList.TopicValue neq "">
				
				   <cfif ValueClass eq "Boolean">
				   
					   <cfif GetList.TopicValue eq "1">Yes<cfelse>No</cfif>
				   
				   <cfelse>
				   
				   		#GetList.TopicValue#
						
				   </cfif>
			   						   
				<cfelse>
				
				   N/A
				   
				</cfif>  					
			
			</cfif>			    
		
	   <cfelse>
	   
	   	 	<cfquery name="Current" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   TransactionHeaderTopic P
				  WHERE  P.Topic = '#Code#'		
				  AND    P.Journal = '#Attributes.Journal#'				  
				  AND    P.JournalSerialNo = '#Attributes.JournalSerialNo#'
			</cfquery>
	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM Ref_TopicList T LEFT OUTER JOIN TransactionHeaderTopic P ON P.Topic = T.Code AND P.Journal = '#Attributes.Journal#'				  
				  				AND P.JournalSerialNo = '#Attributes.JournalSerialNo#' 																	
					  WHERE T.Code = '#Code#'		
					  AND T.Operational = 1		
				</cfquery>
			   					   
			    <select name="Topic_#Code#" id="Topic_#Code#" class="regularxl enterastab">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#GetList.ListCode#" <cfif GetList.Selected eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
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
					  ORDER BY #ListDisplay#
				</cfquery>
			   					   
			    <select name="Topic_#GetTopics.Code#" id="Topic_#GetTopics.Code#" class="regularxl enterastab">
				<cfif ValueObligatory eq "0">
				<option value=""></option>
				</cfif>
				<cfloop query="GetList">
					<option value="#PK#" <cfif GetList.Display eq Current.TopicValue>selected</cfif>>#Display#</option>
				</cfloop>
				</select>						
				
			<cfelseif ValueClass eq "Text">
			
				<cfinput type="Text"
			       name="Topic_#Code#"
			       required="#ValueObligatory#"		
				   class="regularxl enterastab"			     
			       size="#valueLength#"
				   message="Please enter a #Description#"
				   value="#Current.TopicValue#"
			       maxlength="#ValueLength#">
				   
			<cfelseif ValueClass eq "Memo">
			
				<cftextarea name="Topic_#Code#" style="padding:3px;font-size:15px;width:95%;height:50px">#Current.TopicValue#</cftextarea>
											
			<cfelseif ValueClass eq "Boolean">
						
				<input type="Checkbox" class="radiol enterastab"
			       name="Topic_#Code#" 
				   id="Topic_#Code#"
				   <cfif Current.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
		
	   </cfif>	
	   
	   </td>
	   
  	</tr>			   
	    
  </cfoutput>	