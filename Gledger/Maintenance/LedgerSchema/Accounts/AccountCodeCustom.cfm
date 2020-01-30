
<!--- central template to show custom value for a transaction in input or view mode --->

<cfquery name="GetTopics" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Operational = 1
  AND    TopicClass = 'Account'
  AND    (Mission is NULL or Mission = '#url.mission#')
</cfquery>

<table width="94%" align="center">

<tr><td height="10"></td></tr>

<cfoutput>
		<TR class="labelmedium">
		  <TD width="120" height="20">Account:</TD>
		    <td>#URL.ID1#</td>
		</TR>
</cfoutput>	

<cfif getTopics.recordcount eq "0">

<tr><td colspan="2" class="labelmedium" align="center"><font color="808080">No topics enabled for this account / entity</td></tr>

</cfif>

<cfoutput query="GetTopics">

<tr>    
	   <td width="120">#Description# :</td>
	   <td>
	    			   
	   	   
	   	 	<cfquery name="Current" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Ref_AccountTopic P
				  WHERE  P.Topic = '#Code#'		
				  AND    P.GLAccount = '#URL.id1#'			  				  
			</cfquery>
	   
	   	   <cfif ValueClass eq "List">
	   
			   <cfquery name="GetList" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT T.*, P.ListCode as Selected
					  FROM   Ref_TopicList T LEFT OUTER JOIN Ref_AccountTopic P ON P.Topic = T.Code AND P.GLAccount = '#URL.id1#'				  				  																			
					  WHERE  T.Code = '#Code#'		
					  AND    T.Operational = 1		
				</cfquery>
			   					   
			    <select name="Topic_#Code#">
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
			   					   
			    <select name="Topic_#GetTopics.Code#">
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
			       size="#valueLength#"
				   message="Please enter a #Description#"
				   value="#Current.TopicValue#"
			       maxlength="#ValueLength#">
								
			<cfelseif ValueClass eq "Boolean">
						
				<input type="Checkbox"
			       name="Topic_#Code#" 
				   <cfif Current.TopicValue eq "1">checked</cfif>
			       value="1">
			
			</cfif>
			   
	   </td>
	   
  	</tr>			   
	    
  </cfoutput>	
  
</table>  